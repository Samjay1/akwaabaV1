import 'package:akwaaba/Networks/auth_api.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailTEC = TextEditingController();

  bool _loading = false;
  List<AccountType> _accountTypes = [];

  AccountType? selectedAccountType;

  List<AccountType> get accountTypes => _accountTypes;
  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> getAccountTypes() async {
    try {
      _accountTypes = await AuthAPI.getAccountTypes();
      debugPrint('Account types: ${_accountTypes.length}');
      if (_accountTypes.isNotEmpty) {
        selectedAccountType = _accountTypes[0];
      }
    } catch (err) {
      debugPrint('Error MC: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  validateField(BuildContext context) {
    if (emailTEC.text.isEmpty || selectedAccountType == null) {
      showInfoDialog(
        'ok',
        context: context,
        title: 'Sorry',
        content:
            'Email or account type fields cannot be empty. Please try again.',
        onTap: () => Navigator.pop(context),
      );
      return;
    }
    resetPassword(context);
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      setLoading(true);
      var response = await AuthAPI.resetPassword(
        accountTypeId: selectedAccountType!.id!,
        email: emailTEC.text.trim(),
      );

      debugPrint('Account types: ${_accountTypes.length}');
      var title = '';
      var message = '';
      if (response.nonFieldErrors != null) {
        title = 'Sorry';
        message = response.nonFieldErrors![0];
      } else {
        title = 'Success';
        message = response.msg!;
        clearFields();
      }
      showInfoDialog(
        'ok',
        context: context,
        title: title,
        content: message,
        onTap: () {
          if (response.msg != null) {
            openEmailApp(context);
          }
          Navigator.pop(context);
        },
      );

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error RP: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  clearFields() {
    selectedAccountType = null;
    emailTEC.text.trim();
  }
}
