import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/fcm/messaging_service.dart';
import 'package:akwaaba/fcm/noti.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/providers/all_events_provider.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/auth_provider.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/feeManager_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/leave_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/providers/schoolManager_provider.dart';
import 'package:akwaaba/providers/profile_provider.dart';
import 'package:akwaaba/versionOne/splash_screen.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/post_clocking_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebaseApp();

  LocationServices().getUserCurrentLocation();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_registerBackgroundMessageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(_registerMessageOpenedHandler);
  runApp(
    const MyApp(),
  );
}

Future initFirebaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  await MessagingService().init();
}

/// Top level function to handle incoming messages when the app is in the background
Future<void> _registerBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint(" -----background message received-----");
  debugPrint(
      "onBackgroundMessage ${message.notification?.title}/${message.notification?.body}");
  MessagingService.showBigTextNotification(
    title: message.notification!.title!,
    body: message.notification!.body!,
    payload: message.data.toString(),
  );
}

// Navigate user to the ask expert page when notification is tapped
Future<void> _registerMessageOpenedHandler(RemoteMessage message) async {
  // if(message.data["screen"] == Routes.APPOINTMENT_SCREEN){
  //   Get.toNamed(Routes.APPOINTMENT_SCREEN);
  // }
  // if(message.data["screen"] == Routes.IND_SESSION_SCREEN && UserPrefs.getUser()!.role == indUserType){
  //   Get.toNamed(Routes.IND_SESSION_SCREEN);
  // }
  // if(message.data["screen"] == Routes.PRO_SESSION_SCREEN && UserPrefs.getUser()!.role == proUserType){
  //   Get.toNamed(Routes.PRO_SESSION_SCREEN);
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Noti().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AllEventsProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ClockingProvider()),
        ChangeNotifierProvider(create: (_) => PostClockingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MembersProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
      ],
      child: MaterialApp(
        key: scaffoldMessengerKey,
        initialRoute: 'splashScreen',
        onGenerateRoute: (RouteSettings settings) {
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
        routes: {
          "splashScreen": (context) => const SplashScreen(),
        },
        title: "Akwaaba",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.defaultTheme,
      ),
    );
  }
}
