import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/client_provider.dart';

class RestrictionUtil {
  static final RestrictionUtil _instance = RestrictionUtil.internal();
  factory RestrictionUtil() => _instance;

  RestrictionUtil.internal();

  Future<bool> hasAttendanceModule(BuildContext context) async {
    ClientAccountInfo? clientAccountInfo;
    bool hasAttendance = false;
    var userType = await SharedPrefs().getUserType();
    if (context.mounted) {
      userType == AppConstants.admin
          ? clientAccountInfo =
              Provider.of<ClientProvider>(context, listen: false).getUser
          : clientAccountInfo =
              Provider.of<MemberProvider>(context, listen: false)
                  .clientAccountInfo;
    }
    if (clientAccountInfo != null &&
        clientAccountInfo.subscriptionInfo != null &&
        clientAccountInfo.subscriptionInfo!.subscribedModules!.module2 ==
            null) {
      hasAttendance = false;
    } else {
      hasAttendance = true;
    }
    return hasAttendance;
  }

  // show alert to admin if he hasn't subscribed to the attendance module
  void showAdminAttendanceAlert(BuildContext context) {
    if (context.mounted) {
      showInfoDialog(
        'ok',
        dismissible: false,
        context: context,
        title: 'Hey there!',
        content:
            'Sorry, you don\'t have access to this attendance feature, you must subscribe to the attendance module. Thank you',
        onTap: () => Navigator.pop(context),
      );
    }
  }

  // show alert to member if client hasn't subscribed to the attendance module
  void showMemberAttendanceAlert(BuildContext context) {
    if (context.mounted) {
      showInfoDialog(
        'ok',
        dismissible: false,
        context: context,
        title: 'Hey there!',
        content:
            'Sorry, you don\'t have access to this attendance feature, please contact admin for assistance. Thank you',
        onTap: () => Navigator.pop(context),
      );
    }
  }
}
