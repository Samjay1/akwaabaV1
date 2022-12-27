import 'dart:collection';
import 'dart:io';

import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/general/deviceInfoModel.dart';
import '../utils/widget_utils.dart';
import '../versionOne/main_page.dart';

class MemberProvider with ChangeNotifier {
  String? _memberToken;
  MemberProfile? _memberProfile;
  DeviceInfoModel? deviceInfoModel;
  bool _showLoginProgressIndicator = false;
  bool _loading = false;
  var deviceRequestList;

  List<MeetingEventModel> _meetingEventList = [];
  List<MeetingEventModel> _upcomingMeetingEventList = [];

  // Retrieve all meetings
  List<MeetingEventModel> get todayMeetings => _meetingEventList;
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;
  bool get loading => _loading;
  get memberToken => _memberToken;
  get memberProfile => _memberProfile;

  Future<void> memberLogin({required}) async {}

  setLoading(bool loading) {
    _loading = !loading;
    notifyListeners();
  }

  setToken({required String token}) {
    _memberToken = token;
    notifyListeners();
  }

  setMemberProfileInfo({required MemberProfile memberProfile}) {
    _memberProfile = memberProfile;
    notifyListeners();
  }

  Future<void> login(
      {required BuildContext context,
      var phoneEmail,
      var password,
      required bool checkDeviceInfo}) async {
    debugPrint('PROVIDER LOGIN CLIENT');
    _showLoginProgressIndicator = true;
    MemberAPI()
        .login(
            context: context,
            phoneEmail: phoneEmail,
            password: password,
            checkDeviceInfo: checkDeviceInfo)
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
        _memberProfile = value;
        debugPrint('TESTING ${value.memberToken}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainPage()));
      }
    });
    notifyListeners();
  }

  Future gettingDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //Android
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

    if (Platform.isAndroid) {
      var deviceInfoObj = {
        'systemDevice': 3,
        'deviceType': androidDeviceInfo.brand,
        'deviceId': androidDeviceInfo.id
      };

      print('Running on $deviceInfoObj'); //deviceType

      deviceInfoModel = DeviceInfoModel.fromJson(deviceInfoObj);
    } else if (Platform.isIOS) {
      var deviceInfoObj = {
        'systemDevice': 2,
        'deviceType': iosDeviceInfo.systemVersion,
        'deviceId': iosDeviceInfo.identifierForVendor
      };
      print('Running on ${iosDeviceInfo.utsname.machine}');
      deviceInfoModel = DeviceInfoModel.fromJson(deviceInfoObj);
    }
    return null;
  }

  void callDeviceRequestList(
      {required var memberToken,
      required var memberID,
      required BuildContext context}) async {
    // print('UserProvider token $token');
    deviceRequestList =
        await MemberAPI().getDeviceRequestList(context, memberToken, memberID);
    notifyListeners();
  }

  Future<void> getTodayMeetingEvents({
    required var memberToken,
    required BuildContext context,
  }) async {
    debugPrint("callTodayMeetingEventList");
    _meetingEventList = await MemberAPI().getTodayMeetingEventList(
      context,
      memberToken,
    );
    notifyListeners();
  }

  Future<void> getUpcomingMeetingEvents({
    required var memberToken,
    required BuildContext context,
  }) async {
    debugPrint("callUpcomingMeetingEventList");
    _upcomingMeetingEventList = await MemberAPI().getUpcomingMeetingEventList(
      context,
      memberToken,
    );
    notifyListeners();
  }
}
