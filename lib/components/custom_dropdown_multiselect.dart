import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multiselect/multiselect.dart';

class CustomMultiselectDropDown extends StatelessWidget {
  // String? selectedItem;
  final String hinText;
  final List<String> selectedItems;
  final List<String> itemList;
  final Function(List<String>) onChanged;

  const CustomMultiselectDropDown({
    super.key,
    // this.selectedItem = '',
    required this.selectedItems,
    required this.itemList,
    required this.onChanged,
    required this.hinText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
        border: Border.all(width: 0.4, color: Colors.grey.shade400),
      ),
      child: DropDownMultiSelect(
        options: itemList,
        selectedValues: selectedItems,
        whenEmpty: hinText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          fillColor: Colors.white,
          //filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
            borderSide: const BorderSide(width: 0.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
            borderSide: const BorderSide(width: 0.0, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
            borderSide: const BorderSide(width: 0.0, color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
            borderSide: const BorderSide(width: 0.0, color: Colors.white),
          ),
        ),
        icon: Icon(
          CupertinoIcons.chevron_up_chevron_down,
          color: Colors.grey.shade500,
          size: 16,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
