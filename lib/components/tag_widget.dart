import 'package:akwaaba/constants/app_dimens.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  const TagWidget({Key? key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: color!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.borderRadius8),
      ),
      child: Text(
        text!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}
