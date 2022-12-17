import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../utils/dimens.dart';

class BirthdayAlertUpcomingItemWidget extends StatefulWidget {
  const BirthdayAlertUpcomingItemWidget({Key? key}) : super(key: key);

  @override
  State<BirthdayAlertUpcomingItemWidget> createState() => _BirthdayAlertUpcomingItemWidgetState();
}

class _BirthdayAlertUpcomingItemWidgetState extends State<BirthdayAlertUpcomingItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: Row(
                children: [
                  defaultProfilePic(height: 50),
                  const SizedBox(width: 8,),
                  Text("John Jane Doe"),
                ],
              )),

              Text("Aug 31",style: TextStyle(
                color: textColorLight,fontSize: 14
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
