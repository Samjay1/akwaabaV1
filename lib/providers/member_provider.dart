import 'dart:collection';
import 'dart:io';

import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/Networks/notification_api.dart';
import 'package:akwaaba/fcm/messaging_service.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/general/assigned_fee.dart';
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

  String? bill;
  String? accountExpiryDate;
  AssignedFee? assignedFee;

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

  void validateInputFields({
    required BuildContext context,
    required bool isAdmin,
    required String phoneEmail,
    required String password,
  }) {
    FocusManager.instance.primaryFocus?.unfocus(); //hide keyboard
    if (phoneEmail.isEmpty) {
      showErrorSnackBar(context, "Please input your email address or phone");
      return;
    }
    if (password.isEmpty) {
      showErrorSnackBar(context, "Please input your password");
      return;
    }
    login(
      context: context,
      phoneEmail: phoneEmail,
      password: password,
      isAdmin: isAdmin,
    );
  }

  // save token to backend
  Future<void> _saveFirebaseToken({required int memberId}) async {
    var msg = await NotificationAPI.saveMemberFirebaseToken(
      memberId: memberId,
      token: await MessagingService().getToken(),
    );
    debugPrint('MemberId: $memberId');
    debugPrint('Token: ${await MessagingService().getToken()}');
    debugPrint(msg);
  }

  Future<void> login({
    required BuildContext context,
    required phoneEmail,
    required password,
    required bool isAdmin,
  }) async {
    setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (context.mounted) {
        _memberProfile = await MemberAPI().login(
          context: context,
          phoneEmail: phoneEmail,
          password: password,
          checkDeviceInfo: false,
        );
        if (_memberProfile != null && _memberProfile!.nonFieldErrors != null) {
          setLoading(false);
          showErrorToast(_memberProfile!.nonFieldErrors![0]);
          return;
        }
        prefs.setString('token', _memberProfile!.token!);
        // save member firebase token
        _saveFirebaseToken(memberId: _memberProfile!.user!.id!);
        // ignore: use_build_context_synchronously
        getClientAccountInfo(
          context: context,
          clientId: _memberProfile!.user!.clientId!,
          branchId: _memberProfile!.user!.branchId!,
          phoneEmail: phoneEmail,
          password: password,
        );
      }
    } catch (err) {
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> getClientAccountInfo({
    required BuildContext context,
    required int clientId,
    required int branchId,
    required phoneEmail,
    required password,
  }) async {
    MemberAPI()
        .getClientAccountInfo(
      clientId: clientId,
    )
        .then((value) {
      if (value == 'login_error') {
        setLoading(false);
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      }
      if (value == 'network_error') {
        setLoading(false);
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _clientAccountInfo = value;
        getMemberBranch(
          context: context,
          branchId: branchId,
          phoneEmail: phoneEmail,
          password: password,
        );
        debugPrint('Client name ${value.applicantFirstname}');
        debugPrint('Client id ${value.id}');
      }
    });
    notifyListeners();
  }

  Future<void> getMemberBranch({
    required BuildContext context,
    required int branchId,
    required phoneEmail,
    required password,
  }) async {
    MemberAPI()
        .getBranch(
      branchId: branchId,
    )
        .then((value) {
      notifyListeners();
      if (value == 'login_error') {
        setLoading(false);
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      }
      if (value == 'network_error') {
        setLoading(false);
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        _branch = value;
        getIdentityNumber(
          context: context,
          memberId: 0,
          phoneEmail: phoneEmail,
          password: password,
        );
        debugPrint('Branch name ${value.name}');
        debugPrint('Branch id ${value.id}');
      }
    });
    notifyListeners();
  }

  Future<void> getIdentityNumber({
    required BuildContext context,
    required int memberId,
    required phoneEmail,
    required password,
  }) async {
    MemberAPI()
        .getIdentityNumber(
      memberId: _memberProfile!.user!.id!,
    )
        .then((value) async {
      if (value == 'login_error') {
        setLoading(false);
        showErrorSnackBar(context, "Incorrect Login Details");
        return;
      }
      if (value == 'network_error') {
        setLoading(false);
        showErrorSnackBar(context, "Network Issue");
        return;
      } else {
        setLoading(false);
        _identityNumber = value;
        await getAssignedFees(); // fetch assigned fees for a member
        //showNormalToast('Login successful');
        if (context.mounted) {
          Provider.of<GeneralProvider>(context, listen: false)
              .setAdminStatus(isAdmin: false);
          SharedPrefs().setUserType(userType: "member");
          SharedPrefs().saveLoginCredentials(
              emailOrPhone: phoneEmail, password: password);
          SharedPrefs().saveMemberInfo(memberProfile: _memberProfile!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainPage(),
            ),
          );
        }
      }
    });
    notifyListeners();
  }

  // get member assigned fees
  Future<void> getAssignedFees() async {
    try {
      var result = await MemberAPI().getAssignedFees();
      if (result != null) {
        assignedFee = result;

        getOutstandingBill();
      }
    } catch (err) {
      setLoading(false);
    }
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

      print('Running on $deviceInfoObj'); // deviceType

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

  Future<void> callDeviceRequestList(
      {required var memberToken,
      required var memberID,
      required BuildContext context}) async {
    setLoading(true);
    try {
// print('UserProvider token $token');
      deviceRequestList = await MemberAPI()
          .getDeviceRequestList(context, memberToken, memberID);
      setLoading(false);
    } catch (err) {
      setLoading(false);
    }

    notifyListeners();
  }

  // get member outstanding bill
  Future<void> getOutstandingBill() async {
    try {
      var result = await MemberAPI().getMemberOutstandingBill();
      bill = result;
    } catch (err) {
      setLoading(false);
      bill = 'N/A';
    }
    notifyListeners();
  }

  void clearData() {
    _clientAccountInfo = null;
    //_memberProfile = null;
    _branch = null;
    _identityNumber = null;
    assignedFee = null;
    bill = null;
  }
}
