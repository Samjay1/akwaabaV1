import 'dart:io';

import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/dialogs_modals/info_dialog.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_theme.dart';

/*
Includes codes to show custom views and widgets like:
 Snack bars
 toasts
 dialogs
 date selectors
 drop downs etc...
 */
displayCustomCupertinoDialog(
    {required BuildContext context,
    required String title,
    required String msg,
    required Map<String, VoidCallback> actionsMap}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          for (var i in actionsMap.entries)
            CupertinoDialogAction(
              onPressed: i.value,
              child: Text(i.key),
            )
        ],
      );
    },
  );
}

Future displayCustomDropDown({
  required List options,
  required BuildContext context,
  var title,
  var message,
  bool showCancel = true,
  bool listItemsIsMap = true,
  var initialValue,
  var customActions,
}) async {
  var selectedOption;

  await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
            title: title != null
                ? Text(
                    "$title",
                    style: const TextStyle(fontSize: 18),
                  )
                : null,
            message: message != null ? Text("$message") : null,
            actions: customActions ??
                options
                    .map((e) => CupertinoActionSheetAction(
                        onPressed: () {
                          selectedOption = e;
                          Navigator.pop(context, e);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            listItemsIsMap ? "${e.values.elementAt(0)}" : "$e",
                            style: TextStyle(color: Colors.black),
                          ),
                        )))
                    .toList(),
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () {
                selectedOption = initialValue;
                Navigator.pop(context, selectedOption);
              },
            ),
          ));
  return selectedOption;
}

Future<void> displayCustomDialog(
    BuildContext context, Widget childWidget) async {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: childWidget,
        );
      });
}

Future<DateTime?> displayDateSelector({
  required DateTime initialDate,
  required BuildContext context,
  DateTime? minimumDate,
  DateTime? maxDate,
}) async {
  DateTime? selectedDate;

  await DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: minimumDate,
    maxTime: maxDate,
    onCancel: () {
      selectedDate = initialDate;
    },
    currentTime: initialDate,
    onChanged: (date) {
      selectedDate = date;
    },
    onConfirm: (date) {
      selectedDate ??= initialDate;
    },
    locale: LocaleType.en,
  );

  return selectedDate;
}

Future<DateTime?> displayTimeSelector(
    {required DateTime initialDate,
    required BuildContext context,
    DateTime? minimumDate,
    DateTime? maxDate}) async {
  DateTime? selectedDate;
  await DatePicker.showTime12hPicker(
    context,
    showTitleActions: true,

    // minTime:minimumDate,
    //
    // maxTime: maxDate,
    onCancel: () {
      selectedDate = initialDate;
    },
    currentTime: initialDate,
    onChanged: (date) {
      selectedDate = date;
    },
    onConfirm: (date) {
      selectedDate ??= initialDate;
    },
    locale: LocaleType.en,
  );

  return selectedDate;
}

showLoadingDialog(BuildContext context, [String? message]) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(
                        radius: 20,
                      ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                Text(
                  message ?? 'Please wait a moment...',
                  style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

showInfoDialog(
  String? cancelText, {
  required BuildContext context,
  required String title,
  required String content,
  required Function() onTap,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: InfoDialog(
        title: title,
        content: content,
        onCancelTap: onTap,
        cancelText: cancelText ?? 'ok',
      ),
    ),
  );
}

void showNormalSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(message),
      duration: const Duration(milliseconds: 3000),
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 3000),
    ),
  );
}

void showNormalToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showErrorToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget defaultProfilePic({required double height}) {
  return SvgPicture.asset(
    "images/illustrations/profile_pic.svg",
    height: height,
  );
}
