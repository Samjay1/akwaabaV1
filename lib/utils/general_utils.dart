import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/*
includes codes to
1. generate random numbers
 */

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

// calculate the distance between two locations
double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

String formattedPhone(String code, String phone) {
  return phone.startsWith("0")
      ? '${code.substring(1)}${phone.substring(1, phone.length)}'
      : '${code.substring(1)}$phone';
}

// // open email app
// openEmailApp(String? toEmail, String? emailSubject, String? emailBody) async {
//   String email = Uri.encodeComponent(toEmail!);
//   String subject = Uri.encodeComponent(emailSubject!);
//   String body = Uri.encodeComponent(emailBody!);
//   Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
//   if (await canLaunchUrl(mail)) {
//     await launchUrl(mail);
//   } else {
//     //email app is not opened
//     throw 'Caould not launch email app';
//   }
// }

// open email app
openEmailApp(BuildContext context) async {
  // Android: Will open mail app or show native picker.
  // iOS: Will open mail app if single mail app found.
  var result = await OpenMailApp.openMailApp();

  // If no mail apps found, show error
  if (!result.didOpen && !result.canOpen) {
    showInfoDialog(
      'ok',
      context: context,
      title: 'Open Mail App',
      content: 'No mail apps installed',
      onTap: () => Navigator.pop(context),
    );
    // iOS: if multiple mail apps found, show dialog to select.
    // There is no native intent/default app system in iOS so
    // you have to do it yourself.
  } else if (!result.didOpen && result.canOpen) {
    showDialog(
      context: context,
      builder: (_) {
        return MailAppPickerDialog(
          mailApps: result.options,
        );
      },
    );
  }
}

// get branch based on user type
Future<Branch> getUserBranch(BuildContext context) async {
  // get selected branch
  Branch? branch;
  if (await SharedPrefs().getUserType() == AppConstants.admin) {
    branch = Provider.of<ClientProvider>(context, listen: false).branch;
  } else {
    branch = Provider.of<MemberProvider>(context, listen: false).branch;
  }
  return branch!;
}

// checks if account is active or has expired
bool isActive(DateTime expiryDate) {
  var currentDate = DateTime.now();
  return expiryDate.isAfter(currentDate) ? true : false;
}

// convert token to base64 encoded
String base64TokenEncoding(String token) {
  var encoded = base64.encode(utf8.encode(token));
  return encoded;
}

// open whatsapp app
openWhatsapp(BuildContext context, String phone, String message) async {
  var whatsappURl_android =
      Uri.parse("whatsapp://send?phone=$phone&text=$message");
  //var whatsappURl_android = Uri.parse("https://wa.me/$phone");
  var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse(message)}";
  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatappURL_ios))) {
      await launch(whatappURL_ios, forceSafariVC: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("whatsapp not installed"),
        ),
      );
    }
  } else {
    // android , web
    if (await canLaunchUrl(whatsappURl_android)) {
      await launchUrl(whatsappURl_android);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("whatsapp not installed"),
        ),
      );
    }
  }
}
