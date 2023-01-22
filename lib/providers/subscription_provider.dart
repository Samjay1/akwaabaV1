import 'package:akwaaba/Networks/auth_api.dart';
import 'package:akwaaba/Networks/subscription_api.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:akwaaba/models/subscription/subscription.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  // List<Subscription>? clientSubscription;

  // Future<void> getClientSubscriptionInfo() async {
  //   try {
  //     clientSubscription =
  //         await SubscriptionAPI.getClientCurrentSubscriptions();
  //     debugPrint('Subscription: ${clientSubscription!.length}');
  //   } catch (err) {
  //     debugPrint('Error MC: ${err.toString()}');
  //     showErrorToast(err.toString());
  //   }
  //   notifyListeners();
  // }

  // checks if account is active or has expired
  bool isActive(String date) {
    var currentDate = DateTime.now();
    var expiryDate = DateTime.parse(date);
    return expiryDate.isAfter(currentDate) ? true : false;
  }
}
