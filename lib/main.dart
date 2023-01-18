import 'package:akwaaba/constants/app_strings.dart';
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
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/providers/schoolManager_provider.dart';
import 'package:akwaaba/versionOne/splash_screen.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/post_clocking_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocationServices().getUserCurrentLocation();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
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
    ),
  );
}
