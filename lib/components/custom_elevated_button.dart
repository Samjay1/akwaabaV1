import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import 'custom_progress_indicator.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback function;
  final String label;
  final bool showProgress;
  final Color color;
  final double labelSize;
  final Color textColor;
  final double radius;

  const CustomElevatedButton(
      {required this.label,
      required this.function,
      this.showProgress = false,
      this.color = primaryColor,
      this.radius = defaultRadius,
      this.textColor = Colors.black,
      this.labelSize = 18,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showProgress,
      replacement: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0.5,
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          onPressed: function,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              style: TextStyle(fontSize: labelSize, color: textColor),
            ),
          )),
      child: const CustomProgressIndicator(),
    );
  }
}
