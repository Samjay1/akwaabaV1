import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BackgroundLocationDialog extends StatelessWidget {
  const BackgroundLocationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Background Location',
        style: TextStyle(
          color: blackColor,
          fontWeight: FontWeight.w600,
          fontSize: AppSize.s18,
        ),
      ),
      content: Text(
        "Akwaaba collects location data to allow users to join meetings or events they are assigned to, based on the premise of the meetings, even when the app is closed or not in use. \n\nThis data is used to clock in and out of meetings and events, as well as start and end break if and only if a break is scheduled for the assigned meeting.",
        style: TextStyle(
          color: blackColor.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          fontSize: AppSize.s16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Deny',
            style: TextStyle(
                color: primaryColor.withOpacity(0.8), fontSize: AppSize.s15),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await LocationServices().getUserCurrentLocation();
          },
          child: Text(
            'Agree',
            style: TextStyle(
                color: primaryColor.withOpacity(0.8), fontSize: AppSize.s15),
          ),
        ),
      ],
    );
  }
}
