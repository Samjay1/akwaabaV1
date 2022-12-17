import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback function;
  final String label;
  final double radius;

  const CustomOutlinedButton({
    required this.label,
    required this.function,
    this.radius = defaultRadius,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 1.0, color: primaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)
            ),
        ),
        onPressed: function,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label,style: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.w400 ,
          color: primaryColor),),
        ));
  }
}
