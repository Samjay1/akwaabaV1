import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:akwaaba/models/general/client_stat.dart';
import 'package:akwaaba/models/general/member_stat.dart';
import 'package:akwaaba/models/general/member_status.dart';
import 'package:akwaaba/models/general/organization.dart';
import 'package:akwaaba/models/general/restricted_member.dart';
import 'package:akwaaba/models/general/restriction.dart';
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
    required String? memberCategoryId,
    required String? groupId,
    required String? subGroupId,
    required String? startDate,
    required String? endDate,
    required String? countryId,
    required String? regionId,
    required String? districtId,
    required String? maritalStatus,
    required String? occupationalStatus,
    required String? educationalStatus,
    required String? professionStatus,
    required String? search,
  }) async {
    List<Member> member = [];

    var url;
    if (regionId == null || districtId == null) {
      // remove district and region from url
      url = Uri.parse(
          '${getBaseUrl()}/members/user/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus');
    } else {
      // add district and region to url
      url = Uri.parse(
          '${getBaseUrl()}/members/user/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&region=$regionId&district=$districtId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus');
    }

    debugPrint("URL: ${url.toString()}");

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

  // get individual and organization memebers stats
  static Future<ClientStat> getClientStatistics({
    required int currentBranchId,
  }) async {
    ClientStat stats;

    var url = Uri.parse(
        '${getBaseUrl()}/clients/dashboard-statistics?currentBranchId=$currentBranchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Stats Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      stats = ClientStat.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return stats;
  }

  // get list of user restrictions
  static Future<List<Restriction>> getUserRestrictions(
      {required int page, required int clientId, required int branchId}) async {
    List<Restriction> maritalStatuses = [];

    var url = Uri.parse(
        '${getBaseUrl()}/members/access/restriction?page=$page&clientId=$clientId&branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Restrictions: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <Restriction>[];
        res['data'].forEach((v) {
          maritalStatuses.add(Restriction.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of restricted members
  static Future<List<RestrictedMember>> getRestrictedMembers({
    required int page,
    required int memberId,
  }) async {
    List<RestrictedMember> members = [];

    var url = Uri.parse(
        '${getBaseUrl()}/members/access/assignment/get-members?page=$page&memberId=$memberId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Restrictions: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        members = <RestrictedMember>[];
        res['results'].forEach((v) {
          members.add(RestrictedMember.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return members;
  }

  // get individual and organization memebers stats
  static Future<MemberStat> getMemberStatistics({
    required int branchId,
  }) async {
    MemberStat stats;

    var url =
        Uri.parse('${getBaseUrl()}/members/statistics?branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Stats Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      stats = MemberStat.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return stats;
  }

  // get list of organizational members
  static Future<List<Organization>> getOrganizationalMembers({
    required int page,
    required String? branchId,
    required String? memberCategoryId,
    required String? groupId,
    required String? subGroupId,
    required String? startDate,
    required String? endDate,
    required String? countryId,
    required String? regionId,
    required String? districtId,
    required String? maritalStatus,
    required String? occupationalStatus,
    required String? educationalStatus,
    required String? professionStatus,
    required bool? businessRegistered,
    required String? organizationType,
    required String? search,
  }) async {
    List<Organization> organization = [];

    var url;
    if (regionId == null || districtId == null) {
      if (organizationType == null) {
        // remove district and region from url
        url = Uri.parse(
            '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus&businessRegistered=$businessRegistered');
      } else {
        // remove district and region from url
        url = Uri.parse(
            '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus&organizationType=$organizationType&businessRegistered=$businessRegistered');
      }
    } else {
      if (organizationType == null) {
        // add district and region to url
        url = Uri.parse(
            '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&region=$regionId&district=$districtId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus&businessRegistered=$businessRegistered');
      } else {
        // add district and region to url
        url = Uri.parse(
            '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&region=$regionId&district=$districtId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus&organizationType=$organizationType&businessRegistered=$businessRegistered');
      }
    }
    debugPrint("URL: ${url.toString()}");
    // var url = Uri.parse(
    //     '${getBaseUrl()}/members/user-organization/location?page=$page&search=$search&filter_member_category=$memberCategoryId&groupId=$groupId&subgroupId=$subGroupId&dategte=$startDate&datelte=$endDate&Country=$countryId&region=$regionId&district=$districtId&maritalStatus=$maritalStatus&occupationalStatus=$occupationalStatus&educationalStatus=$educationalStatus&professionStatus=$professionStatus');

    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Org Members Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        organization = <Organization>[];
        res['results'].forEach((v) {
          organization.add(Organization.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return organization;
  }

  // get list of marital statuses
  static Future<List<MemberStatus>> getMaritalStatuses() async {
    List<MemberStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/marital');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Marital Status Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MemberStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MemberStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get organization types
  static Future<List<OrganizationType>> getOrganizationTypes() async {
    List<OrganizationType> organizationTypes = [];

    var url =
        Uri.parse('${getBaseUrl()}/members/groupings/member-organization-type');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Org Types: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        organizationTypes = <OrganizationType>[];
        res['data'].forEach((v) {
          organizationTypes.add(OrganizationType.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return organizationTypes;
  }

  // get list of occupation
  static Future<List<MemberStatus>> getOccupations() async {
    List<MemberStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/occupation');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Occupation Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MemberStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MemberStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of professions
  static Future<List<MemberStatus>> getProfessions() async {
    List<MemberStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/profession');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Profession Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MemberStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MemberStatus.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return maritalStatuses;
  }

  // get list of education
  static Future<List<MemberStatus>> getEducations() async {
    List<MemberStatus> maritalStatuses = [];

    var url = Uri.parse('${getBaseUrl()}/members/user-status/education');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Education Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        maritalStatuses = <MemberStatus>[];
        res['data'].forEach((v) {
          maritalStatuses.add(MemberStatus.fromJson(v));
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
