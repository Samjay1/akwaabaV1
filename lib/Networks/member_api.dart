
import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MemberAPI{
  final baseUrl = 'https://db-api-v2.akwaabasoftware.com';
  late SharedPreferences prefs;

  Future<String>userLogin({required String phoneEmail, required String password,
  required bool checkDeviceInfo})async{
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password,
        "checkDeviceInfo":checkDeviceInfo
      };

      debugPrint("Data $data");

      http.Response response = await http.post(
          Uri.parse('$baseUrl/members/login'),
          body: json.encode(data),
      headers: {
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
        return '';
      }
    }on SocketException catch(_){
      showErrorToast("Network Error");

      return '';
    }
  }
}