import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';

class EventShimmerItem extends StatelessWidget {
  const EventShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(AppRadius.borderRadius13),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:
                          BorderRadius.circular(AppRadius.borderRadius16),
                    ),
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * 0.04,
                ),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:
                          BorderRadius.circular(AppRadius.borderRadius16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.borderRadius16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * 0.03,
                ),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.borderRadius16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.borderRadius16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * 0.02,
                ),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                        AppRadius.borderRadius16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
