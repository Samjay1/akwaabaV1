import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/Networks/api_responses/coordinates_response.dart';
import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/attendance/attendance.dart';
import 'package:akwaaba/models/attendance/excuse_model.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/messaging_type.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
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
      http.Response response = await http
          .get(
            url,
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
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

  // get list of attendees for a meeting or event
  static Future<AttendanceHistoryResponse> getAttendanceHistory({
    required int page,
    required List<int> meetingIds,
    required String startDate,
    required String endDate,
    required String search,
    required String status,
    required int? branchId,
    required String? memberId,
    required String? memberCategoryId,
    required String? groupId,
    required String? subGroupId,
    required String? genderId,
    required String? fromAge,
    required String? toAge,
  }) async {
    AttendanceHistoryResponse membersResponse;

    String? userType = await SharedPrefs().getUserType();

    var url;
    userType == AppConstants.member
        ? url =
            '${getBaseUrl()}/attendance/meeting-event/member-attendance-history?page=$page&filter_start_date=$startDate&filter_end_date=$endDate&filter_branch=$branchId&filter_memberIds=$memberId&filter_activeStatus=$status'
        : url =
            '${getBaseUrl()}/attendance/meeting-event/member-attendance-history?page=$page&filter_start_date=$startDate&filter_end_date=$endDate&filter_branch=$branchId&filter_member_category=$memberCategoryId&filter_group=$groupId&filter_subgroup=$subGroupId&filter_gender=$genderId&filter_search=$search&filter_memberIds=$memberId&filter_activeStatus=$status&filter_from_age=$fromAge&filter_to_age=$toAge';
    // loop through meeting Ids
    // and append them to url for query
    for (var id in meetingIds) {
      url += '&filter_meetingIds=$id';
    }

    try {
      debugPrint("URL: ${url.toString()}");
      debugPrint("page: $page");
      debugPrint("Meeting IDs: ${meetingIds.toString()}");
      debugPrint("Member ID: $memberId");
      debugPrint("Search: $search");
      debugPrint("Status: $status");
      debugPrint("Start Date: $startDate");
      debugPrint("End Date: $endDate");
      debugPrint("Branch ID: $branchId");
      debugPrint("MemberCategoryId: $memberCategoryId");
      debugPrint("groupId: $groupId");
      debugPrint("subGroupId: $subGroupId");
      debugPrint("genderId: $genderId");
      debugPrint("fromAge: $fromAge");
      debugPrint("toAge: $toAge");
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint(
          "Attendance History Response: ${await returnResponse(response)}");
      membersResponse = AttendanceHistoryResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return membersResponse;
  }

  // validate member attendance - single
  static Future<Attendance> validateMemberAttendance({
    required int clockingId,
  }) async {
    Attendance attendance;
    try {
      var url = Uri.parse(
          '${getBaseUrl()}/attendance/meeting-event/attendance/validate-attendance');
      http.Response response = await http
          .post(
            url,
            body: json.encode({
              'clockingId': clockingId,
            }),
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
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
      http.Response response = await http
          .post(
            url,
            body: json.encode({
              'clockingIds': clockingIds,
            }),
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
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

  static Future<List<MessagingType>> getMessagingTypes({
    required int gender,
  }) async {
    List<MessagingType> messagingTypes = [];
    var url = Uri.parse('${getBaseUrl()}/generic/messaging-type?id=$gender');
    try {
      http.Response response = await http
          .get(
            url,
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint("MessagingType Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        messagingTypes = <MessagingType>[];
        res['data'].forEach((v) {
          messagingTypes.add(MessagingType.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return messagingTypes;
  }

  // submit an excuse data source
  static Future<String> submitFollowUp({
    required int meetingEventId,
    required int clockingId,
    required int messagingType,
    required String followUp,
  }) async {
    String message;
    var url = Uri.parse(
        '${getBaseUrl()}/attendance/meeting-event/attendance-follow-up');
    try {
      http.Response response = await http
          .post(
            url,
            body: json.encode({
              'meetingEventId': meetingEventId,
              'clockingId': clockingId,
              'followUp': followUp,
              'messagingType': messagingType,
            }),
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint("Submit Excuse Response: ${jsonDecode(response.body)}");
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
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
