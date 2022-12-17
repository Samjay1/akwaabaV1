

import 'dart:convert';
import 'dart:io';

import 'package:akwaaba/models/school_manager/assessmentType_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:akwaaba/models/client_model.dart';

class SchoolManagerApi{
  final baseUrl = 'https://edu.akwaabasoftware.com/api';
  late SharedPreferences prefs;


  Future login({var email, var password,var role}) async{
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'email': email,
        'password': password,
        'role': role
      };

      http.Response response = await http.post(
          Uri.parse('$baseUrl/login/'),
          body: data);
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var schoolToken = decodedResponse['school_token'];
        debugPrint('School API');
        debugPrint(decodedResponse.toString());
        //SET THE USER TOKEN TO PREFS
        prefs.setString('school_token', schoolToken);
        return schoolToken;
      } else {
        return 'login_error';
      }
    }on SocketException catch(_){
      return 'network_error';
    }
  }

  Future<List<AssessmentTypeModel>> AssessmentTypeApi() async{
    try {
      prefs = await SharedPreferences.getInstance();
      http.Response response = await http.get(
          Uri.parse('$baseUrl/assessment-types/'));
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint('assessmentTypes API');
        debugPrint(decodedResponse.toString());
        //SET THE USER TOKEN TO PREFS
        Iterable response = decodedResponse;
        return response.map((data) => AssessmentTypeModel.fromJson(data)).toList();
      } else {
        return [];
      }
    }on SocketException catch(_){
      return [];
    }
  }
}