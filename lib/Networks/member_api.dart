import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/abstractModel.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/electoralArea.dart';
import 'package:akwaaba/models/general/memberType.dart';
import 'package:akwaaba/models/general/region.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/models/members/deviceRequestModel.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/general/OrganisationType.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/group.dart';
import '../models/members/member_profile.dart';
import '../models/members/previewMemberProfile.dart';

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
        var memberId = decodedResponse['id'];
        prefs.setString('token', memberToken);
        prefs.setString('token', memberId);
        debugPrint('MEMBER TOKEN---------- --------------------- $memberToken');
        debugPrint('MEMBER memberId---------- --------------------- $memberId');

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
      accountInfo = ClientAccountInfo.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return accountInfo;
  }

  //GET MEMBER FULL PROFILE INFO
  // Get client info of member
  Future<PreviewMemberProfile> getFullProfileInfo(
      {required int memberId}) async {
    PreviewMemberProfile accountInfo;
    try {
      var url = Uri.parse('$baseUrl/members/user/$memberId');
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("PreviewMemberProfile Info Res: ${jsonDecode(response.body)}");
      var res = jsonDecode(response.body);
      // print('')
      accountInfo = PreviewMemberProfile.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return accountInfo;
  }

  //----------------------------------
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

  // get member groups
  Future<List<Group>> getMemberGroups({required int memberId}) async {
    List<Group> groups = [];

    var url =
        Uri.parse('$baseUrl/members/groupings/group-member?memberId=$memberId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Group Member Res: ${jsonDecode(response.body)}");
      var res = jsonDecode(response.body);
      debugPrint(res.toString());

      if (res['results'] != null) {
        groups = <Group>[];
        res['results'].forEach((v) {
          groups.add(Group.fromJson(v['groupId']));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return groups;
  }

  // get member subgroups
  Future<List<SubGroup>> getMemberSubGroups({required int memberId}) async {
    List<SubGroup> subGroups = [];

    var url = Uri.parse(
        '$baseUrl/members/groupings/sub-group-member?memberId=$memberId');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("SubGroup Member Res: ${jsonDecode(response.body)}");
      var res = jsonDecode(response.body);
      debugPrint(res.toString());

      if (res['results'] != null) {
        subGroups = <SubGroup>[];
        res['results'].forEach((v) {
          subGroups.add(SubGroup.fromJson(v['subgroupId']));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return subGroups;
  }

  // get a  branch
  Future<String> getMemberOutstandingBill() async {
    String bill;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberId = prefs.getString('memberId');

    var url = Uri.parse(
      'https://cash.akwaabasoftware.com/api/outstanding-bill/$memberId',
    );
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Outstanding Bill: ${jsonDecode(response.body)}");
      bill = jsonDecode(response.body)['total_bill'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return bill;
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
      prefs = await SharedPreferences.getInstance();
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
      debugPrint('decodedResponse $decodedResponse');
      var memberToken = decodedResponse['token'];
      int? memberId;
      if (decodedResponse['user'] != null) {
        memberId = decodedResponse['user']['id'];
        prefs.setInt('memberId', memberId!);
        prefs.setString('token', memberToken);
      }
      debugPrint('MEMBER TOKEN---------- --------------------- $memberToken');
      debugPrint('MEMBER memberId---------- --------------------- $memberId');
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
      String? memberToken = prefs.getString('token');

      http.Response response = await http.post(
          Uri.parse('$baseUrl/attendance/clocking-device/request'),
          body: json.encode(data),
          headers: {
            'Authorization': 'Token $memberToken',
            'Content-Type': 'application/json'
          });
      var decodedResponse = jsonDecode(response.body);
      debugPrint('DEVICE ACTIVATION REQUEST -------------- $decodedResponse');
      if (response.statusCode == 201) {
        // debugPrint('DEVICE ACTIVATION REQUEST -------------- $decodedResponse');
        // debugPrint(
        //     '2.MEMBER TOKEN---------- --------------------- $memberToken');
        // return response.body;
        showNormalToast("Device Activation request sent.");
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Invalid Token");
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
        debugPrint('DeviceRequestModel error ${jsonDecode(response.body)}');
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Network issue')));
      return [];
    }
  }

  Future<Object?> getRecentClocking(
      BuildContext context, String memberToken, memberID) async {
    debugPrint('UserApi token-transactions $memberToken');
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
        debugPrint("RecentClocking success: $decodedresponse");
        Iterable dataList = decodedresponse['results'];
        // return dataList
        //     .map((data) => RecentClockModal.fromJson(data))
        //     .toList();
        return 'hello';
      } else {
        debugPrint('DeviceRequestModel error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  static Future<String?> registerMember(BuildContext context,
      {clientId,
      branchId,
      firstname,
      middlename,
      surname,
      gender,
      dateOfBirth,
      email,
      phone,
      memberType,
      referenceId,
      nationality,
      countryOfResidence,
      stateProvince,
      region,
      district,
      constituency,
      electoralArea,
      community,
      digitalAddress,
      hometown,
      occupation,
      disability,
      maritalStatus,
      occupationalStatus,
      professionStatus,
      educationalStatus,
      groupIds,
      subgroupIds,
      password,
      confirm_password}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "clientId": clientId,
        "branchId": branchId,
        "firstname": firstname,
        "middlename": middlename,
        "surname": surname,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "email": email,
        "phone": phone,
        "accountType": 1,
        "memberType": memberType,
        "referenceId": referenceId,
        "nationality": nationality,
        "countryOfResidence": countryOfResidence,
        "stateProvince": stateProvince,
        "region": region,
        "district": district,
        "constituency": constituency,
        "electoralArea": electoralArea,
        "community": community,
        "digitalAddress": digitalAddress,
        "hometown": hometown,
        "occupation": occupation,
        "disability": disability,
        "maritalStatus": maritalStatus,
        "other_maritalStatus": "-",
        "occupationalStatus": occupationalStatus,
        "other_occupationalStatus": "-",
        "professionStatus": professionStatus,
        "other_professionStatus": "-",
        "educationalStatus": educationalStatus,
        "other_educationalStatus": "-",
        "groupIds": groupIds,
        "subgroupIds": subgroupIds,
        "password": password,
        "confirm_password": confirm_password
      };

      http.Response response = await http.post(
          Uri.parse('$regBaseUrl/members/user/app-register'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        debugPrint('REGISTRATION MEMBER -------------- $decodedResponse');
        showNormalToast("Registration Successful, Proceed to Login.");

        return 'successful';
      } else {
        var message = decodedResponse['non_field_errors'][0];
        debugPrint("error>>>. $message");
        showErrorToast("$message");
        return '$message';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

//  LOCATION REQUESTS

  Future<List<Country>?> getCountry() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/locations/country'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("Country success: $decodedresponse");
        Iterable dataList = decodedresponse;
        return dataList.map((data) => Country.fromJson(data)).toList();
      } else {
        debugPrint('Country error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<Region>?> getRegion() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/locations/region'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("REGION success: $decodedresponse");
        Iterable dataList = decodedresponse;
        return dataList.map((data) => Region.fromJson(data)).toList();
      } else {
        debugPrint('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<Region?> getSingleRegion({required regionId}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
        Uri.parse('$mybaseUrl/locations/region/$regionId'),
        headers: await getAllHeaders(),
      );
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("REGION single success: $decodedresponse");
        return Region.fromJson(decodedresponse);
      } else {
        debugPrint('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<District>?> getDistrict({required var regionID}) async {
    debugPrint('regionID $regionID');
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/locations/district/filter/$regionID'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("District success: $decodedresponse");
        Iterable dataList = decodedresponse;
        return dataList.map((data) => District.fromJson(data)).toList();
      } else {
        debugPrint('District error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<District?> getSingleDistrict({required districtId}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
        Uri.parse('$mybaseUrl/locations/district/$districtId'),
        headers: await getAllHeaders(),
      );
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("District single success: $decodedresponse");
        return District.fromJson(decodedresponse);
      } else {
        debugPrint('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<Constituency>?> getConstituency(
      {required var regionID, var districtID}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$mybaseUrl/locations/constituency?regionId=$regionID&districtId=$districtID'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);

        // print("Constituency success: $decodedresponse");
        Iterable dataList = decodedresponse['results'];
        return dataList.map((data) => Constituency.fromJson(data)).toList();
      } else {
        debugPrint('Constituency error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<Constituency?> getSingleConstituency({required ConstId}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
        Uri.parse('$mybaseUrl/locations/constituency/$ConstId'),
        headers: await getAllHeaders(),
      );
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("Constituency single success: $decodedresponse");
        return Constituency.fromJson(decodedresponse);
      } else {
        debugPrint('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<ElectoralArea>?> getElectoralArea(
      {required var regionID, var districtID}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$mybaseUrl/locations/electoral-area/filter/$regionID/$districtID'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("ElectoralArea success: $decodedresponse");
        Iterable dataList = decodedresponse;
        return dataList.map((data) => ElectoralArea.fromJson(data)).toList();
      } else {
        debugPrint('ElectoralArea error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<ElectoralArea?> getSingleElectoralArea({required electoralId}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
        Uri.parse('$mybaseUrl/locations/electoral-area/$electoralId'),
        headers: await getAllHeaders(),
      );
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("ElectoralArea single success: $decodedresponse");
        return ElectoralArea.fromJson(decodedresponse);
      } else {
        debugPrint('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

//  BRANCH REQUEST

  Future<List<Branch>?> getBranches({required var token}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http
          .get(Uri.parse('$mybaseUrl/clients/branch'), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("Branch success: $decodedresponse, TOKEN: $token");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => Branch.fromJson(data)).toList();
      } else {
        debugPrint('Branch error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

//  GROUP AND SUB GROUPS REQUEST

  Future<List<Group>?> getGroup({required var token, var branchID}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/groupings/group?branchId=$branchID'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        debugPrint("Group success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => Group.fromJson(data)).toList();
      } else {
        debugPrint('Group error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<SubGroup>?> getSubGroup(
      {required var token, var branchID}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$mybaseUrl/members/groupings/sub-group?branchId=$branchID'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("SubGroup success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => SubGroup.fromJson(data)).toList();
      } else {
        print('SubGroup error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

// OCCUPATION, PROFESSION, MARITAL STATUS

  Future<List<AbstractModel>?> getOccupation() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/user-status/occupation'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("Occupation success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => AbstractModel.fromJson(data)).toList();
      } else {
        print('Occupation error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<AbstractModel>?> getProfession() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/user-status/profession'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("profession success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => AbstractModel.fromJson(data)).toList();
      } else {
        print('profession error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<AbstractModel>?> getMaritalStatus() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/user-status/marital'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("marital success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => AbstractModel.fromJson(data)).toList();
      } else {
        print('marital error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<AbstractModel>?> getEducation() async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/user-status/education'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("Education success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => AbstractModel.fromJson(data)).toList();
      } else {
        print('Education error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

//  ORGANISATION TYPE AND MEMBER TYPE

  Future<List<MemberType>?> getMemberType({required var token}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/groupings/member-category'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("MemberType success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => MemberType.fromJson(data)).toList();
      } else {
        print('MemberType error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  Future<List<OrganisationType>?> getOrganisationType(
      {required var token}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/members/groupings/member-organization-type'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("OrganisationType success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => OrganisationType.fromJson(data)).toList();
      } else {
        print('OrganisationType error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  // REGISTRATION CODE

  static Future<dynamic> searchRegCode({required var regCode}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/clients/code/by-code/$regCode'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("searchRegCode success: $decodedresponse");
        var clientID = decodedresponse['data']['clientId'];
        var clientLogo = decodedresponse['data']['clientInfo']['logo'];
        var clientName = decodedresponse['data']['clientInfo']['name'];
        var clientInfo = {
          'clientID': clientID,
          'clientLogo': clientLogo,
          'clientName': clientName
        };
        return clientInfo;
      } else {
        print('searchRegCode error ${jsonDecode(response.body)}');
        //showErrorToast("Please a valid Registration Code");
        return null;
      }
    } on SocketException catch (e) {
      showErrorToast("Please check you network");
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      print('searchRegCode error, $regCode, $e');
      return null;
    }
  }

  // GET TOKEN

  Future<String?> getToken({required var clientID}) async {
    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {"accountId": clientID};
      http.Response response = await http.post(
          Uri.parse('$mybaseUrl/clients/hash-hash'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        print("token success: $decodedresponse");
        var token = decodedresponse['token'];
        return token;
      } else {
        print('token error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

  static Future<String?> registerMemberWithImage(BuildContext context,
      {profilePicture,
      profileResume,
      profileIdentification,
      clientId,
      branchId,
      firstname,
      middlename,
      surname,
      gender,
      dateOfBirth,
      email,
      phone,
      memberType,
      referenceId,
      nationality,
      countryOfResidence,
      stateProvince,
      region,
      district,
      constituency,
      electoralArea,
      community,
      digitalAddress,
      hometown,
      occupation,
      disability,
      maritalStatus,
      occupationalStatus,
      professionStatus,
      educationalStatus,
      groupIds,
      subgroupIds,
      password,
      confirm_password}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$regBaseUrl/members/user/app-register'));

      Map<String, String> headers = {'Content-Type': 'application/json'};

      // multipart that takes file
      if (profilePicture != null) {
        var profPicture =
            await http.MultipartFile.fromPath('profilePicture', profilePicture);
        request.files.add(profPicture);
      }
      if (profileResume != null) {
        var profResume =
            await http.MultipartFile.fromPath('profileResume', profileResume);
        request.files.add(profResume);
      }
      if (profileIdentification != null) {
        var profIdentification = await http.MultipartFile.fromPath(
            'profileIdentification', profileIdentification);
        request.files.add(profIdentification);
      }

      request.headers.addAll(headers);

      // add file to multipart
      request.fields["clientId"] = clientId;
      request.fields["branchId"] = branchId;
      request.fields["firstname"] = firstname;
      request.fields["middlename"] = middlename;
      request.fields["surname"] = surname;
      request.fields["gender"] = gender.toString();
      request.fields["dateOfBirth"] = dateOfBirth;
      request.fields["email"] = email;
      request.fields["phone"] = phone;
      request.fields["accountType"] = '1';
      request.fields["memberType"] = memberType.toString();
      request.fields["referenceId"] = referenceId;
      request.fields["nationality"] = nationality.toString();
      request.fields["countryOfResidence"] = countryOfResidence.toString();
      request.fields["stateProvince"] =
          stateProvince.toString().isNotEmpty ? stateProvince.toString() : '-';
      if (region != null) {
        request.fields["region"] = region.toString();
      }
      if (district != null) {
        request.fields["district"] = district.toString();
      }
      if (constituency != null) {
        request.fields["constituency"] = constituency.toString();
      }
      if (electoralArea != null) {
        request.fields["electoralArea"] = electoralArea.toString();
      }

      request.fields["community"] =
          community.toString().isNotEmpty ? community.toString() : '-';
      request.fields["digitalAddress"] = digitalAddress.toString();
      request.fields["hometown"] = hometown.toString();
      request.fields["occupation"] = occupation.toString();
      request.fields["disability"] = disability.toString();
      request.fields["maritalStatus"] = maritalStatus.toString();
      request.fields["occupationalStatus"] = occupationalStatus.toString();
      request.fields["professionStatus"] = professionStatus.toString();
      request.fields["educationalStatus"] = educationalStatus.toString();
      if (groupIds != null) {
        request.fields["groupIds[]"] = groupIds.toString();
      }
      if (subgroupIds != null) {
        request.fields["subgroupIds[]"] = subgroupIds.toString();
      }

      request.fields["password"] = password;
      request.fields["confirm_password"] = confirm_password;

      // send
      var response = await request.send();
      // listen for response
      debugPrint('response.statusCode ${response.statusCode}');

      if (response.statusCode == 201) {
        debugPrint('REGISTRATION MEMBER -------------- $response');
        return 'successful';
      } else if (response.statusCode == 400) {
        return jsonDecode(
          await response.stream.bytesToString(),
        )['non_field_errors'][0];
      } else {
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          // var message = data['non_field_errors'][0];
          print('RESPONSE: $data');
          // showNormalToast('$message');
        });
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  static Future<String?> registerOrg(BuildContext context,
      {clientId,
      branchId,
      organizationName,
      contactPersonName,
      contactPersonGender,
      organizationType,
      businessRegistered,
      organizationEmail,
      organizationPhone,
      contactPersonEmail,
      contactPersonPhone,
      contactPersonWhatsapp,
      // occupation,
      memberType,
      referenceId,
      countryOfBusiness,
      stateProvince,
      region,
      district,
      constituency,
      electoralArea,
      community,
      digitalAddress,
      password,
      confirm_password,
      groupIds,
      subgroupIds,
      website,
      businessDescription,
      logo,
      certificates}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('$regBaseUrl/members/user-organization/app-register'));

      Map<String, String> headers = {'Content-Type': 'application/json'};
      //Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

      // multipart that takes file
      if (logo != null) {
        var orgLogo = await http.MultipartFile.fromPath('logo', logo);
        request.files.add(orgLogo);
      }

      if (certificates.isNotEmpty) {
        List<http.MultipartFile> newList = <http.MultipartFile>[];
        for (int i = 0; i < certificates.length; i++) {
          File imageFile = File(certificates[i].path);
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile("files", stream, length,
              filename: path.basename(imageFile.path));
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
      }

      request.headers.addAll(headers);

      // add file to multipart

      request.fields["clientId"] = clientId;
      request.fields["branchId"] = branchId;
      request.fields["organizationName"] = organizationName;
      request.fields["organizationType"] = organizationType.toString();
      request.fields["organizationEmail"] = organizationEmail;
      request.fields["organizationPhone"] = organizationPhone;
      request.fields["contactPersonName"] = contactPersonName;
      request.fields["contactPersonGender"] = contactPersonGender.toString();
      request.fields["contactPersonEmail"] = contactPersonEmail;
      request.fields["contactPersonPhone"] = contactPersonPhone;
      request.fields["countryOfBusiness"] = countryOfBusiness.toString();
      request.fields["memberType"] = memberType.toString();
      request.fields["stateProvince"] =
          stateProvince.toString().isNotEmpty ? stateProvince.toString() : '-';
      request.fields["businessRegistered"] = businessRegistered.toString();

      request.fields["contactPersonWhatsapp"] = contactPersonWhatsapp;

      request.fields["accountType"] = '2';
      // request.fields["referenceId"]= referenceId;
      if (region != null) {
        request.fields["region"] = region.toString();
      }
      if (district != null) {
        request.fields["district"] = district.toString();
      }
      if (constituency != null) {
        request.fields["constituency"] = constituency.toString();
      }
      if (electoralArea != null) {
        request.fields["electoralArea"] = electoralArea.toString();
      }
      request.fields["community"] =
          community.toString().isNotEmpty ? community.toString() : '-';
      request.fields["digitalAddress"] = digitalAddress.toString();
      if (website.isNotEmpty) {
        request.fields["website"] = website;
      }
      request.fields["businessDescription"] = businessDescription;
      if (groupIds != null) {
        request.fields["groupIds[]"] = groupIds.toString();
      }
      if (subgroupIds != null) {
        request.fields["subgroupIds[]"] = subgroupIds.toString();
      }
      request.fields["password"] = password;
      request.fields["confirm_password"] = confirm_password;

      // send
      var response = await request.send();

      // listen for response
      debugPrint('response.statusCode ${response.statusCode}');

      // print('response.============> ${response}');

      if (response.statusCode == 201) {
        debugPrint('REGISTRATION MEMBER -------------- $response');
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          // var message = data['non_field_errors'][0];
          print('RESPONSE: $data');
          // showNormalToast('$message');
        });
        return 'successful';
      } else if (response.statusCode == 400) {
        var data = jsonDecode(await response.stream.bytesToString());
        if (data == null) {
          //showErrorToast('Failed, Try again');
          if (context.mounted) {
            showErrorSnackBar(
              context,
              'An unexpected error occured, please try again',
            );
          }
        } else {
          if (data['non_field_errors'] == null) {
            var res = data.keys.toList().first;
            debugPrint(data.toString());
            var message = '${data[res]['0']}';
            //showErrorToast(message);
            if (context.mounted) {
              showErrorSnackBar(context, message);
            }
          } else {
            var message = data['non_field_errors'][0];
            if (context.mounted) {
              showErrorSnackBar(context, message);
            }
          }
        }
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  //UPDATE BIO INFO
  static Future<String?> updateBio({
    memberId,
    firstname,
    middlename,
    surname,
    gender,
    dateOfBirth,
    email,
    phone,
    referenceId,
  }) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "firstname": firstname,
        "middlename": middlename,
        "surname": surname,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "email": email,
        "phone": phone,
        "accountType": 1,
      };

      debugPrint('UPDATE BIO memberId $memberId');

      http.Response response = await http.put(
        Uri.parse('$regBaseUrl/members/user/$memberId'),
        body: json.encode(data),
        headers: await getAllHeaders(),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint('UPDATE BIO MEMBER -------------- $decodedResponse');

        return 'successful';
      } else {
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  //UPDATE GROUPINGS
  static Future<String?> updateGroup({
    required branchId,
    required category,
    required memberId,
  }) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "branchId": branchId,
        "memberType": category,
      };

      print('UPDATE GROUP memberId $memberId');

      http.Response response = await http.put(
        Uri.parse('$regBaseUrl/members/user/$memberId'),
        body: json.encode(data),
        headers: await getAllHeaders(),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint('UPDATE GROUP MEMBER -------------- $decodedResponse');

        return 'successful';
      } else {
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  //UPDATE MEMBER GROUPS
  static Future<String?> updateMemberGroups({
    required List<int> groupIds,
    required List<int> subgroupIds,
    required int memberId,
  }) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "groups": groupIds,
        "memberId": memberId,
      };

      debugPrint('GroupIDs: ${groupIds.toString()}');

      http.Response response = await http.post(
        Uri.parse('$regBaseUrl/members/groupings/group-member/bulk'),
        body: json.encode(data),
        headers: await getAllHeaders(),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        debugPrint('UPDATE GROUP -------------- $decodedResponse');
        await updateMemberSubGroups(
          subgroupIds: subgroupIds,
          memberId: memberId,
        );
        //return 'successful';
      } else {
        debugPrint('GroupIDs: ${jsonDecode(response.body)}');
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  //UPDATE MEMBER SUBGROUPS
  static Future<String?> updateMemberSubGroups({
    required List<int> subgroupIds,
    required int memberId,
  }) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "subgroups": subgroupIds,
        "memberId": memberId,
      };
      debugPrint('SubGroupIds: ${subgroupIds.toString()}');

      http.Response response = await http.post(
        Uri.parse('$regBaseUrl/members/groupings/sub-group-member/bulk'),
        body: json.encode(data),
        headers: await getAllHeaders(),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        debugPrint('UPDATE SUBGROUP -------------- $decodedResponse');
        showNormalToast("Group information updated successfully");
        return 'successful';
      } else {
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  //UPDATE LOCATION
  static Future<String?> updateLocation(BuildContext context,
      {memberId,
      nationality,
      countryOfResidence,
      stateProvince,
      region,
      district,
      constituency,
      electoralArea,
      community,
      digitalAddress,
      hometown}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        "nationality": nationality,
        "countryOfResidence": countryOfResidence,
        "stateProvince": stateProvince,
        "region": region,
        "district": district,
        "constituency": constituency,
        "electoralArea": electoralArea,
        "community": community,
        "digitalAddress": digitalAddress,
        "hometown": hometown,
      };

      print('UPDATE GROUP memberId $memberId');

      http.Response response = await http.put(
        Uri.parse('$regBaseUrl/members/user/$memberId'),
        body: json.encode(data),
        headers: await getAllHeaders(),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint('UPDATE LOCATION MEMBER -------------- $decodedResponse');
        return 'successful';
      } else {
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  static Future<String?> updateCV({
    required int memberId,
    profileResume,
  }) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      debugPrint('UPDATE GROUP memberId $memberId');
      var request = await http.MultipartRequest(
          'PUT', Uri.parse('$regBaseUrl/members/user/$memberId'));

      Map<String, String> headers = await getAllHeaders();

      // multipart that takes file

      var profResume =
          await http.MultipartFile.fromPath('profileResume', profileResume);
      request.files.add(profResume);
      request.headers.addAll(headers);

      // send
      var response = await request.send();
      // listen for response
      debugPrint('response.statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint(
            'UPDATE LOCATION MEMBER -------------- ${response.stream.toString()}');

        return 'successful';
      } else {
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          // var message = data['non_field_errors'][0];
          debugPrint('RESPONSE: $data');
          // showNormalToast('$message');
        });
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  static Future<String?> updateIDCard(
      {required int memberId, profileIdentification}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      debugPrint('UPDATE GROUP memberId $memberId');
      var request = await http.MultipartRequest(
          'PUT', Uri.parse('$regBaseUrl/members/user/$memberId'));

      Map<String, String> headers = await getAllHeaders();

      // multipart that takes file

      var profileIdentificationk = await http.MultipartFile.fromPath(
          'profileIdentification', profileIdentification);
      request.files.add(profileIdentificationk);
      request.headers.addAll(headers);

      // send
      var response = await request.send();
      // listen for response
      print('response.statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        return 'successful';
      } else {
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          // var message = data['non_field_errors'][0];
          print('RESPONSE: $data');
          // showNormalToast('$message');
        });
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }

  static Future<String?> updateProfilePic(
      {required int memberId, profilePic}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      print('UPDATE GROUP memberId $memberId');
      var request = await http.MultipartRequest(
          'PUT', Uri.parse('$regBaseUrl/members/user/$memberId'));

      Map<String, String> headers = await getAllHeaders();

      // multipart that takes file

      if (profilePic != null) {
        var profilePicture =
            await http.MultipartFile.fromPath('profilePicture', profilePic);
        request.files.add(profilePicture);
      } else {
        showErrorToast("Please select a file");
        return 'failed';
      }
      request.headers.addAll(headers);

      // send
      var response = await request.send();
      // listen for response
      print('response.statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        return 'successful';
      } else {
        response.stream.transform(utf8.decoder).listen((value) {
          var data = json.decode(value);
          // var message = data['non_field_errors'][0];
          print('RESPONSE: $data');
          // showNormalToast('$message');
        });
        return 'failed';
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
      return 'network_error';
    }
  }
}
