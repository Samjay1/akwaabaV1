import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/providers/event_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/feeManager_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
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
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ClockingProvider()),
        ChangeNotifierProvider(create: (_) => PostClockingProvider()),
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
