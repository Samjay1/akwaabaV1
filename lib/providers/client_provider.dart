import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/admin/admin_profile.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/client_model.dart';
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
  bool _loading = false;

  bool get loading => _loading;
  get adminProfile => _adminProfile;
  get getUser => _user;
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
      _user = value;
      Provider.of<GeneralProvider>(context, listen: false)
          .setAdminStatus(isAdmin: isAdmin);
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
    } catch (err) {
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
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
