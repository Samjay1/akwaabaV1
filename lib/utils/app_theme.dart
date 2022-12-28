import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const backgroundColor = Color(0xFFF4F4F5); //f3f2f2
// const backgroundColorDark = const Color(0xff0a0909);

const primaryColor = Color(0xFFeb8200);
const primaryColorLight = Color(0xFFE8A148);
const primaryColorDark = Color(0xFFc25e00);

const textColorPrimary = Color(0xFF000000);
const textColorDark = Color(0xFF000000);
const textColorLight = Color(0xFF3F3E3E);

const whiteColor = Colors.white;
const blackColor = Colors.black;

const fillColor = Color(0xFFEBECEE);

class AppTheme {
  static final ThemeData defaultTheme = _buildMyTheme();
  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      canvasColor: backgroundColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(primary: Colors.white),
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: Colors.white,
      backgroundColor: backgroundColor,
      unselectedWidgetColor: primaryColorLight,
      brightness: Brightness.light,
      textTheme: base.textTheme.copyWith(
          caption: base.textTheme.caption!.copyWith(
              color: textColorDark,
              fontSize: 12,
              fontWeight: FontWeight.w200,
              fontFamily: "Lato"),
          headline4: base.textTheme.headline4!.copyWith(
              color: textColorLight,
              fontFamily: "Lato",
              fontSize: 23,
              fontWeight: FontWeight.w600),
          headline5: base.textTheme.headline5!.copyWith(
              color: textColorPrimary,
              fontSize: 20,
              fontFamily: "Lato",
              fontWeight: FontWeight.w600),
          headline6: base.textTheme.headline6!
              .copyWith(color: textColorPrimary, fontFamily: "Rubik"),
          bodyText2: base.textTheme.bodyText2!.copyWith(
              color: textColorPrimary,
              fontFamily: "Lato",
              fontSize: 16,
              fontWeight: FontWeight.w400),
          bodyText1: base.textTheme.bodyText1!.copyWith(
            color: textColorPrimary,
            fontFamily: "Lato",
          )),
      colorScheme: base.colorScheme.copyWith(primary: primaryColor),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          statusBarColor: primaryColor,
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 19),
      ),
    );
  }
}
