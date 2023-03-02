import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_outlined_button.dart';

class ClockingMemberItem extends StatelessWidget {
  final Attendee? absentee;
  const ClockingMemberItem({
    Key? key,
    this.absentee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var attendeeName =
        "${absentee!.additionalInfo!.memberInfo!.firstname!.isEmpty ? '' : absentee!.additionalInfo!.memberInfo!.firstname!.capitalize()} ${absentee!.additionalInfo!.memberInfo!.middlename!.isEmpty ? '' : absentee!.additionalInfo!.memberInfo!.middlename!.capitalize()} ${absentee!.additionalInfo!.memberInfo!.surname!.isEmpty ? '' : absentee!.additionalInfo!.memberInfo!.surname!.capitalize()}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: absentee!.selected! ? Colors.orange.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: absentee!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                absentee!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: absentee!.selected! ? primaryColor : Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              absentee!.additionalInfo!.memberInfo!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: absentee!
                            .additionalInfo!.memberInfo!.profilePicture!,
                        height: 60,
                      ),
                    )
                  : defaultProfilePic(height: 60),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      attendeeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${absentee!.identification}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: displayHeight(context) * 0.02,
              ),
              CustomOutlinedButton(
                label: "IN",
                mycolor: Colors.green,
                radius: 5,
                function: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      insetPadding: const EdgeInsets.all(10),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: ConfirmDialog(
                        title: 'Clock In',
                        content:
                            'Are you sure you want to clock-in on behalf of $attendeeName?',
                        onConfirmTap: () {
                          Navigator.pop(context);
                          Provider.of<ClockingProvider>(context, listen: false)
                              .clockMemberIn(
                            context: context,
                            attendee: absentee!,
                            time: null,
                          );
                        },
                        onCancelTap: () => Navigator.pop(context),
                        confirmText: 'Yes',
                        cancelText: 'Cancel',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
