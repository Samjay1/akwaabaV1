import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class ProfileShimmerItem extends StatelessWidget {
  const ProfileShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor,
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Container(
            width: 200,
            height: 18,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.borderRadius16),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          Container(
            width: 200,
            height: 18,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.borderRadius16),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
        ],
      ),
    );
  }
}
