import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileAPI {
  // enable profile editing for a user
  static Future<String> enableProfileEditing({
    required int memberId,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/user/enable-editable');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'memberId': memberId,
        }),
        headers: await getAllHeaders(),
      );
      debugPrint("Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      //debugPrint("Message: ${res['SUCCESS_RESPONSE_MESSAGE']}");
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // enable bulk profile editing f
  static Future<String> enableBulkProfileEditing({
    required List<int?> memberIds,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/user/enable-editable-bulk');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'memberIds': memberIds,
        }),
        headers: await getAllHeaders(),
      );
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // disable bulk profile editing
  static Future<String> disableBulkProfileEditing({
    required List<int?> memberIds,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/user/disable-editable-bulk');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'memberIds': memberIds,
        }),
        headers: await getAllHeaders(),
      );
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // disable profile editing for a user
  static Future<String> disableProfileEditing({
    required int memberId,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/user/disable-editable');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'memberId': memberId,
        }),
        headers: await getAllHeaders(),
      );
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  static Future<Map<String, String>> getTokenHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberToken = prefs.getString('token');
    return {
      'Authorization': 'Token $memberToken',
    };
  }

  static Future<Map<String, String>> getAllHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberToken = prefs.getString('token');
    return {
      'Authorization': 'Token $memberToken',
      'Content-Type': 'application/json'
    };
  }

  static bool isDevelopment = false;

  static String getBaseUrl() {
    if (isDevelopment) {
      return 'https://db-api-v2.akwaabasoftware.com';
    } else {
      return 'https://db-api-v2.akwaabasoftware.com';
    }
  }

  // return response from api
  static dynamic returnResponse(http.Response response) async {
    if (kDebugMode) {
      debugPrint(response.statusCode.toString());
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        // print(response.body);
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      case 400:
        debugPrint('Bad Request');
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      //throw BadRequestException(responseJson['message']);
      case 401:
      case 403:
        debugPrint('UnauthorisedException');
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
      //throw UnauthorisedException(responseJson['message']);
      case 500:
      default:
        // decode response
        var responseJson = jsonDecode(response.body);
        debugPrint(responseJson.toString());
        return responseJson;
    }
  }
}
