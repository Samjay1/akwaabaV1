import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/models/general/notification_type.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationAPI {
  // get notification types for a user
  static Future<List<NotificationType>> getNotificationTypes() async {
    List<NotificationType> notificationTypes = [];
    var url = Uri.parse('${getBaseUrl()}/members/notification-type');
    try {
      http.Response response = await http.get(
        url,
        headers: await getAllHeaders(),
      );
      debugPrint("Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);

      if (res != null) {
        notificationTypes = <NotificationType>[];
        res.forEach((v) {
          notificationTypes.add(NotificationType.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return notificationTypes;
  }

  // save member firebase token
  static Future<String> saveMemberFirebaseToken({
    required memberId,
    required token,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/user-firebase-token');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({"memberId": memberId, "token": token}),
        headers: await getAllHeaders(),
      );
      debugPrint("Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
  }

  // save client firebase token
  static Future<String> saveClientFirebaseToken({
    required clientId,
    required token,
  }) async {
    String message;
    var url = Uri.parse('${getBaseUrl()}/members/client-user-firebase-token');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({"clientUserId": clientId, "token": token}),
        headers: await getAllHeaders(),
      );
      debugPrint("Response: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      message = res['SUCCESS_RESPONSE_MESSAGE'];
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return message;
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
