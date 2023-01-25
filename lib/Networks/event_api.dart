import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/Networks/api_responses/coordinates_response.dart';
import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/models/attendance/excuse_model.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/members/deviceRequestModel.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/members/member_profile.dart';

class EventAPI {
  static final baseUrl = 'https://db-api-v2.akwaabasoftware.com';
  late SharedPreferences prefs;

  static Future<List<MeetingEventModel>> getTodayMeetingEventList() async {
    List<MeetingEventModel> todayMeetings = [];
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/schedule/today?filter_recuring=both');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      var decodedresponse = jsonDecode(response.body);
      debugPrint("TODAY MeetingEventModel success: $decodedresponse");
      Iterable meetingList = decodedresponse['results'];
      todayMeetings = meetingList
          .map(
            (data) => MeetingEventModel.fromJson(data),
          )
          .toList();
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return todayMeetings;
  }

  static Future<List<MeetingEventModel>> getAllMeetings({
    required int page,
    required int branchId,
  }) async {
    List<MeetingEventModel> meetings = [];
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/schedule?filter_recuring=both&branchId=$branchId&page=$page&length=50');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      var decodedresponse = jsonDecode(response.body);
      debugPrint("TODAY MeetingEventModel success: $decodedresponse");
      Iterable meetingList = decodedresponse['results'];
      meetings = meetingList
          .map(
            (data) => MeetingEventModel.fromJson(data),
          )
          .toList();
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return meetings;
  }

  static Future<List<MeetingEventModel>> getMeetingsFromDate({
    required int page,
    required String date,
  }) async {
    List<MeetingEventModel> meetings = [];
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/schedule/date/$date?page=$page');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      var decodedresponse = jsonDecode(response.body);
      debugPrint("Meeting From Date success: $decodedresponse");
      Iterable meetingList = decodedresponse['results'];
      meetings = meetingList
          .map(
            (data) => MeetingEventModel.fromJson(data),
          )
          .toList();
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return meetings;
  }

  static Future<List<MeetingEventModel>> getUpcomingMeetingEventList({
    required int page,
  }) async {
    List<MeetingEventModel> upcomingMeetings = [];
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/schedule/upcoming?datatable_plugin&filter_recuring=both&page=$page');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      var decodedresponse = jsonDecode(response.body);
      debugPrint("UPCOMING MeetingEventModel success: $decodedresponse");
      Iterable dataList = decodedresponse['data'];
      upcomingMeetings = dataList
          .map(
            (data) => MeetingEventModel.fromJson(data),
          )
          .toList();
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return upcomingMeetings;
  }

  // get coordinates for a meeting
  static Future<CoordinatesResponse> getMeetingCoordinates({
    required MeetingEventModel meetingEventModel,
  }) async {
    CoordinatesResponse coordinateResponse;
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/location?meetingEventId=${meetingEventModel.id}');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Coordinates Response: ${jsonDecode(response.body)}");
      coordinateResponse = CoordinatesResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return coordinateResponse;
  }

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

  // checks if meetings have been clocked in by member
  static Future<MeetingAttendanceResponse> checkClockedMeeetings({
    required List<int> meetingEventIds,
    required int branchId,
    required String filterDate,
  }) async {
    MeetingAttendanceResponse attendanceResponse;
    var defaultUrl =
        '${getBaseUrl()}/attendance/meeting-event/attendance?filter_branch=$branchId&filter_date=$filterDate}';
    var url;
    if (meetingEventIds.length == 1) {
      url = Uri.parse('$defaultUrl&meetingEventId=${meetingEventIds[0]}');
    } else {
      for (var id in meetingEventIds) {
        defaultUrl = '$defaultUrl&meetingEventId=$id';
      }
      url = Uri.parse(defaultUrl);
      debugPrint('NEW URL: ${url.toString()}');
    }
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

  // clock-in data source
  static Future<ClockingResponse> clockIn({
    required int clockingId,
    required String time,
  }) async {
    ClockingResponse clockInResponse;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/clock-in/$clockingId');

      http.Response response = await http.patch(
        url,
        body: {
          'time': time,
        },
        headers: await getTokenHeader(),
      );
      clockInResponse = ClockingResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return clockInResponse;
  }

  // clock-out data source
  static Future<dynamic> clockOut({
    required int clockingId,
    required String time,
  }) async {
    ClockingResponse clockOutResponse;
    var url = Uri.parse(
      '${getBaseUrl()}/attendance/meeting-event/attendance/clock-out/$clockingId',
    );
    try {
      http.Response response = await http.patch(
        url,
        body: {
          'time': time,
        },
        headers: await getTokenHeader(),
      );
      clockOutResponse = ClockingResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return clockOutResponse;
  }

  // Start break data source
  static Future<ClockingResponse> startBreak({
    required int clockingId,
    required String time,
  }) async {
    ClockingResponse clockInResponse;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/start-break/$clockingId');
      http.Response response = await http.patch(
        url,
        body: {
          'time': time,
        },
        headers: await getTokenHeader(),
      );
      clockInResponse = ClockingResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return clockInResponse;
  }

  // End break data source
  static Future<ClockingResponse> endBreak({
    required int clockingId,
    required String time,
  }) async {
    ClockingResponse clockInResponse;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/end-break/$clockingId');
      http.Response response = await http.patch(
        url,
        body: {
          'time': time,
        },
        headers: await getTokenHeader(),
      );
      clockInResponse = ClockingResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return clockInResponse;
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
