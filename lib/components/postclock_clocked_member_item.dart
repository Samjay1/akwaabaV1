import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/post_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_elevated_button.dart';
import 'custom_outlined_button.dart';

class PostClockClockedMemberItem extends StatelessWidget {
  final Attendee? attendee;
  PostClockClockedMemberItem({Key? key, this.attendee}) : super(key: key);

  late PostClockingProvider postClockingProvider;

  @override
  Widget build(BuildContext context) {
    postClockingProvider = context.watch<PostClockingProvider>();
    var inTime = 'N/A';
    if (attendee!.attendance!.inTime != null) {
      inTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.inTime!))
          .toLowerCase();
    }

    var outTime = 'N/A';
    if (attendee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
          date: DateTime.parse(attendee!.attendance!.outTime!));
    }

    var startBreakTime = 'N/A';
    if (attendee!.attendance!.startBreak != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.startBreak!))
          .toLowerCase();
    }

    var endBreakTime = 'N/A';
    if (attendee!.attendance!.endBreak != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.endBreak!))
          .toLowerCase();
    }

    var attendeeName =
        "${attendee!.additionalInfo!.memberInfo!.firstname!} ${attendee!.additionalInfo!.memberInfo!.surname!}";

    var clockingId = attendee!.attendance!.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: attendee!.additionalInfo!.memberInfo!.selected!
            ? Colors.orange.shade100
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: attendee!.additionalInfo!.memberInfo!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                attendee!.additionalInfo!.memberInfo!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: attendee!.additionalInfo!.memberInfo!.selected!
                    ? primaryColor
                    : Colors.grey,
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
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Text(
                      attendeeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.003,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${attendee!.attendance!.memberId!.id!.toString()}',
                          style: const TextStyle(
                              fontSize: 16, color: primaryColor),
                        ),
                        attendee!.attendance!.outTime == null
                            ? CustomOutlinedButton(
                                label: "OUT",
                                mycolor: Colors.red,
                                radius: 5,
                                function: () {
                                  if (attendee!.attendance!.outTime != null) {
                                    showNormalToast(
                                        '$attendeeName has already been clocked out. Thank you!');
                                  } else if (postClockingProvider
                                              .postClockDate ==
                                          null ||
                                      postClockingProvider.postClockTime ==
                                          null) {
                                    showNormalToast(
                                      'Please select date & time to clocked out $attendeeName. Thank you!',
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: ConfirmDialog(
                                          title: 'Clock Out',
                                          content:
                                              'Are you sure you want to clock-out $attendeeName?',
                                          onConfirmTap: () {
                                            Navigator.pop(context);
                                            Provider.of<ClockingProvider>(
                                                    context,
                                                    listen: false)
                                                .clockMemberOut(
                                              context: context,
                                              attendee: attendee,
                                              time: postClockingProvider
                                                  .getPostClockDateTime(),
                                            );
                                          },
                                          onCancelTap: () =>
                                              Navigator.pop(context),
                                          confirmText: 'Yes',
                                          cancelText: 'Cancel',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.003,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('IN : $inTime'), Text('OUT :  $outTime')],
                    ),
                    SizedBox(
                      height: (attendee!.attendance!.startBreak == null &&
                              attendee!.attendance!.endBreak == null)
                          ? displayHeight(context) * 0.006
                          : displayHeight(context) * 0.00,
                    ),
                    attendee!.attendance!.meetingEventId!.hasBreakTime! &&
                            attendee!.attendance!.outTime == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              attendee!.attendance!.startBreak == null
                                  ? Column(
                                      children: [
                                        CustomElevatedButton(
                                          label: "Start Break",
                                          color: Colors.green,
                                          labelSize: 14,
                                          textColor: Colors.white,
                                          radius: 5,
                                          function: () {
                                            if (attendee!
                                                    .attendance!.startBreak !=
                                                null) {
                                              showNormalToast(
                                                  '$attendeeName has already started break. Thank you!');
                                            } else if (postClockingProvider
                                                        .postClockDate ==
                                                    null ||
                                                postClockingProvider
                                                        .postClockTime ==
                                                    null) {
                                              showNormalToast(
                                                'Please select date & time to start break for $attendeeName. Thank you!',
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  insetPadding:
                                                      const EdgeInsets.all(10),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  content: ConfirmDialog(
                                                    title: 'Start Break',
                                                    content:
                                                        'Are you sure you want start break for $attendeeName?',
                                                    onConfirmTap: () {
                                                      Navigator.pop(context);
                                                      Provider.of<ClockingProvider>(
                                                              context,
                                                              listen: false)
                                                          .startMeetingBreak(
                                                        context: context,
                                                        attendee: attendee,
                                                        time: postClockingProvider
                                                            .getPostClockDateTime(),
                                                      );
                                                    },
                                                    onCancelTap: () =>
                                                        Navigator.pop(context),
                                                    confirmText: 'Yes',
                                                    cancelText: 'Cancel',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height:
                                              displayHeight(context) * 0.006,
                                        ),
                                        Text(
                                          'SB: $startBreakTime',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: blackColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                width: displayWidth(context) * 0.02,
                              ),
                              attendee!.attendance!.endBreak == null
                                  ? Column(
                                      children: [
                                        CustomElevatedButton(
                                          label: "End Break",
                                          labelSize: 14,
                                          color: Colors.red,
                                          radius: 5,
                                          function: () {
                                            if (attendee!
                                                    .attendance!.endBreak !=
                                                null) {
                                              showNormalToast(
                                                  '$attendeeName has already ended break. Thank you!');
                                            } else if (attendee!
                                                    .attendance!.startBreak ==
                                                null) {
                                              showNormalToast(
                                                  'You can\'t end a break that has not been started. Please start the break to continue!');
                                            } else if (postClockingProvider
                                                        .postClockDate ==
                                                    null ||
                                                postClockingProvider
                                                        .postClockTime ==
                                                    null) {
                                              showNormalToast(
                                                'Please select date & time to end break for $attendeeName. Thank you!',
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  insetPadding:
                                                      const EdgeInsets.all(10),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  content: ConfirmDialog(
                                                    title: 'End Break',
                                                    content:
                                                        'Are you sure you want end break for $attendeeName?',
                                                    onConfirmTap: () {
                                                      Navigator.pop(context);
                                                      Provider.of<PostClockingProvider>(
                                                              context,
                                                              listen: false)
                                                          .endMeetingBreak(
                                                        context: context,
                                                        attendee: attendee,
                                                        time: postClockingProvider
                                                            .getPostClockDateTime(),
                                                      );
                                                    },
                                                    onCancelTap: () =>
                                                        Navigator.pop(context),
                                                    confirmText: 'Yes',
                                                    cancelText: 'Cancel',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height:
                                              displayHeight(context) * 0.006,
                                        ),
                                        Text(
                                          'EB: $endBreakTime',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: displayHeight(context) * 0.003,
                    ),
                    Consumer<ClientProvider>(
                      builder: (context, data, child) {
                        return (data.getUser.branchID ==
                                    AppConstants.mainAdmin &&
                                outTime == AppConstants.notApplicable)
                            ? CustomElevatedButton(
                                label: "Cancel Clocking",
                                labelSize: 14,
                                color: Colors.grey,
                                textColor: whiteColor,
                                radius: 5,
                                function: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      insetPadding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: ConfirmDialog(
                                        title: 'Cancel Clocking',
                                        content:
                                            'Are you sure you want cancel clocking for $attendeeName?',
                                        onConfirmTap: () {
                                          Navigator.pop(context);
                                          Provider.of<ClockingProvider>(context,
                                                  listen: false)
                                              .cancelClocking(
                                            context: context,
                                            attendee: attendee!,
                                            time: null,
                                          );
                                        },
                                        onCancelTap: () =>
                                            Navigator.pop(context),
                                        confirmText: 'Yes',
                                        cancelText: 'Cancel',
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox();
                      },
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.007,
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
