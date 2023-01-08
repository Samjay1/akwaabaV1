import 'dart:collection';
import 'dart:io';

import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/general/deviceInfoModel.dart';
import '../utils/widget_utils.dart';
import '../versionOne/main_page.dart';

class MemberProvider with ChangeNotifier {
  String? _memberToken;
  MemberProfile? _memberProfile;
  ClientAccountInfo? _clientAccountInfo;
  Branch? _branch;
  DeviceInfoModel? deviceInfoModel;
  String? _identityNumber;
  bool _showLoginProgressIndicator = false;
  bool _loading = false;
  bool _clocking = false;
  var deviceRequestList;

  final TextEditingController excuseTEC = TextEditingController();

  bool get loading => _loading;
  bool get clocking => _clocking;
  get memberToken => _memberToken;
  get memberProfile => _memberProfile;
  get clientAccountInfo => _clientAccountInfo;
  get identityNumber => _identityNumber;
  get branch => _branch;
  get showLoginProgressIndicator => _showLoginProgressIndicator;

  Future<void> memberLogin({required}) async {}

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setClocking(bool clocking) {
    _clocking = clocking;
    notifyListeners();
  }

  setToken({required String token}) {
    _memberToken = token;
    notifyListeners();
  }

  setClientAccountInfo({required ClientAccountInfo accountInfo}) {
    _clientAccountInfo = accountInfo;
    notifyListeners();
  }

  setBranch({required Branch branch}) {
    _branch = branch;
    notifyListeners();
  }

  setMemberProfileInfo({required MemberProfile memberProfile}) {
    _memberProfile = memberProfile;
    notifyListeners();
  }

  Future<void> login(
      {required BuildContext context,
      var phoneEmail,
      var password,
      required bool checkDeviceInfo}) async {
    debugPrint('PROVIDER LOGIN CLIENT');
    _showLoginProgressIndicator = true;
    MemberAPI()
        .login(
            context: context,
            phoneEmail: phoneEmail,
            password: password,
            checkDeviceInfo: checkDeviceInfo)
        .then((value) {
      if (value == 'login_error') {
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      } else if (value == 'network_error') {
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _memberProfile = value;
        getClientAccountInfo(
          context: context,
          clientId: _memberProfile!.clientId!,
        );
        debugPrint('TESTING ${value.memberToken}');
        debugPrint('INFO ${_memberProfile!.toJson()}');
      }
    });
    notifyListeners();
  }

  Future<void> getClientAccountInfo({
    required BuildContext context,
    required int clientId,
  }) async {
    MemberAPI()
        .getClientAccountInfo(
      clientId: clientId,
    )
        .then((value) {
      if (value == 'login_error') {
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      } else if (value == 'network_error') {
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _clientAccountInfo = value;
        getClientBranch(
          context: context,
          branchId: _clientAccountInfo!.applicantDesignationRole!,
        );

        debugPrint('Client name ${value.applicantFirstname}');
        debugPrint('Client id ${value.id}');
      }
    });
    notifyListeners();
  }

  Future<void> getClientBranch({
    required BuildContext context,
    required int branchId,
  }) async {
    MemberAPI()
        .getBranch(
      branchId: branchId,
    )
        .then((value) {
      _showLoginProgressIndicator = false;
      notifyListeners();
      if (value == 'login_error') {
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      } else if (value == 'network_error') {
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _branch = value;
        getIdentityNumber(context: context, memberId: 0);
        debugPrint('Branch name ${value.name}');
        debugPrint('Branch id ${value.id}');
      }
    });
    notifyListeners();
  }

  Future<void> getIdentityNumber({
    required BuildContext context,
    required int memberId,
  }) async {
    MemberAPI()
        .getIdentityNumber(
      memberId: _memberProfile!.id!,
    )
        .then((value) {
      _showLoginProgressIndicator = false;
      notifyListeners();
      if (value == 'login_error') {
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      } else if (value == 'network_error') {
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _identityNumber = value;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainPage(),
          ),
        );
      }
    });
    notifyListeners();
  }

  Future gettingDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //Android
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

    if (Platform.isAndroid) {
      var deviceInfoObj = {
        'systemDevice': 3,
        'deviceType': androidDeviceInfo.brand,
        'deviceId': androidDeviceInfo.id
      };

      print('Running on $deviceInfoObj'); //deviceType

      deviceInfoModel = DeviceInfoModel.fromJson(deviceInfoObj);
    } else if (Platform.isIOS) {
      var deviceInfoObj = {
        'systemDevice': 2,
        'deviceType': iosDeviceInfo.systemVersion,
        'deviceId': iosDeviceInfo.identifierForVendor
      };
      print('Running on ${iosDeviceInfo.utsname.machine}');
      deviceInfoModel = DeviceInfoModel.fromJson(deviceInfoObj);
    }
    return null;
  }

  void callDeviceRequestList(
      {required var memberToken,
      required var memberID,
      required BuildContext context}) async {
    // print('UserProvider token $token');
    deviceRequestList =
        await MemberAPI().getDeviceRequestList(context, memberToken, memberID);
    notifyListeners();
  }
}
