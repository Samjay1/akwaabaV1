import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
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

class PostClockClockedMemberItem extends StatefulWidget {
  final Attendee? attendee;
  const PostClockClockedMemberItem({Key? key, this.attendee}) : super(key: key);

  @override
  State<PostClockClockedMemberItem> createState() =>
      _PostClockClockedMemberItemState();
}

class _PostClockClockedMemberItemState
    extends State<PostClockClockedMemberItem> {
  final TextEditingController startBreakcontroller = TextEditingController();
  final TextEditingController endBreakcontroller = TextEditingController();

  DateTime? _selectedTime;
  DateTime now = DateTime.now();

  late ClockingProvider clockingProvider;

  @override
  Widget build(BuildContext context) {
    clockingProvider = context.watch<ClockingProvider>();
    var inTime = DateUtil.formatStringDate(DateFormat.jm(),
        date: DateTime.parse(widget.attendee!.attendance!.inTime!));

    var outTime = 'N/A';
    if (widget.attendee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
          date: DateTime.parse(widget.attendee!.attendance!.outTime!));
    }

    var attendeeName =
        "${widget.attendee!.additionalInfo!.memberInfo!.firstname!} ${widget.attendee!.additionalInfo!.memberInfo!.surname!}";

    var clockingId = widget.attendee!.attendance!.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: widget.attendee!.additionalInfo!.memberInfo!.selected!
            ? Colors.orange.shade100
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation:
            widget.attendee!.additionalInfo!.memberInfo!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                widget.attendee!.additionalInfo!.memberInfo!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: widget.attendee!.additionalInfo!.memberInfo!.selected!
                    ? primaryColor
                    : Colors.grey,
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
                      attendeeName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.003,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.attendee!.attendance!.meetingEventId!.name!,
                          style: const TextStyle(
                              fontSize: 16, color: primaryColor),
                        ),
                        widget.attendee!.attendance!.outTime == null
                            ? CustomOutlinedButton(
                                label: "OUT",
                                mycolor: Colors.red,
                                radius: 5,
                                function: () {
                                  if (widget.attendee!.attendance!.outTime !=
                                      null) {
                                    showNormalToast(
                                        '$attendeeName has already been clocked out. Thank you!');
                                  } else if (clockingProvider.postClockDate ==
                                          null ||
                                      clockingProvider.postClockTime == null) {
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
                                              clockingId: clockingId!,
                                              time: clockingProvider
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
                      height:
                          (widget.attendee!.attendance!.startBreak == null &&
                                  widget.attendee!.attendance!.endBreak == null)
                              ? displayHeight(context) * 0.01
                              : displayHeight(context) * 0.00,
                    ),
                    widget.attendee!.attendance!.meetingEventId!
                                .hasBreakTime! &&
                            widget.attendee!.attendance!.outTime == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.attendee!.attendance!.startBreak == null
                                  ? CustomElevatedButton(
                                      label: "Start Break",
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      radius: 5,
                                      function: () {
                                        if (widget.attendee!.attendance!
                                                .startBreak !=
                                            null) {
                                          showNormalToast(
                                              '$attendeeName has already started break. Thank you!');
                                        } else if (clockingProvider
                                                    .postClockDate ==
                                                null ||
                                            clockingProvider.postClockTime ==
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
                                                    clockingId: clockingId!,
                                                    time: clockingProvider
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
                              widget.attendee!.attendance!.endBreak == null
                                  ? CustomElevatedButton(
                                      label: "End Break",
                                      color: Colors.red,
                                      radius: 5,
                                      function: () {
                                        if (widget.attendee!.attendance!
                                                .endBreak !=
                                            null) {
                                          showNormalToast(
                                              '$attendeeName has already ended break. Thank you!');
                                        } else if (widget.attendee!.attendance!
                                                .startBreak ==
                                            null) {
                                          showNormalToast(
                                              'You can\'t end a break that has not been started. Please start the break to continue!');
                                        } else if (clockingProvider
                                                    .postClockDate ==
                                                null ||
                                            clockingProvider.postClockTime ==
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
                                                  Provider.of<ClockingProvider>(
                                                          context,
                                                          listen: false)
                                                      .endMeetingBreak(
                                                    context: context,
                                                    clockingId: clockingId!,
                                                    time: clockingProvider
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
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
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
