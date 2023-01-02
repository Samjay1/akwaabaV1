import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_theme.dart';

class BottomBorderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final IconData? iconData;
  final int maxLen;
  final int maxLines;
  final int minLines;
  final bool showMaxLenCount;
  final bool obscure;
  final VoidCallback? suffixTapFunction;
  final Color textColor;

  const BottomBorderTextField(
      {required this.controller,
      required this.label,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.iconData,
      this.minLines = 1,
      this.maxLines = 1,
      this.maxLen = 256,
      this.showMaxLenCount = false,
      this.obscure = false,
      this.suffixTapFunction,
      this.textColor = textColorPrimary,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      maxLines: maxLines,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLen),
      ],
      maxLength: showMaxLenCount ? maxLen : null,
      minLines: minLines,
      obscureText: obscure,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter  ${label.toLowerCase()}";
        } else {}
      },
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: textColor),
        labelText: label,
        border: InputBorder.none,
        icon: iconData != null
            ? Icon(
                iconData,
                color: primaryColor,
                size: 22,
              )
            : null,
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600, width: 0.0)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 0.5)),
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.5)),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
        suffix: suffixTapFunction != null
            ? InkWell(
                onTap: suffixTapFunction,
                child: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  size: 19,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }
}
