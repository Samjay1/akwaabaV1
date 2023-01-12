import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class CustomTabWidget extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabTitles;
  final List<Function()> onTaps;
  const CustomTabWidget(
      {super.key,
      required this.selectedIndex,
      required this.tabTitles,
      required this.onTaps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: onTaps[0],
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: selectedIndex == 0 ? primaryColor : Colors.transparent,
                  border: Border.all(color: primaryColor, width: 1.2),
                  borderRadius: BorderRadius.circular(AppRadius.borderRadius8)),
              child: Center(
                child: Text(
                  tabTitles[0],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 0 ? whiteColor : primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: displayWidth(context) * 0.03,
        ),
        Expanded(
          child: InkWell(
            onTap: onTaps[1],
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: selectedIndex == 1 ? primaryColor : Colors.transparent,
                  border: Border.all(color: primaryColor, width: 1.2),
                  borderRadius: BorderRadius.circular(AppRadius.borderRadius8)),
              child: Center(
                child: Text(
                  tabTitles[1],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 1 ? whiteColor : primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
