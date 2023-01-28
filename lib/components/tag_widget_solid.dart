import 'package:akwaaba/constants/app_dimens.dart';
import 'package:flutter/material.dart';

class TagWidgetSolid extends StatelessWidget {
  final Color? color;
  final String? text;
  const TagWidgetSolid({Key? key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: color!,
        borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
      ),
      child: Text(
        text!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
