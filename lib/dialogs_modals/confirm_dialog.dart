import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Function() onConfirmTap;
  final Function() onCancelTap;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirmTap,
    required this.onCancelTap,
    required this.confirmText,
    required this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: content.isEmpty
          ? displayHeight(context) * 0.20
          : displayHeight(context) * 0.35,
      width: displayWidth(context),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: displayHeight(context) * 0.02),
          // dialog title
          Align(
            alignment: content.isEmpty ? Alignment.topLeft : Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          SizedBox(height: displayHeight(context) * 0.03),

          content.isEmpty
              ? const SizedBox()
              : Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: blackColor, fontSize: 16),
                ),

          content.isEmpty ? const SizedBox() : const Spacer(),

          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onConfirmTap,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: displaySize(context).width * 0.34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryColor,
                  ),
                  child: Center(
                      child: Text(
                    confirmText,
                    style: const TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  )),
                ),
              ),

              // SizedBox(width: 20,),
              // cancel button
              GestureDetector(
                onTap: onCancelTap,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: displaySize(context).width * 0.34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: fillColor,
                  ),
                  child: Center(
                      child: Text(
                    cancelText,
                    style: TextStyle(
                        color: blackColor.withOpacity(0.8), fontSize: 14),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
