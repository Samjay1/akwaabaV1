import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final String? hintText;
  final Color? fillColor;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  const CustomDatePicker({
    super.key,
    required this.onSaved,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.hintText = 'Select Date',
    this.fillColor = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      initialValue: '',
      type: DateTimePickerType.date,
      dateMask: 'yyyy-MM-dd',
      firstDate: firstDate ?? DateTime(1970),
      lastDate: lastDate ?? DateTime.now(),
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
        // prefixIcon: const Icon(
        //   Icons.calendar_month_outlined,
        //   color: primaryColor,
        //   size: 20,
        // ),
        suffixIcon: Icon(
          CupertinoIcons.chevron_up_chevron_down,
          color: Colors.grey.shade500,
          size: 16,
        ),
        fillColor: fillColor,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: textColorPrimary,
          fontSize: AppSize.s15,
          fontWeight: FontWeight.w300,
        ),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
