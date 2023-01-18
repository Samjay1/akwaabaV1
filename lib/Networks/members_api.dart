import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:akwaaba/models/general/marital_status.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'api_responses/reset_password_response.dart';

class MembersAPI {
  /// MEMBERS

  // get list of individual members
  static Future<List<Member>> getIndividualMembers({
    required int page,
    required String? branchId,
    required String? groupId,
    required String? subGroupId,
    required String? maritalStatus,
    required String? occupationalStatus,
    required String? educationalStatus,
    required String? professionStatus,
    required String? search,
  }) async {
    List<Member> member = [];

    var url = Uri.parse(
        '${getBaseUrl()}/members/user/location?page=$page&search=$search&groupId=$groupId&subgroupId=$subGroupId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Ind Members Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        member = <Member>[];
        res['results'].forEach((v) {
          member.add(Member.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return member;
  }

  // get an individual memeber
  static Future<Member> getIndividualMember({
    required int memberId,
    required int branchId,
  }) async {
    Member member;

    var url =
        Uri.parse('${getBaseUrl()}/members/user/$memberId?branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Member Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      member = Member.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return member;
  }

  // get list of organizational members
  static Future<List<Member>> getOrganizationalMembers({
    required int page,
    required String? branchId,
    required String? groupId,
    required String? subGroupId,
    required String? maritalStatus,
    required String? occupationalStatus,
    required String? educationalStatus,
    required String? professionStatus,
    required String? search,
  }) async {
    List<Member> member = [];

    var url = Uri.parse(
        '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&groupId=$groupId&subgroupId=$subGroupId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Org Members Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        member = <Member>[];
        res['results'].forEach((v) {
          member.add(Member.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return member;
  }

  // get list of marital statuses
  static Future<List<MaritalStatus>> getMaritalStatuses() async {
    List<MaritalStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/marital');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Marital Status Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MaritalStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MaritalStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of occupation
  static Future<List<MaritalStatus>> getOccupations() async {
    List<MaritalStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/occupation');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Occupation Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MaritalStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MaritalStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of professions
  static Future<List<MaritalStatus>> getProfessions() async {
    List<MaritalStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/profession');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Profession Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MaritalStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MaritalStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of education
  static Future<List<MaritalStatus>> getEducations() async {
    List<MaritalStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/education');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Education Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MaritalStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MaritalStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
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
