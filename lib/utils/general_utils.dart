import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
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

openwhatsapp(BuildContext context, String phone, String message) async {
  var whatsapp = "+919144040888";
  var whatsappURl_android = "whatsapp://send?phone=$phone&text=$message";
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
    if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
      await launchUrl(Uri.parse(whatsappURl_android));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("whatsapp not installed"),
        ),
      );
    }
  }
}
