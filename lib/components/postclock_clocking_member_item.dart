import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_outlined_button.dart';

class PostClockClockingMemberItem extends StatelessWidget {
  final MeetingEventModel? meetingEventModel;
  final Member? member;
  PostClockClockingMemberItem({Key? key, this.member, this.meetingEventModel})
      : super(key: key);

  late ClockingProvider clockingProvider;

  @override
  Widget build(BuildContext context) {
    clockingProvider = context.watch<ClockingProvider>();
    var attendeeName = "${member!.firstname!} ${member!.surname!}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: member!.selected! ? Colors.orange.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: member!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                member!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: member!.selected! ? primaryColor : Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              defaultProfilePic(height: 50),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${member!.firstname!} ${member!.surname!}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meetingEventModel!.name!,
                          style: const TextStyle(fontSize: 15),
                        ),
                        CustomOutlinedButton(
                          label: "IN",
                          mycolor: Colors.green,
                          radius: 5,
                          function: () {
                            if (clockingProvider.postClockDate == null ||
                                clockingProvider.postClockTime == null) {
                              showNormalToast(
                                'Please select date & time to clock-in $attendeeName. \nThank you!',
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
                                        'Are you sure you want to clock-in $attendeeName?',
                                    onConfirmTap: () {
                                      Navigator.pop(context);
                                      Provider.of<ClockingProvider>(context,
                                              listen: false)
                                          .clockMemberIn(
                                        context: context,
                                        member: member!,
                                        clockingId: member!.clockingId!,
                                        time: clockingProvider
                                            .getPostClockDateTime(),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
