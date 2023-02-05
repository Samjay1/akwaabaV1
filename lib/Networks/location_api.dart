import 'dart:convert';
import 'dart:io';
import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/country.dart';
import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/region.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationAPI {
  // get list of coutries
  static Future<List<Country>> getCountries() async {
    List<Country> countries = [];

    var url = Uri.parse('${getBaseUrl()}/locations/country');
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
      debugPrint("Branch Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res != null) {
        countries = <Country>[];
        res.forEach((v) {
          countries.add(Country.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return countries;
  }

  // get list of regions
  static Future<List<Region>> getRegions() async {
    List<Region> regions = [];

    var url = Uri.parse('${getBaseUrl()}/locations/region');
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
      debugPrint("Branch Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res != null) {
        regions = <Region>[];
        res.forEach((v) {
          regions.add(Region.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return regions;
  }

  // get list of districts
  static Future<List<District>> getDistricts() async {
    List<District> districts = [];

    var url = Uri.parse('${getBaseUrl()}/locations/district');
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
      debugPrint("Branch Res: ${await returnResponse(response)}");
      var res = await returnResponse(response);
      if (res['results'] != null) {
        districts = <District>[];
        res['results'].forEach((v) {
          districts.add(District.fromJson(v));
        });
      }
    } on SocketException catch (_) {
      debugPrint('No net');
      throw FetchDataException('No Internet connection');
    }
    return districts;
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
