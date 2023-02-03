import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/models/general/absent_leave.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/leave_status.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeaveAPI {
  /// LEAVE

  // get list of absent/leave status
  static Future<List<LeaveStatus>> getAbsentLeaveStatuses(
      {required int branchId}) async {
    List<LeaveStatus> status = [];

    var url = Uri.parse(
        '${getBaseUrl()}/attendance/absent-leave/status?branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Leave Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        status = <LeaveStatus>[];
        res['data'].forEach((v) {
          status.add(LeaveStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return status;
  }

  /// GROUP API

  // create absent/leave
  static Future<String> createAbsentLeave(
      {required int statusId,
      required int memberId,
      required String fromDate,
      required String toDate,
      required String reason}) async {
    String message;

    var url = Uri.parse('${getBaseUrl()}/attendance/absent-leave/assignment');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'statusId': statusId,
          'memberId': memberId,
          'fromDate': fromDate,
          'toDate': toDate,
          'reason': reason,
        }),
        headers: await getAllHeaders(),
      );
      debugPrint("Assignment Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // get list of assiged absent or leave
  static Future<List<AbsentLeave>> getAllAbsentLeave({
    required int page,
    required int branchId,
    required String search,
    required String? fromDate,
    required String? toDate,
  }) async {
    List<AbsentLeave> absentLeaveList = [];

    var url = Uri.parse(
        '${getBaseUrl()}/attendance/absent-leave/assignment?page=$page&ordering=-id&branchId=$branchId&search=$search&from_date=$fromDate&to_date=$toDate');

    debugPrint("URL: ${url.toString()}");
    debugPrint("page: $page");
    debugPrint("Search: $search");
    debugPrint("Start Date: $fromDate");
    debugPrint("End Date: $toDate");
    debugPrint("Branch ID: $branchId");

    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Leaves: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        absentLeaveList = <AbsentLeave>[];
        res['results'].forEach((v) {
          absentLeaveList.add(AbsentLeave.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return absentLeaveList;
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
