import 'package:akwaaba/utils/app_theme.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final String? hintText;
  final Color? fillColor;
  final Color? textColor;

  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  const CustomTimePicker({
    super.key,
    required this.onSaved,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.hintText = 'Select Time',
    this.fillColor = whiteColor,
    this.textColor = textColorPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      initialValue: '',
      type: DateTimePickerType.time,
      dateMask: 'hh:mm a',
      firstDate: firstDate ?? DateTime(1970),
      lastDate: lastDate ?? DateTime.now(),
      use24HourFormat: false,
      locale: const Locale('en', 'US'),
      style: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        //border: InputBorder(borderSide:  BorderSide(width: 0.0, color: Colors.grey.shade400),)
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 0.0, color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 0.0, color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 0.0, color: Colors.grey.shade400),
        ),
        prefixIcon: Icon(
          Icons.access_time,
          color: textColor,
          size: 24,
        ),
        suffixIcon: Icon(
          CupertinoIcons.chevron_up_chevron_down,
          color: textColor,
          size: 16,
        ),
        fillColor: fillColor,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
