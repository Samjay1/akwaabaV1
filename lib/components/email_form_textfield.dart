import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enableEdit;
  final String? helperText;
  final int? maxLength;
  final bool? showMaxLength;
  final String? prefixText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final IconData? iconData;
  final int? maxLines;
  final bool isCompulsory;
  final int minLines;
  final String label;
  final bool obscureText;
  final VoidCallback? suffixTapFunction;
  final bool? applyValidation;

  const EmailFormTextField(
      {required this.controller,
      this.label = "",
      this.hint = "",
      this.enableEdit = true,
      this.helperText = "",
      this.maxLength,
      this.showMaxLength,
      this.prefixText,
      this.textInputType,
      this.textInputAction,
      this.iconData,
      this.maxLines,
      this.isCompulsory = false,
      this.minLines = 1,
      this.obscureText = false,
      this.suffixTapFunction,
      this.applyValidation = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: TextFormField(
        obscureText: obscureText,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        // textCapitalization: TextCapitalization.characters,
        enabled: enableEdit,
        style: TextStyle(
          color: enableEdit ? textColorPrimary : textColorLight,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),

        decoration: InputDecoration(
          // isDense: true,
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 0.0),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 0.0),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor, width: 0.0),
              borderRadius: BorderRadius.circular(8)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: textColorLight, width: 0.0),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: minLines > 1 ? 8 : 0),
          filled: true,
          fillColor: Colors.white,
          prefixText: prefixText,
          prefixStyle: const TextStyle(color: primaryColor),
          // prefixIcon:prefixText!=null?Text("  $prefixText",style: TextStyle(color: primaryColor),) :null,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: textColorLight),
          helperText: helperText,
          helperStyle: const TextStyle(color: textColorLight),
          suffix: suffixTapFunction != null
              ? InkWell(
                  onTap: suffixTapFunction,
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    size: 19,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        controller: controller,
        inputFormatters: maxLength != null
            ? [
                LengthLimitingTextInputFormatter(maxLength),
              ]
            : null,
        maxLength: showMaxLength != null ? maxLength ?? 100 : null,
        maxLines: maxLines != null && maxLines! >= 2
            ? null
            : 1, //if more than 2 lines is given,
        // max lines is set to null so that the more you type, the text field expands further down
        minLines: minLines,
        keyboardType: textInputType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return applyValidation! ? "Enter a valid email address" : null;
          }
          return null;
        },
      ),
    );
  }
}
