import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_responses/clockin_response.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/recentClockModal.dart';
import 'package:akwaaba/models/members/deviceRequestModel.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/members/member_profile.dart';

class MemberAPI {
  final baseUrl = 'https://db-api-v2.akwaabasoftware.com';
  late SharedPreferences prefs;

  Future<String> userLogin(
      {required String phoneEmail,
      required String password,
      required bool checkDeviceInfo}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password,
        "checkDeviceInfo": checkDeviceInfo
      };

      debugPrint("Data $data");

      http.Response response = await http.post(
          Uri.parse('$baseUrl/members/login'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var memberToken = decodedResponse['token'];
        prefs.setString('memberToken', memberToken);
        debugPrint('MEMBER TOKEN---------- --------------------- $memberToken');
        return response.body;
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
        return '';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");

      return '';
    }
  }

  Future login(
      {required BuildContext context,
      required String phoneEmail,
      required String password,
      required bool checkDeviceInfo}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password,
        "checkDeviceInfo": checkDeviceInfo
      };

      debugPrint("Data $data");

      http.Response response = await http.post(
          Uri.parse('$baseUrl/members/login'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var memberToken = decodedResponse['token'];
        var memberInfo = decodedResponse['user'];
        prefs.setString('memberToken', memberToken);
        debugPrint('MEMBER TOKEN---------- --------------------- $memberToken');

        debugPrint('MEMBER INFO---------- --------------------- $memberInfo');
        return MemberProfile.fromJson(memberInfo, memberToken);
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
        return '';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");

      return '';
    }
  }

  void requestDeviceActivation(
      {required memberId,
      memberAccountType,
      systemDevice,
      deviceType,
      deviceId}) async {
    try {
      var data = {
        'memberId': memberId,
        'memberAccountType': memberAccountType,
        'systemDevice': systemDevice,
        'deviceType': deviceType,
        'deviceId': deviceId
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? memberToken = prefs.getString('memberToken');

      http.Response response = await http.post(
          Uri.parse('$baseUrl/attendance/clocking-device/request'),
          body: json.encode(data),
          headers: {
            'Authorization': 'Token $memberToken',
            'Content-Type': 'application/json'
          });
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        debugPrint('DEVICE ACTIVATION REQUEST -------------- $decodedResponse');
        debugPrint(
            '2.MEMBER TOKEN---------- --------------------- $memberToken');
        // return response.body;
        showErrorToast("Device Activation request sent.");
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
    }
  }

  Future<List<DeviceRequestModel>> getDeviceRequestList(
      BuildContext context, String memberToken, memberID) async {
    print('UserApi token-transactions $memberToken');
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$baseUrl/attendance/clocking-device/request?ordering=-id&memberId=$memberID'),
          headers: {
            'Authorization': 'Token $memberToken',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("DeviceRequestModel success: $decodedresponse");
        Iterable dataList = decodedresponse['results'];
        return dataList
            .map((data) => DeviceRequestModel.fromJson(data))
            .toList();
      } else {
        print('DeviceRequestModel error ${jsonDecode(response.body)}');
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network issue')));
      return [];
    }
  }


  Future<Object?> getRecentClocking(
      BuildContext context, String memberToken, memberID) async {
    print('UserApi token-transactions $memberToken');
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$baseUrl/attendance/meeting-event/attendance/lastseen-member/$memberID'),
          headers: {
            'Authorization': 'Token $memberToken',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("RecentClocking success: $decodedresponse");
        Iterable dataList = decodedresponse['results'];
        // return dataList
        //     .map((data) => RecentClockModal.fromJson(data))
        //     .toList();
        return 'hello';
      } else {
        print('DeviceRequestModel error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }
}
