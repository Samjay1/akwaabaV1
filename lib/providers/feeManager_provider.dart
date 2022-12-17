
import 'package:akwaaba/Networks/feeManagerApi.dart';
import 'package:akwaaba/models/client_model.dart';
import 'package:akwaaba/models/school_manager/assessmentType_model.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Networks/schoolManager_api.dart';

class FeeProvider extends ChangeNotifier {
  var _feeTypesList;
  var _feeDescList;
  var paymentHistoryList;
  var clientBill;


  get getFeeTypesList => _feeTypesList;

  get getFeeDescList => _feeDescList;

  get getPaymentHistoryList => paymentHistoryList;

  get getterClientBill => clientBill;

  void getFeeTypes({required BuildContext context, var clientId}) async{
    this._feeTypesList = await FeeManagerAPi().feeTypesFunc(context:context, clientId: clientId);
    notifyListeners();
  }

  void getFeeDesc({required BuildContext context, var clientId}) async{
    this._feeDescList = await FeeManagerAPi().feeDescFunc(context:context, clientId: clientId);
    notifyListeners();
  }

  void getPaymentHistory({required BuildContext context, var clientId}) async{
    this.paymentHistoryList = await FeeManagerAPi().paymentHistoryFunc(context:context, clientId: clientId);
    notifyListeners();
  }
  void getFilterPaymentHistory({required BuildContext context, var clientId, var feeType, var feeDesc, var startDate, var endDate}) async{
    print('fee desc: $feeDesc , fee type: $feeType , startYear : $startDate , endYear: $endDate');
    this.paymentHistoryList = await FeeManagerAPi().filterPaymentHistoryFunc(context:context, clientId: clientId, feeType:feeType, feeDesc:feeDesc, startDate:startDate, endDate:endDate);
    notifyListeners();
  }

  void getClientBill({required BuildContext context, var clientId}) async{
    this.clientBill = await FeeManagerAPi().clientTotalBill(context:context, clientId: clientId);
    notifyListeners();
  }
}