import 'dart:async';

import 'package:akwaaba/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class Notifier {
  //instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  static String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static String darwinNotificationCategoryPlain = 'plainCategory';

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  // initialize notification class
  static Future init() async {
    // initialization Settings for Android
    // const androidInitialize =
    //     AndroidInitializationSettings('mipmap/ic_launcher');

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    // initialization Settings for iOS
    // const iOSInitialize = IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   //onDidReceiveLocalNotification: onDidReceiveLocalNotification
    // );

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    // initializing settings for both platforms (Android & iOS)
    // const initializationSettings =
    //     InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // initialize time zone database
    // _setupTimezone();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        selectNotificationStream.add(notificationResponse.payload);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          selectNotificationStream.add(notificationResponse.payload);
        }
        break;
    }
  }

  static requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // setup and send notification
  static Future showNotifications(
      {var id = 0,
      required String title,
      required String body,
      var payload}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      AppConstants.notificationChannelKey,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future scheduleNotifications(
      {var id = 0,
      required String title,
      required String body,
      required DateTime time,
      var payload}) async {
    // get the user current location.
    var _locations = tz.timeZoneDatabase.locations;
    final location = await tz.getLocation(_locations.keys.first);

    // schedule notification to 5 mins before scedule
    var schedule_5before = tz.TZDateTime(location, time.year, time.month,
            time.day, time.hour, time.minute, time.second)
        .subtract(const Duration(minutes: 5));

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          schedule_5before,
          NotificationDetails(
              android: AndroidNotificationDetails(
            AppConstants.notificationChannelKey,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDescription,
            playSound: true,
            sound:
                const RawResourceAndroidNotificationSound('notification_sound'),
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          )),
          androidAllowWhileIdle: true,
          payload: payload,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

      debugPrint("Notification schedule sent");
    } catch (e) {
      debugPrint("Scheduling notification: ${e.toString()}");
    }
  }

  static onSelectNotification(String? payload) async {
    //Navigate to wherever you want
    try {
      // if(payload != null && payload.isNotEmpty){
      //   if(payload == Routes.APPOINTMENT_SCREEN){
      //     Get.toNamed(Routes.IND_DASHBOARD_SCREEN, arguments: 1);
      //   }
      //   if(payload== Routes.IND_SESSION_SCREEN && UserPrefs.getUser()!.role == indUserType){
      //     Get.toNamed(Routes.IND_DASHBOARD_SCREEN, arguments: 2);
      //   }
      //   if(payload == Routes.PRO_SESSION_SCREEN && UserPrefs.getUser()!.role == proUserType){
      //     Get.toNamed(Routes.PRO_SESSION_SCREEN, arguments: 1);
      //   }
      // }
    } catch (err) {}
  }

  // schedule time to 5 mins less
  static DateTime scheduledTime(DateTime currentDate, TimeOfDay currentTime) =>
      currentDate.add(Duration(
          hours: (currentTime.minute.toString() == '00'
              ? (currentTime.hour > 10
                  ? currentTime.hour - 1
                  : currentTime.hour - 1)
              : currentTime.hour),
          minutes: (currentTime.minute.toString() == '00'
              ? 60 - 5
              : currentTime.minute - 5),
          seconds: currentDate.second));
}
