

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:akwaaba/models/client_model.dart';

import '../models/client_account_info.dart';
import '../providers/client_provider.dart';
import '../utils/widget_utils.dart';

class UserApi{
  final baseUrl = 'https://db-api-v2.akwaabasoftware.com';
  late SharedPreferences prefs;


  Future login({required BuildContext context, var phoneEmail, var password}) async{
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password
      };

      http.Response response = await http.post(
          Uri.parse('$baseUrl/clients/login'),
          body: data);
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var clientToken = decodedResponse['token'];
        debugPrint('CLIENT API');
        debugPrint(decodedResponse['user'].toString());
        //SET THE USER TOKEN TO PREFS
        var user = decodedResponse['user'];
        prefs.setString('client_token', clientToken);
        prefs.setString('account_type', 'client');


        debugPrint(' CLIENT token $clientToken');
        Provider.of<ClientProvider>(context,listen: false).setClientToken(token: clientToken);

        var accountId = decodedResponse['user']['accountId'];
        print('accountId $accountId');

        // debugPrint('FULL CLIENT INFO $clientToken');
          //GET FULL ACCOUNT DETAILS FROM API USING ACCOUNT-ID PARAM FROM LOGIN RESPONSE
        var headers = {
          'Authorization': 'Token $clientToken',
          'Content-Type': 'application/json'
        };
          http.Response clientResponse = await http.get(
            Uri.parse('$baseUrl/clients/account/$accountId'),
              headers: headers
          );
          var clientDecodedResponse = jsonDecode(clientResponse.body);
          if(clientResponse.statusCode == 200){
            var clientData = clientDecodedResponse['data'];
            debugPrint('FULL CLIENT INFO ${clientData.toString()}');
            return ClientAccountInfo.fromJson(clientData,user, clientToken);
          }else{
            debugPrint('ERROR:FULL CLIENT INFO $clientDecodedResponse');
            return 'login_error';
          }

        // return ClientAccountInfo.fromJson(user, branchId, clientToken);
      } else {
        return 'login_error';
      }
    }on SocketException catch(_){
      return 'network_error';
    }
  }

  Future<String>adminLogin({required  var phoneEmail, required var password})async{
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password,
      };


      http.Response response = await http.post(
          Uri.parse('$baseUrl/clients/login'),
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        return response.body;
      } else {
       // debugPrint("error>>>. ${response.body}");
        showErrorToast("Login Error");
        return '';
      }
    }on SocketException catch(_){
      showErrorToast("Network Error");

      return '';
    }
  }

  Future register({var phoneEmail, var password}) async{
    try {
      prefs = await SharedPreferences.getInstance();
      var data = {
        'phone_email': phoneEmail,
        'password': password
      };

      http.Response response = await http.post(
          Uri.parse('$baseUrl/clients/login'),
          body: data);
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var clientToken = decodedResponse['token'];
        debugPrint('CLIENT API');
        debugPrint(decodedResponse.toString());
        //SET THE USER TOKEN TO PREFS
        var user = decodedResponse['user'];
        prefs.setString('client_token', clientToken);
        prefs.setString('account_type', 'client');
        return ClientModel.fromJson(user);
      } else {
        return 'login_error';
      }
    }on SocketException catch(_){
      return 'network_error';
    }
  }



}