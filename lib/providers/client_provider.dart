import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/Networks/notification_api.dart';
import 'package:akwaaba/fcm/messaging_service.dart';
import 'package:akwaaba/models/admin/admin_profile.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/client_model.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Networks/admin_api.dart';
import '../versionOne/main_page.dart';

class ClientProvider extends ChangeNotifier {
  ClientAccountInfo? _user;
  String? _token;
  bool _showLoginProgressIndicator = false;
  AdminProfile? _adminProfile;
  Branch? _branch;
  bool _loading = false;

  bool get loading => _loading;
  get adminProfile => _adminProfile;
  get getUser => _user;
  get branch => _branch;
  get showLoginProgressIndicator => _showLoginProgressIndicator;
  get clientToken => _token;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void validateInputFields({
    required BuildContext context,
    required bool isAdmin,
    required String phoneEmail,
    required String password,
  }) {
    FocusManager.instance.primaryFocus?.unfocus(); //hide keyboard
    if (phoneEmail.isEmpty) {
      showErrorSnackBar(context, "Please input your email address or phone");
      return;
    }
    if (password.isEmpty) {
      showErrorSnackBar(context, "Please input your password");
      return;
    }
    login(
      context: context,
      phoneEmail: phoneEmail,
      password: password,
      isAdmin: isAdmin,
    );
  }

  // save token to backend
  Future<void> _saveFirebaseToken() async {
    var user = await SharedPrefs().getAdminProfile();
    var msg = await NotificationAPI.saveClientFirebaseToken(
      clientId: user!.id!,
      token: await MessagingService().getToken(),
    );
    debugPrint('ClientId: ${user.id}');
    debugPrint('Token: ${await MessagingService().getToken()}');
    debugPrint(msg);
  }

  Future<void> login(
      {required BuildContext context,
      required bool isAdmin,
      var phoneEmail,
      var password}) async {
    try {
      setLoading(true);
      var value = await UserApi()
          .login(context: context, phoneEmail: phoneEmail, password: password);
      if (value == 'login_error') {
        setLoading(false);
        // ignore: use_build_context_synchronously
        showErrorToast("account and password combination not found");
        return;
      }
      if (value == 'network_error') {
        setLoading(false);
        // ignore: use_build_context_synchronously
        showErrorSnackBar(context, "No internet connection");
        return;
      }
      setLoading(false);
      debugPrint('USER INFO: $value');
      _user = value;
      // save client firebase token
      _saveFirebaseToken();
      if (context.mounted) {
        getAdminBranch(
          context: context,
          phoneEmail: phoneEmail,
          password: password,
        );
      }
    } catch (err) {
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get branch of the admin
  Future<void> getAdminBranch(
      {required BuildContext context,
      required var phoneEmail,
      required var password}) async {
    try {
      var profile = await SharedPrefs().getAdminProfile();
      _branch = await MemberAPI().getBranch(
        branchId: profile!.branchId,
        //adminProfile.branchId!,
      );
      debugPrint('Branch: ${_branch!.name}');
      if (context.mounted) {
        navigateToMainPage(
          context: context,
          phoneEmail: phoneEmail,
          password: password,
        );
      }
    } catch (err) {
      setLoading(false);
      debugPrint('Error Group: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void navigateToMainPage({
    required BuildContext context,
    required var phoneEmail,
    required var password,
  }) {
    showNormalToast('Login successful');
    Provider.of<GeneralProvider>(context, listen: false)
        .setAdminStatus(isAdmin: true);
    SharedPrefs().setUserType(userType: "admin");
    SharedPrefs()
        .saveLoginCredentials(emailOrPhone: phoneEmail, password: password);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainPage(),
      ),
    );
  }

  Future<void> setClientToken({required token}) async {
    _token = token;
    notifyListeners();
  }

  setAdminProfileInfo({required AdminProfile adminProfile}) {
    _adminProfile = adminProfile;
    notifyListeners();
  }
}
