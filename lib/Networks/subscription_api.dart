import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscriptionAPI {
  // get list of subscriptions
  // static Future<List<ClientSubscription>>
  //     getClientCurrentSubscriptions() async {
  //   List<ClientSubscription> clientSubscription = [];

  //   var url = Uri.parse('${getBaseUrl()}/clients/subscription/info/current');
  //   try {
  //     http.Response response = await http.get(
  //       url,
  //       headers: await getAllHeaders(),
  //     ).timeout(
  //   const Duration(seconds: AppConstants.timOutDuration),
  //   onTimeout: () => throw FetchDataException(
  //     'Your internet connection is poor, please try again later!',
  //   ), // Time has run out, do what you wanted to do.
  // );
  //     debugPrint("Client Sub: ${await returnResponse(response)}");
  //     var res = await returnResponse(response);
  //     if (res['results'] != null) {
  //       clientSubscription = <ClientSubscription>[];
  //       res['results'].forEach((v) {
  //         clientSubscription.add(ClientSubscription.fromJson(v));
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     debugPrint('No net');
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return clientSubscription;
  // }

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
