
import 'dart:convert';
import 'dart:io';

import 'package:akwaaba/models/fee_manager/feeDescription_model.dart';
import 'package:akwaaba/models/fee_manager/feeType_model.dart';
import 'package:akwaaba/models/fee_manager/member_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/fee_manager/clientTotal_model.dart';
class FeeManagerAPi{
  final baseUrl = 'https://fees.akwaabasoftware.com/api';

  //FEE TYPES
  Future<List<FeeType>> feeTypesFunc ({required BuildContext context, var clientId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$baseUrl/fee-types/$clientId/')
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        Iterable feeResponse = decodedResponse;
        print(decodedResponse.toString());
        return feeResponse.map((value) => FeeType.fromJson(value)).toList();
      } else {
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network issue')));
      return [];
    }
  }

  //FEE DESCRIPTION
  Future<List<FeeDescription>> feeDescFunc ({required BuildContext context, var clientId}) async{
      try{
        http.Response response = await http.get(
            Uri.parse('$baseUrl/fee-descriptions/$clientId/')
        );
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(response.body);
          Iterable feeResponse = decodedResponse;

          print(decodedResponse.toString());
          return feeResponse.map((value) => FeeDescription.fromJson(value)).toList();
        } else {
          return [];
        }
      } on SocketException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network issue')));
        return [];
      }
    }


  //  PAYMENT HISTORY
  Future<List<MemberModel>> paymentHistoryFunc ({required BuildContext context, var clientId}) async{
    print('PAYMENT HISTORY');
    try{
      http.Response response = await http.get(
          Uri.parse('$baseUrl/payment-history/?client_id=$clientId')
      );
      if (response.statusCode == 200) {
        // print('PAYMENT HISTORY2');
        var decodedResponse = jsonDecode(response.body);
        Iterable membersResponse = decodedResponse['data'];
        // print(decodedResponse.toString());
        return membersResponse.map((value) => MemberModel.fromJson(value)).toList();
      } else {
        // print('PAYMENT HISTORY4');
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network issue')));
      return [];
    }
  }

  // FILTER PAYMENT HISTORY
  Future<List<MemberModel>> filterPaymentHistoryFunc ({required BuildContext context, var clientId, var feeType, var feeDesc, var startDate, var endDate}) async{
    print('FILTER PAYMENT HISTORY');
    try{
      http.Response response = await http.get(
          Uri.parse('$baseUrl/payment-history/?client_id=$clientId&fee_type=$feeType&fee_description=$feeDesc&start_date=$startDate&end_date=$endDate')
      );
      if (response.statusCode == 200) {
        // print('PAYMENT HISTORY2');
        var decodedResponse = jsonDecode(response.body);
        Iterable membersResponse = decodedResponse['data'];
        print(decodedResponse.toString());
        return membersResponse.map((value) => MemberModel.fromJson(value)).toList();
      } else {
        // print('PAYMENT HISTORY4');
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network issue')));
      return [];
    }
  }


  // CLIENT TOTAL PAID,ASSIGNED,ARREARS
  Future<ClientTotalModel?> clientTotalBill ({required BuildContext context, var clientId}) async{
    print('clientTotalBill');
    try{
      http.Response response = await http.get(
          Uri.parse('$baseUrl/client-total/$clientId/')
      );
      if (response.statusCode == 200) {
        print('PAYMENT HISTORY2');
        var decodedResponse = jsonDecode(response.body);
        print(decodedResponse.toString());
        return ClientTotalModel.fromJson(decodedResponse);
      } else {
        // print('PAYMENT HISTORY4');
        return null;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network issue')));
      return null;
    }
  }



}