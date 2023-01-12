import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/Networks/api_responses/coordinates_response.dart';
import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/models/attendance/attendance.dart';
import 'package:akwaaba/models/attendance/excuse_model.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceAPI {
  static final baseUrl = 'https://db-api-v2.akwaabasoftware.com';
  late SharedPreferences prefs;

  static Future<MeetingAttendanceResponse> getAttendanceList({
    required MeetingEventModel meetingEventModel,
    required String filterDate,
  }) async {
    MeetingAttendanceResponse attendanceResponse;
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/attendance?filter_branch=${meetingEventModel.branchId}&filter_date=$filterDate&meetingEventId=${meetingEventModel.id}');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Attendance Response: ${jsonDecode(response.body)}");
      attendanceResponse = MeetingAttendanceResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return attendanceResponse;
  }

  // validate member attendance - single
  static Future<Attendance> validateMemberAttendance({
    required int clockingId,
  }) async {
    Attendance attendance;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/validate-attendance');
      http.Response response = await http.post(
        url,
        body: json.encode({
          'clockingId': clockingId,
        }),
        headers: await getAllHeaders(),
      );
      debugPrint("Validate Attendance Response: ${jsonDecode(response.body)}");
      attendance = Attendance.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return attendance;
  }

  // validate member attendance - bulk
  static Future<String> validateMemberAttendances({
    required List<int> clockingIds,
  }) async {
    String message;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/validate-attendance-bulk');
      http.Response response = await http.post(
        url,
        body: json.encode({
          'clockingIds': clockingIds,
        }),
        headers: await getAllHeaders(),
      );
      debugPrint("Validate Attendances Response: ${jsonDecode(response.body)}");
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // submit an excuse data source
  static Future<ExcuseModel> submitExcuse({
    required int meetingEventId,
    required int clockingId,
    required String excuse,
  }) async {
    ExcuseModel excuseModel;
    var url =
        Uri.parse('${getBaseUrl()}/attendance/meeting-event/attendance-excuse');
    try {
      http.Response response = await http.post(
        url,
        body: {
          'meetingEventId': meetingEventId.toString(),
          'clockingId': clockingId.toString(),
          'enteredBy': "0",
          'excuse': excuse,
        },
        headers: await getTokenHeader(),
      );
      debugPrint("Submit Excuse Response: ${jsonDecode(response.body)}");
      excuseModel = ExcuseModel.fromJson(await returnResponse(response));
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return excuseModel;
  }

  static Future<Map<String, String>> getTokenHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberToken = prefs.getString('token');
    return {
      'Authorization': 'Token $memberToken',
    };
  }

  static Future<Map<String, String>> getAllHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberToken = prefs.getString('token');
    return {
      'Authorization': 'Token $memberToken',
      'Content-Type': 'application/json'
    };
  }

  static bool isDevelopment = false;

  static String getBaseUrl() {
    if (isDevelopment) {
      return 'https://db-api-v2.akwaabasoftware.com';
    } else {
      return 'https://db-api-v2.akwaabasoftware.com';
    }
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
}
