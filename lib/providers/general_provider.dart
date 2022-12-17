import 'package:flutter/cupertino.dart';

class GeneralProvider with ChangeNotifier{
  bool _userIsAdmin=false;
  bool _userIsSubscribed=true;

  get userIsAdmin=>_userIsAdmin;
  get userIsSubscribed=>_userIsSubscribed;


  setAdminStatus({required bool isAdmin}){
    _userIsAdmin=isAdmin;
    notifyListeners();
  }

  setUserSubscruptionStatus({required bool status}){
    _userIsSubscribed=status;
    notifyListeners();
  }
}