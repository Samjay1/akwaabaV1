import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/post_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_outlined_button.dart';

class PostClockClockingMemberItem extends StatelessWidget {
  final Attendee? attendee;
  PostClockClockingMemberItem({
    Key? key,
    this.attendee,
  }) : super(key: key);

  late PostClockingProvider postClockingProvider;

  @override
  Widget build(BuildContext context) {
    postClockingProvider = context.watch<PostClockingProvider>();
    var attendeeName =
        "${attendee!.attendance!.memberId!.firstname!} ${attendee!.attendance!.memberId!.surname!}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: attendee!.selected! ? Colors.orange.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: attendee!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                attendee!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: attendee!.selected! ? primaryColor : Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              attendee!.additionalInfo!.memberInfo!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: attendee!
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
                      height: displayHeight(context) * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${attendee!.identification}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomOutlinedButton(
                label: "IN",
                mycolor: Colors.green,
                radius: 5,
                function: () {
                  if (postClockingProvider.selectedDate == null ||
                      postClockingProvider.postClockTime == null) {
                    showInfoDialog(
                      'ok',
                      context: context,
                      title: 'Sorry!',
                      content:
                          'Please select the time to clock-in on behalf of $attendeeName. \nThank you!',
                      onTap: () => Navigator.pop(context),
                    );
                  } else {
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
                            postClockingProvider.clockMemberIn(
                              context: context,
                              attendee: attendee,
                              time: postClockingProvider.getPostClockDateTime(),
                            );
                          },
                          onCancelTap: () => Navigator.pop(context),
                          confirmText: 'Yes',
                          cancelText: 'Cancel',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
