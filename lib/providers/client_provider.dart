import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/admin/admin_profile.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/client_model.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Networks/admin_api.dart';
import '../versionOne/main_page.dart';

class ClientProvider extends ChangeNotifier {
  ClientAccountInfo? _user;
  String? _token;
  bool _showLoginProgressIndicator = false;
  AdminProfile? _adminProfile;

  get adminProfile => _adminProfile;
  get getUser => _user;
  get showLoginProgressIndicator => _showLoginProgressIndicator;
  get clientToken => _token;

  Future<void> login(
      {required BuildContext context, var phoneEmail, var password}) async {
    debugPrint('PROVIDER LOGIN CLIENT');
    _showLoginProgressIndicator = true;
    UserApi()
        .login(context: context, phoneEmail: phoneEmail, password: password)
        .then((value) {
      _showLoginProgressIndicator = false;
      notifyListeners();
      if (value == 'login_error') {
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      } else if (value == 'network_error') {
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _user = value;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainPage(),
          ),
        );
      }
    });
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
