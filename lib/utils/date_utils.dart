import 'dart:math';

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
}
