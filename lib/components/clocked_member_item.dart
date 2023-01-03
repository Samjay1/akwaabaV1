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

class ClockedMemberItem extends StatefulWidget {
  final Attendee? attendee;
  const ClockedMemberItem({Key? key, this.attendee}) : super(key: key);

  @override
  State<ClockedMemberItem> createState() => _ClockedMemberItemState();
}

class _ClockedMemberItemState extends State<ClockedMemberItem> {
  final TextEditingController startBreakcontroller = TextEditingController();
  final TextEditingController endBreakcontroller = TextEditingController();

  DateTime? _selectedTime;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                      height: displayHeight(context) * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.attendee!.attendance!.meetingEventId!.name!,
                          style: const TextStyle(
                              fontSize: 16, color: primaryColor),
                        ),
                        CustomOutlinedButton(
                          label: "OUT",
                          mycolor: Colors.red,
                          radius: 5,
                          function: () {
                            if (widget.attendee!.attendance!.outTime != null) {
                              showNormalToast(
                                  '$attendeeName has already been clocked out. Thank you!');
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
                                      Provider.of<ClockingProvider>(context,
                                              listen: false)
                                          .clockMemberOut(
                                        context: context,
                                        clockingId: clockingId!,
                                        time: null,
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
                    SizedBox(
                      height: displayHeight(context) * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('IN : $inTime'), Text('OUT :  $outTime')],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    widget.attendee!.attendance!.meetingEventId!
                                .hasBreakTime! &&
                            widget.attendee!.attendance!.outTime == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomElevatedButton(
                                label: "Start Break",
                                color: Colors.green,
                                textColor: Colors.white,
                                radius: 5,
                                function: () {
                                  if (widget.attendee!.attendance!.startBreak !=
                                      null) {
                                    showNormalToast(
                                        '$attendeeName has already started break. Thank you!');
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
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
                                  }
                                },
                              ),
                              CustomElevatedButton(
                                label: "End Break",
                                color: Colors.red,
                                radius: 5,
                                function: () {
                                  if (widget.attendee!.attendance!.endBreak !=
                                      null) {
                                    showNormalToast(
                                        '$attendeeName has already ended break. Thank you!');
                                  } else if (widget
                                          .attendee!.attendance!.startBreak ==
                                      null) {
                                    showNormalToast(
                                        'You can\'t end a break that has not been started. Please start the break to continue!');
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
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
                                  }
                                  // displayTimeSelector(
                                  //         initialDate:
                                  //             _selectedTime ?? DateTime.now(),
                                  //         context: context)
                                  //     .then((value) {
                                  //   if (value != null) {
                                  //     setState(() {
                                  //       _selectedTime = value;
                                  //       print("DateTime: " +
                                  //           _selectedTime!
                                  //               .toIso8601String()
                                  //               .substring(0, 19));
                                  //     });
                                  //   }
                                  // }).whenComplete(
                                  //   () => {
                                  //     showModalBottomSheet(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return FractionallySizedBox(
                                  //               heightFactor: 0.4,
                                  //               child: Column(
                                  //                 children: [
                                  //                   const SizedBox(
                                  //                     height: 20,
                                  //                   ),
                                  //                   Container(
                                  //                     padding:
                                  //                         const EdgeInsets.symmetric(
                                  //                             vertical: 10,
                                  //                             horizontal: 10),
                                  //                     decoration: BoxDecoration(
                                  //                         color: Colors.orange,
                                  //                         borderRadius:
                                  //                             BorderRadius.circular(
                                  //                                 5)),
                                  //                     child: Text(
                                  //                       'Time ${DateFormat.jm().format(_selectedTime!)}',
                                  //                       style: const TextStyle(
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                           fontSize: 21),
                                  //                     ),
                                  //                   ),
                                  //                   const SizedBox(
                                  //                     height: 20,
                                  //                   ),
                                  //                   Row(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .spaceEvenly,
                                  //                     children: [
                                  //                       CustomElevatedButton(
                                  //                           label: "Cancel",
                                  //                           color: Colors.red,
                                  //                           radius: 5,
                                  //                           function: () {
                                  //                             Navigator.pop(context);
                                  //                           }),
                                  //                       CustomElevatedButton(
                                  //                           label: "Set Time",
                                  //                           color: Colors.green,
                                  //                           radius: 5,
                                  //                           function: () {
                                  //                             ScaffoldMessenger.of(
                                  //                                     context)
                                  //                                 .showSnackBar(
                                  //                                     const SnackBar(
                                  //                                         content: Text(
                                  //                                             'Time has been Set')));
                                  //                             Navigator.pop(context);
                                  //                           })
                                  //                     ],
                                  //                   ),
                                  //                 ],
                                  //               ));
                                  //         })
                                  //   },
                                  // );
                                },
                              ),
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
