import 'dart:convert';

import 'package:akwaaba/models/admin/admin_profile.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:akwaaba/providers/all_events_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/versionOne/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs.internal();
  factory SharedPrefs() => _instance;

  static SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async =>
      _sharedPreferences ?? await SharedPreferences.getInstance();

  SharedPrefs.internal();

  final String locationKey = 'bg_location';

  setUserType({required String userType}) async {
    var sd = await sharedPreferences;
    sd.setString("user_type", userType);
  }

  Future<String?> getUserType() async {
    var sd = await sharedPreferences;
    if (sd.getString("user_type") != null) {
      return sd.getString("user_type");
    } else {
      return "";
    }
  }

  setBackgroundLocationEnabled({required bool enable}) async {
    var sd = await sharedPreferences;
    sd.setBool(locationKey, enable);
  }

  Future<bool?> isBackgroundLocationEnabled() async {
    var sd = await sharedPreferences;
    var status = sd.getBool(locationKey);
    status == null ? status = false : status = status;
    return status;
  }

  Future<void> saveMemberInfo({required MemberProfile memberProfile}) async {
    var sd = await sharedPreferences;
    sd.setString("member_info", json.encode(memberProfile.toJson()));
  }

  Future<MemberProfile?> getMemberProfile() async {
    var sd = await sharedPreferences;
    if (sd.getString("member_info") != null) {
      try {
        return MemberProfile.fromJson(
            json.decode(sd.getString("member_info")!));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveAdminInfo({required AdminProfile adminProfile}) async {
    var sd = await sharedPreferences;
    sd.setString("admin_info", json.encode(adminProfile.toJson()));
  }

  Future<AdminProfile?> getAdminProfile() async {
    var sd = await sharedPreferences;
    if (sd.getString("admin_info") != null) {
      try {
        return AdminProfile.fromJson(json.decode(sd.getString("admin_info")!));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveLoginCredentials(
      {required String emailOrPhone, required String password}) async {
    var sd = await sharedPreferences;
    sd.setStringList("login_credentials", [emailOrPhone, password]);
    //index 0 is email or phone,  1 is password
  }

  Future<List<String>> getLoginCredentials() async {
    var sd = await sharedPreferences;
    if (sd.getStringList("login_credentials") != null) {
      return sd.getStringList("login_credentials") ?? [];
    } else {
      [];
    }
    return [];
  }

//  ------------------------------- SAVES bools
  Future<void> saveDeviceRequestState(
      {required bool deviceRequestState}) async {
    var sd = await sharedPreferences;
    sd.setBool("deviceRequestState", deviceRequestState);
    //index 0 is email or phone,  1 is password
  }

  Future<bool?> getDeviceRequestState() async {
    var sd = await sharedPreferences;
    if (sd.getBool("deviceRequestState") != null) {
      return sd.getBool("deviceRequestState");
    } else {
      return null;
    }
  }

  logOut() async {
    var sd = await sharedPreferences;
    sd.clear();
  }

  Future<bool> clear() async {
    var sd = await sharedPreferences;
    return sd.clear();
  }

  void logout(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).clearData();
    Provider.of<AllEventsProvider>(context, listen: false).clearData();
    Provider.of<MemberProvider>(context, listen: false).clearData();
    Provider.of<ClientProvider>(context, listen: false).clearData();
    clear();
    setBackgroundLocationEnabled(enable: true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }
}
