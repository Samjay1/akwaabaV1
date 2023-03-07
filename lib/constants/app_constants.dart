import 'package:akwaaba/utils/general_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static const int mainAdmin = 1;
  static const int pageLimit = 10;
  static const String member = 'member';
  static const String admin = 'admin';
  static const int male = 1;
  static const int female = 2;
  static const int meetingTypeMeeting = 1;
  static const int meetingTypeEvent = 2;
  static const int timOutDuration = 12;
  static const int searchTimerDuration = 600;
  static String? token;

  static String supportNumber = '+233206007255';

  static int notificationChannelId = 001;
  static String notificationChannelKey = "Akwaaba";
  static String notificationChannelName = "Akwaaba notifications";

  //static String NOTIFICATIONS_CHANNEL_KEY = "mmr";
  //static String NOTIFICATIONS_CHANNEL_GROUP_KEY = "mmr_app";
  static String notificationChannelDescription =
      "Notification channel to receive notifications on Akwaaba app";

// get user token
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }

// redirection url to create meeting
  static createMeetingRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('settings/schedule-form')}";
  }

// redirection url to update meeting
  static updateMeetingRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('settings/schedules')}";
  }

  // redirection url to verify new member
  static verifyNewMemberRedirectUrl() async {
    var token = await getToken();
    return "$databaseManagerUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('member/verifications')}";
  }

  // redirection url to verify new organization
  static verifyNewOrgRedirectUrl() async {
    var token = await getToken();
    return "$databaseManagerUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('member/organization/verifications')}";
  }

  // redirection url to verify new organization
  static addAdminUserRedirectUrl() async {
    var token = await getToken();
    return "$databaseManagerUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('admin/user/accounts')}";
  }

// redirection url to assign leave
  static assignLeaveRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('absent-leave/assign-al-status')}";
  }

// redirection url to view leave
  static viewLeaveRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('absent-leave/view-al-assignment')}";
  }

// redirection url to approve device activation requests
  static approveDeviceRequestRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('devices/device-requests')}";
  }

  // redirection url to view follow up reports
  static followUpReportRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('clocking/follow-up?clocking-id=MTQzNzM0')}";
  }

  // redirection url to apply for leave
  static applyLeaveRedirectUrl() async {
    var token = await getToken();
    return "$attendanceBaseUrl/app-reroute?permission-key=${base64TokenEncoding(token)}&access-page-key=${base64TokenEncoding('absent-leave/assign-al-status')}";
  }

  // redirection url to renew client account
  static renewAccountRedirectUrl() async {
    var token = await getToken();
    return "https://super.akwaabasoftware.com/api/renew-subscription/token=$token/";
  }

  // youtube tutorial links
  static const String userTutorialUrl =
      'https://www.youtube.com/playlist?list=PLFAuolFyRZkMz1ddw3i5jgcDtkpJdoSQC';

  static const String adminTutorialUrl =
      'https://www.youtube.com/playlist?list=PLFAuolFyRZkODj6ERq_Vn_6_T-TZKcmlE';

  static const String akwaabaConnectUrl =
      'https://connect.akwaabasoftware.com/';
  static const String adminFormUrl = 'https://adminform.akwaabasoftware.com/';
  static const String userFormUrl = 'https://userform.akwaabasoftware.com/';
  static const String akwaabaEduUrl = 'https://edu.akwaabasoftware.com/';
  static const String akwaabaMessengerUrl =
      'https://messenger.akwaabasoftware.com';
  static const String akwaabaProfileUrl = '';
  static const String akwaabaPaymentUrl = 'https://tuakaonline.com';

  static const String attendanceBaseUrl = 'https://clock.akwaabasoftware.com';
  static const String databaseBaseUrl = 'https://database.akwaabasoftware.com/';

  static const String databaseManagerUrl =
      'https://database.akwaabasoftware.com';
  static const String attendanceManagerUrl =
      'https://clock.akwaabasoftware.com';
  static const String cashManagerUrl = 'https://cash.akwaabasoftware.com';

  static const String followUpReportUrl =
      'https://clock.akwaabasoftware.com/clocking/follow-up?clocking-id=MTQzNzM0';
}
