import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/versionOne/login_page.dart';
import 'package:akwaaba/versionOne/main_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.asset("images/logo_transparent.png"),
            const CustomProgressIndicator()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initFunctions();
  }

  initFunctions() async {
    SharedPrefs().getLoginCredentials().then((value) {
      if (value.isNotEmpty) {
        //login credentials exists, open home page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainPage()));
      } else {
        //no login credentials, open login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    }).catchError((e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }
}
