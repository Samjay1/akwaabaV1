import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDropDownButton extends StatelessWidget {
  final String label;
  final String hint;
  final dynamic type;
  dynamic value;
  final List items;
  CustomDropDownButton({
    super.key,
    required this.label,
    required this.hint,
    required this.type,
    this.value,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return LabelWidgetContainer(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.0, color: Colors.grey.shade400),
        ),
        child: DropdownButtonFormField<dynamic>(
          isExpanded: true,
          style: const TextStyle(
            color: textColorPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          hint: Text(hint),
          decoration: const InputDecoration(border: InputBorder.none),
          value: value,
          icon: Icon(
            CupertinoIcons.chevron_up_chevron_down,
            color: Colors.grey.shade500,
            size: 16,
          ),
          // Array list of items
          items: items.map((dynamic value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.name!),
            );
          }).toList(),
          onChanged: (val) {
            value = val;
          },
        ),
      ),
    );
  }
}
