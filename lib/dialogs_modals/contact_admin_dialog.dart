import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class ContactAdminDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String firstText;
  final String secondText;
  final Function() onCallTap;
  final Function() onWhatsappTap;
  const ContactAdminDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.firstText,
    required this.secondText,
    required this.onCallTap,
    required this.onWhatsappTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(AppPadding.p20),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.008,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          // call button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: onCallTap,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(Icons.call),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Text(
                      firstText,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              // whatsapp button
              InkWell(
                onTap: onWhatsappTap,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: greenColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.message,
                        color: greenColor,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Text(
                      secondText,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
