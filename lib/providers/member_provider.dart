import 'package:akwaaba/models/members/member_profile.dart';
import 'package:flutter/cupertino.dart';

class MemberProvider extends ChangeNotifier{
  String? _memberToken;
  MemberProfile? _memberProfile;


  get memberToken=>_memberToken;
  get memberProfile=>_memberProfile;


  Future<void>memberLogin({required })async {}

  setToken({required String token}){
      _memberToken=token;
      notifyListeners();
  }

  setMemberProfileInfo({required MemberProfile memberProfile}){
    _memberProfile=memberProfile;
    notifyListeners();
  }

}