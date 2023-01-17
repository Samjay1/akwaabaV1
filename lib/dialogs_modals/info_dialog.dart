import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final Function() onCancelTap;

  const InfoDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onCancelTap,
    required this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context) * 0.36,
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
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          SizedBox(height: displayHeight(context) * 0.02),

          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: 1.0,
              color: blackColor,
              fontSize: 16,
            ),
          ),

          const Spacer(),

          // action buttons
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: onCancelTap,
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
