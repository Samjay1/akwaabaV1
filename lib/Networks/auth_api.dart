import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'api_responses/reset_password_response.dart';

class AuthAPI {
  /// BRANCHES

  // get list of account types
  static Future<List<AccountType>> getAccountTypes() async {
    List<AccountType> type = [];

    var url = Uri.parse('${getBaseUrl()}/generic/account-type');
    try {
      http.Response response = await http
          .get(
            url,
            //headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint("Account Type Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['data'] != null) {
        type = <AccountType>[];
        res['data'].forEach((v) {
          type.add(AccountType.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return type;
  }

  // get an account type
  static Future<AccountType> getAccountType({
    required int id,
  }) async {
    AccountType accountType;

    var url = Uri.parse('${getBaseUrl()}/generic/account-type/$id');
    try {
      http.Response response = await http
          .get(
            url,
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint("Account Type Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      accountType = AccountType.fromJson(
        res['data'],
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return accountType;
  }

  // reset member password
  static Future<ResetPasswordResponse> resetPassword({
    required int accountTypeId,
    required String email,
  }) async {
    ResetPasswordResponse _passwordResponse;

    var url = Uri.parse('${getBaseUrl()}/members/password/change');
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({"accountType": accountTypeId, "email": email}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: AppConstants.timOutDuration),
        onTimeout: () => throw FetchDataException(
          'Your internet connection is poor, please try again later!',
        ), // Time has run out, do what you wanted to do.
      );
      debugPrint("Reset Password Type Res: ${await returnResponse(response)}");
      _passwordResponse = ResetPasswordResponse.fromJson(
        await returnResponse(response),
      );
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return _passwordResponse;
  }

  // reset member password
  static Future<dynamic> changePassword({
    required String code,
    required String password,
    required String passwordConfirm,
  }) async {
    var _passwordResponse;

    var url = Uri.parse('${getBaseUrl()}/members/password/change');
    try {
      http.Response response = await http
          .post(
            url,
            body: json.encode({
              "code": code,
              "password": password,
              "password-confirm": passwordConfirm
            }),
            headers: await getAllHeaders(),
          )
          .timeout(
            const Duration(seconds: AppConstants.timOutDuration),
            onTimeout: () => throw FetchDataException(
              'Your internet connection is poor, please try again later!',
            ), // Time has run out, do what you wanted to do.
          );
      debugPrint("Reset Password Type Res: ${await returnResponse(response)}");
      _passwordResponse = await returnResponse(response);
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return _passwordResponse;
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
