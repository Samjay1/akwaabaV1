import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/abstractModel.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/electoralArea.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/memberType.dart';
import 'package:akwaaba/models/general/recentClockModal.dart';
import 'package:akwaaba/models/general/region.dart';
import 'package:akwaaba/models/members/deviceRequestModel.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/general/abstractGroup.dart';
import '../models/general/abstractSubGroup.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
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
      accountInfo = ClientAccountInfo.fromJson(
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

  static void registerMember(

      BuildContext context,
  {
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
  confirm_password}
    ) async {
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
        Navigator.push(context,MaterialPageRoute( builder: (_) => LoginPage(),));
      } else {
        debugPrint("error>>>. ${response.body}");
        var error = decodedResponse['non_field_errors'][0];
        showErrorToast("$error");
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
    }
  }

  static void registerOrganisation(
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
      occupation,
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
      logo}) async {
    var regBaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      var data = {
        'clientId': clientId,
        'branchId': branchId,
        'organizationName': organizationName,
        'contactPersonName': contactPersonName,
        'contactPersonGender': contactPersonGender,
        'organizationType': organizationType,
        'businessRegistered': businessRegistered,
        'organizationEmail': organizationEmail,
        'organizationPhone': organizationPhone,
        'contactPersonEmail': contactPersonEmail,
        'contactPersonPhone': contactPersonPhone,
        'contactPersonWhatsapp': contactPersonWhatsapp,
        'occupation': occupation,
        'accountType': 2,
        'memberType': memberType,
        'referenceId': referenceId,
        'countryOfBusiness': countryOfBusiness,
        'stateProvince': stateProvince,
        'region': region,
        'district': district,
        'constituency': constituency,
        'electoralArea': electoralArea,
        'community': community,
        'digitalAddress': digitalAddress,
        'password': password,
        'confirm_password': confirm_password,
        'groupIds[]': groupIds,
        'subgroupIds[]': subgroupIds,
        'website': website,
        'businessDescription': businessDescription,
        'logo': logo
      };

      http.Response response = await http.post(
          Uri.parse('$regBaseUrl/members/user-organization/app-register'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        debugPrint('REGISTRATION ORGANISATION -------------- $decodedResponse');
        showErrorToast("Registration Successful, Proceed to Login.");
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
      }
    } on SocketException catch (_) {
      showErrorToast("Network Error");
    }
  }


//  LOCATION REQUESTS

   Future<List<Country>?> getCountry()async{
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
        print('Country error ${jsonDecode(response.body)}');
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
        print('REGION error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }


   Future<List<District>?> getDistrict({required var regionID}) async {

    var mybaseUrl = 'https://db-api-v2.akwaabasoftware.com';
    try {
      http.Response response = await http.get(
          Uri.parse('$mybaseUrl/locations/district/filter/$regionID'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var decodedresponse = jsonDecode(response.body);
        // print("District success: $decodedresponse");
        Iterable dataList = decodedresponse;
        return dataList.map((data) => District.fromJson(data)).toList();
      } else {
        print('District error ${jsonDecode(response.body)}');
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
        return dataList
            .map((data) => Constituency.fromJson(data))
            .toList();

      } else {
        print('Constituency error ${jsonDecode(response.body)}');
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
        print('ElectoralArea error ${jsonDecode(response.body)}');
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
        print("Branch success: $decodedresponse, TOKEN: $token");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => Branch.fromJson(data)).toList();
      } else {
        print('Branch error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

//  GROUP AND SUB GROUPS REQUEST


   Future<List<AbstractGroup>?> getGroup(
      {required var token, var branchID}) async {

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
        print("Group success: $decodedresponse");
        Iterable dataList = decodedresponse['data'];
        return dataList.map((data) => AbstractGroup.fromJson(data)).toList();
      } else {
        print('Group error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }

   Future<List<AbstractSubGroup>?> getSubGroup(
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
        return dataList.map((data) => AbstractSubGroup.fromJson(data)).toList();
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


   Future<List<MemberType>?> getOrganisationType(
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
        return dataList.map((data) => MemberType.fromJson(data)).toList();
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

  static Future<dynamic?> searchRegCode({required var regCode}) async {

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
          'clientID':clientID,
          'clientLogo':clientLogo,
          'clientName':clientName
        };
        return clientInfo;
      } else {
        print('searchRegCode error ${jsonDecode(response.body)}');
        return null;
      }
    } on SocketException catch (e) {
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
}


