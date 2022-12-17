import 'dart:convert';

import 'package:akwaaba/models/admin/admin_profile.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static final SharedPrefs _instance = SharedPrefs.internal();
  factory SharedPrefs()=>_instance;

  static SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async=>_sharedPreferences?? await SharedPreferences.getInstance();

  SharedPrefs.internal();

  logOut()async{
    var sd =await sharedPreferences;
    sd.clear();
  }


  setUserType({required String userType})async{
    var sd =await sharedPreferences;
    sd.setString("user_type", userType);
  }

  Future<String?>getUserType()async{
    var sd =await sharedPreferences;
    if(sd.getString("user_type")!=null){
      return  sd.getString("user_type");
    }else{
      return "";
    }

  }

  Future<void>saveMemberInfo({required MemberProfile memberProfile})async {
    var sd =await sharedPreferences;
    sd.setString("member_info", json.encode(memberProfile.toJson()));
  }

  Future<MemberProfile?>getMemberProfile()async{
    var sd =await sharedPreferences;
    if(sd.getString("member_info")!=null){
      try{
        return MemberProfile.fromJson(json.decode(sd.getString("member_info")!));
      }catch(e){
        return null;
      }
    }
    return null;
  }

  Future<void>saveAdminInfo({required AdminProfile adminProfile})async {
    var sd =await sharedPreferences;
    sd.setString("admin_info", json.encode(adminProfile.toJson()));
  }

  Future<AdminProfile?>getAdminProfile()async{
    var sd =await sharedPreferences;
    if(sd.getString("admin_info")!=null){
      try{
        return AdminProfile.fromJson(json.decode(sd.getString("admin_info")!));
      }catch(e){
        return null;
      }
    }
    return null;
  }

  Future<void>saveLoginCredentials({required String emailOrPhone, required String password})async{
    var sd =await sharedPreferences;
    sd.setStringList("login_credentials", [emailOrPhone,password]);
    //index 0 is email or phone,  1 is password
  }

  Future<List<String>>getLoginCredentials()async{
    var sd =await sharedPreferences;
    if(sd.getStringList("login_credentials")!=null){
      return sd.getStringList("login_credentials")??[];
    }else{
      [];
    }
    return[];
  }


}