import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupAPI {
  /// BRANCHES

  // get list of branches
  static Future<List<Branch>> getBranches() async {
    List<Branch> branches = [];

    var url = Uri.parse('${getBaseUrl()}/clients/branch');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Branch Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        branches = <Branch>[];
        res['data'].forEach((v) {
          branches.add(Branch.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return branches;
  }

  /// GENDER

  // get a gender
  static Future<Gender> getGender({
    required int genderId,
  }) async {
    Gender gender;

    var url = Uri.parse('${getBaseUrl()}/generic/gender/$genderId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Single Gender Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      gender = Gender.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return gender;
  }

  // get list of genders
  static Future<List<Gender>> getGenders() async {
    List<Gender> genders = [];

    var url = Uri.parse('${getBaseUrl()}/generic/gender');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Gender Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        genders = <Gender>[];
        res['data'].forEach((v) {
          genders.add(Gender.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return genders;
  }

  /// GROUP API

  // create group
  static Future<Group> createGroup({
    required int meetingEventId,
    required String groupId,
  }) async {
    Group group;

    var url = Uri.parse('${getBaseUrl()}/attendance/meeting-event/group');
    try {
      http.Response response = await http.post(
        url,
        body: {"groupId": groupId, "meetingEventId": meetingEventId},
        headers: await getAllHeaders(),
      );
      debugPrint("Create Group Res: ${await returnResponse(response)}");
      group = Group.fromJson(await returnResponse(response));
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return group;
  }

  // get a group
  static Future<Group> getGroup({
    required int groupId,
  }) async {
    Group group;

    var url =
        Uri.parse('${getBaseUrl()}/attendance/meeting-event/group/$groupId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Single Group Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      group = Group.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return group;
  }

  // get list of groups
  static Future<List<Group>> getGroups({required int branchId}) async {
    List<Group> groups = [];

    var url =
        Uri.parse('${getBaseUrl()}/members/groupings/group?branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Group Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        groups = <Group>[];
        res['data'].forEach((v) {
          groups.add(Group.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return groups;
  }

  // update a group
  static Future<Group> updateGroup({
    required int groupId,
    required int newGroupId,
  }) async {
    Group group;

    var url =
        Uri.parse('${getBaseUrl()}/attendance/meeting-event/group/$groupId');
    try {
      http.Response response = await http.patch(
        url,
        body: {"groupId": newGroupId},
        headers: await getAllHeaders(),
      );
      debugPrint("Updated Group Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      group = Group.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return group;
  }

  /// SUBGROUP API

  // create subgroup
  static Future<SubGroup> createSubGroup({
    required int memberCategoryId,
    required int branchId,
    required int groupId,
    required String name,
  }) async {
    SubGroup subGroup;

    var url = Uri.parse('${getBaseUrl()}/members/groupings/sub-group');
    try {
      http.Response response = await http.post(
        url,
        body: {
          "groupId": groupId,
          "subgroup": name,
          "branchId": branchId,
          "memberCategoryId": memberCategoryId
        },
        headers: await getAllHeaders(),
      );
      debugPrint("Created SubGroup Res: ${await returnResponse(response)}");
      subGroup = SubGroup.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return subGroup;
  }

  // Get a subgroup
  static Future<SubGroup> getSubGroup({
    required int subGroupId,
  }) async {
    SubGroup subGroup;

    var url =
        Uri.parse('${getBaseUrl()}/members/groupings/sub-group/$subGroupId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Single SubGroup Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      subGroup = SubGroup.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return subGroup;
  }

  // Get list of subgroups
  static Future<List<SubGroup>> getSubGroups({
    required int branchId,
    required int memberCategoryId,
  }) async {
    List<SubGroup> subGroups = [];

    var url = Uri.parse(
        '${getBaseUrl()}/members/groupings/sub-group?memberCategoryId=$memberCategoryId&branchId=$branchId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Group Response: ${jsonDecode(response.body)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        subGroups = <SubGroup>[];
        res['data'].forEach((v) {
          subGroups.add(SubGroup.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return subGroups;
  }

  // Update a subgroup
  static Future<SubGroup> updateSubGroup({
    required int memberCategoryId,
    required int branchId,
    required int subGroupId,
    required String name,
  }) async {
    SubGroup subGroup;

    var url =
        Uri.parse('${getBaseUrl()}/members/groupings/sub-group/$subGroupId');
    try {
      http.Response response = await http.patch(
        url,
        body: {
          "subgroup": name,
          "branchId": branchId,
          "memberCategoryId": memberCategoryId
        },
        headers: await getAllHeaders(),
      );
      debugPrint("Updated SubGroup Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      subGroup = SubGroup.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return subGroup;
  }

  /// MEMBER CATEGORY API

  // Create Member Category
  static Future<MemberCategory> createMemberCategory({
    required String name,
  }) async {
    MemberCategory memberCategory;

    var url = Uri.parse('${getBaseUrl()}/members/groupings/member-category');
    try {
      http.Response response = await http.post(
        url,
        body: {"category": name},
        headers: await getAllHeaders(),
      );
      debugPrint("Created MC Res: ${jsonDecode(response.body)}");
      memberCategory = MemberCategory.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return memberCategory;
  }

  // Get A Member Category
  static Future<MemberCategory> getMemberCategory({
    required int categoryId,
  }) async {
    MemberCategory memberCategory;

    var url = Uri.parse(
        '${getBaseUrl()}/members/groupings/member-category/$categoryId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Get MC Res: ${jsonDecode(response.body)}");
      var res = await returnResponse(response);
      memberCategory = MemberCategory.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return memberCategory;
  }

  // Get list of Member Categories
  static Future<List<MemberCategory>> getMemberCategories() async {
    List<MemberCategory> memberCategories = [];

    var url = Uri.parse('${getBaseUrl()}/members/groupings/member-category');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("MCs Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        memberCategories = <MemberCategory>[];
        res['data'].forEach((v) {
          memberCategories.add(MemberCategory.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return memberCategories;
  }

  // Update a Member Category
  static Future<MemberCategory> updateMemberCategory({
    required int categoryId,
    required String name,
  }) async {
    MemberCategory memberCategory;

    var url = Uri.parse(
        '${getBaseUrl()}/members/groupings/member-category/$categoryId');
    try {
      http.Response response = await http.patch(
        url,
        body: {"category": name},
        headers: await getAllHeaders(),
      );
      debugPrint("Updated MC Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      memberCategory = MemberCategory.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return memberCategory;
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
