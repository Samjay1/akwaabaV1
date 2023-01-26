import 'package:akwaaba/Networks/profile_api.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  // List<Subscription>? clientSubscription;

  // checks if account is active or has expired
  bool isActive(String date) {
    var currentDate = DateTime.now();
    var expiryDate = DateTime.parse(date);
    return expiryDate.isAfter(currentDate) ? true : false;
  }
}
