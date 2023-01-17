import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {
  // format date
  static String formatDate(String? format, {required DateTime dateTime}) {
    final formattedDate = DateFormat(format ?? 'yyyy-MM-dd').parse(
      dateTime.toIso8601String(),
    );
    return formattedDate.toString();
  }

  // format date
  static String formatStringDate(DateFormat dateFormat,
      {required DateTime date}) {
    final formattedDate = dateFormat.format(date);
    return formattedDate.toString();
  }

  // format start and close time to human readable form
  static String formate12hourTime({required String myTime}) {
    var hour = int.parse(myTime.substring(0, 2));
    final min = int.parse(myTime.substring(3, 5));
    final sec = int.parse(myTime.substring(6, 8));
    final time = DateTime(0, 0, 0, hour, min, sec, 0, 0);
    return DateFormat.jm().format(time);
  }

  static String convertToAgo({required DateTime date}) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays == 1) {
      return '${diff.inDays} day ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours == 1) {
      return '${diff.inHours} hour ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes == 1) {
      return '${diff.inMinutes} minute ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds == 1) {
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
