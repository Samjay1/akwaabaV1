import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/members/deviceRequestModel.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';
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
        prefs.setString('token', memberToken);
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

  // Get client info of member
  Future<ClientAccountInfo> getClientAccountInfo({
    required int clientId,
  }) async {
    ClientAccountInfo accountInfo;
    var url = Uri.parse('$baseUrl/clients/account/$clientId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Client Info Res: ${jsonDecode(response.body)}");
      var res = jsonDecode(response.body);
      accountInfo = ClientAccountInfo.fromMap(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return accountInfo;
  }

  // get a  branch
  Future<Branch> getBranch({
    required int branchId,
  }) async {
    Branch branch;

    var url = Uri.parse('$baseUrl/clients/branch/$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Branch Res: ${jsonDecode(response.body)}");
      var res = jsonDecode(response.body);
      branch = Branch.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return branch;
  }

  // get a  branch
  Future<String> getIdentityNumber({
    required int memberId,
  }) async {
    String identity;

    var url = Uri.parse(
        '$baseUrl/members/member-identity?filter_memberIds=$memberId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Identity Res: ${jsonDecode(response.body)}");
      identity = jsonDecode(response.body)['results'][0]['identity'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return identity;
  }

  static Future<Map<String, String>> getAllHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberToken = prefs.getString('token');
    return {
      'Authorization': 'Token $memberToken',
      'Content-Type': 'application/json'
    };
  }

  Future<MemberProfile> login(
      {required BuildContext context,
      required String phoneEmail,
      required String password,
      required bool checkDeviceInfo}) async {
    MemberProfile? memberProfile;
    try {
      var data = {
        'phone_email': phoneEmail,
        'password': password,
        "checkDeviceInfo": checkDeviceInfo
      };

      debugPrint("Data: $data");

      http.Response response = await http.post(
        Uri.parse('$baseUrl/members/login'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      var decodedResponse = await returnResponse(response);
      memberProfile = MemberProfile.fromJson(
        decodedResponse,
      );
      //debugPrint("non_field_errors: ${memberProfile.nonFieldErrors}");
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return memberProfile;
  }

  // return response from api
  static dynamic returnResponse(http.Response response) async {
    if (kDebugMode) {
      debugPrint(response.statusCode.toString());
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        // print(response.body);
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      case 400:
        debugPrint('Bad Request');
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      //throw BadRequestException(responseJson['message']);
      case 401:
      case 403:
        debugPrint('UnauthorisedException');
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      //throw UnauthorisedException(responseJson['message']);
      case 500:
      default:
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
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
}
