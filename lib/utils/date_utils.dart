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

  static Future<DateTime?> selectDate({
    required BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: firstDate ?? DateTime(1970),
      lastDate: lastDate ?? DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return selectedDate;
  }

  static Future<TimeOfDay?> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime;
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (timePicked != null && timePicked != selectedTime) {
      //selectedTime = timePicked.replacing(hour: timePicked.hourOfPeriod);
      selectedTime = timePicked;
    }
    return selectedTime;
  }

  static String convertTimeOfDayTo12hour(
      {required TimeOfDay timeOfDay,
      required BuildContext context,
      required showAMPM}) {
    if (showAMPM) {
      return '${timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute} ${timeOfDay.period.name.toUpperCase()}';
    } else {
      return '${timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}';
    }
  }

  // static String convertTimeOfDayTo12hour(
  //     {required TimeOfDay timeOfDay, required bool showAMPM}) {
  //   if (showAMPM) {
  //     debugPrint(timeOfDay.period.name);
  //     return '${timeOfDay.hour}:${timeOfDay.minute < 9 ? '0${timeOfDay.minute}' : '${timeOfDay.minute}'} ${timeOfDay.period.name.toUpperCase()}';
  //   } else {
  //     return '${timeOfDay.hour}:${timeOfDay.minute < 9 ? '0${timeOfDay.minute}' : '${timeOfDay.minute}'}';
  //   }
  // }

  // format date
  static String formatStringDate(DateFormat dateFormat,
      {required DateTime date}) {
    final formattedDate = dateFormat.format(date);
    return formattedDate.toString();
  }

  // convert invalid dateformat to datetime
  static DateTime convertToDateTime({required String date}) {
    debugPrint("Date: $date");
    var splitted = date.split("-");
    if (splitted[0].length == 2) {
      return DateFormat('dd-MM-yyyy').parse(date);
    } else if (splitted[0].length == 4) {
      return DateFormat('yyyy-MM-dd').parse(date);
    } else {
      return DateTime.parse(date);
    }
  }

  // format start and close time to human readable form
  static String formate12hourTime({required String myTime}) {
    var hour = int.parse(myTime.substring(0, 2));
    final min = int.parse(myTime.substring(3, 5));
    final sec = int.parse(myTime.substring(6, 8));
    final time = DateTime(0, 0, 0, hour, min, sec, 0, 0);
    return DateFormat.jm().format(time);
  }

  // format start and close time to human readable form
  static DateTime convertTimeToDatetime({required String myTime}) {
    var hour = int.parse(myTime.substring(0, 2));
    final min = int.parse(myTime.substring(3, 5));
    final sec = int.parse(myTime.substring(6, 8));
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      min,
      sec,
      DateTime.now().millisecond,
      DateTime.now().microsecond,
    );
  }

  static String getTimeStringFromDouble(double value) {
    //if (value < 0) return 'Invalid Value';
    if (value < 0) value = double.parse(value.toString().substring(1));
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);
    return '$hourValue:$minuteString';
  }

  static String getHourStringFromDouble(double value) {
    //if (value < 0) return 'Invalid Value';
    String hourValue = '';
    if (value < 0) {
      value = double.parse(value.toString().substring(1));
      hourValue = getHourString(value.floor());
    } else {
      int flooredValue = value.floor();
      hourValue = getHourString(flooredValue);
    }
    return hourValue;
  }

  static String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  static String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(flooredValue > 9 ? 2 : 1, '0');
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

  static String convertToFutureTimeAgo({required DateTime date}) {
    Duration diff = date.difference(DateTime.now());

    if (diff.inDays == 1) {
      return '${diff.inDays} Day';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} Days';
    } else if (diff.inHours == 1) {
      return '${diff.inHours} Hour';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} Hours';
    } else if (diff.inMinutes == 1) {
      return '${diff.inMinutes} Minute';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} Minutes';
    } else if (diff.inSeconds == 1) {
      return '${diff.inSeconds} Seconds';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} Seconds';
    } else {
      return 'just now';
    }
  }
}
