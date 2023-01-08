import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class TextShimmerItem extends StatelessWidget {
  const TextShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(AppDimen.borderRadius16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
