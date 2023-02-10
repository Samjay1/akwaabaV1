import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/self_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_elevated_button.dart';
import 'custom_outlined_button.dart';

class SelfClockingMemberItem extends StatelessWidget {
  final Attendee? absentee;
  SelfClockingMemberItem({
    Key? key,
    this.absentee,
  }) : super(key: key);

  late SelfClockingProvider _clockingProvider;

  @override
  Widget build(BuildContext context) {
    var attendeeName =
        "${absentee!.attendance!.memberId!.firstname!.capitalize()} ${absentee!.attendance!.memberId!.middlename!.isEmpty ? '' : absentee!.attendance!.memberId!.middlename!.capitalize()} ${absentee!.attendance!.memberId!.surname!.capitalize()}";
    _clockingProvider = context.watch<SelfClockingProvider>();

    var inTime = 'N/A';
    if (absentee!.attendance!.inTime != null) {
      inTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.inTime!))
          .toLowerCase();
    }

    var outTime = 'N/A';
    if (absentee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.outTime!))
          .toLowerCase();
    }

    var startTime = DateUtil.convertTimeToDatetime(
        myTime: absentee!.attendance!.meetingEventId!.startTime!);
    var closeTime = DateUtil.convertTimeToDatetime(
        myTime: absentee!.attendance!.meetingEventId!.closeTime!);

    var currentTime = DateTime.now();

    var startBreakTime = 'N/A';
    if (absentee!.attendance!.startBreak != null) {
      startBreakTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.startBreak!))
          .toLowerCase();
    }

    var endBreakTime = 'N/A';
    if (absentee!.attendance!.endBreak != null) {
      endBreakTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.endBreak!))
          .toLowerCase();
    }

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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            attendeeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CustomOutlinedButton(
                          label: absentee!.attendance!.inTime == null
                              ? "IN"
                              : "OUT",
                          mycolor: absentee!.attendance!.inTime == null
                              ? Colors.green
                              : redColor,
                          radius: 5,
                          function: () {
                            if (currentTime.isAtSameMomentAs(startTime) ||
                                currentTime.isAfter(startTime)) {
                              debugPrint("Meeting time is up");
                              if (absentee!.attendance!.outTime != null) {
                                showInfoDialog(
                                  'ok',
                                  context: context,
                                  title: 'Hey there!',
                                  content:
                                      'You have already clocked out. \nGood Bye!',
                                  onTap: () => Navigator.pop(context),
                                );
                              } else {
                                if ((!currentTime.isAtSameMomentAs(closeTime) &&
                                        absentee!.attendance!.meetingEventId!
                                            .hasBreakTime!) &&
                                    (absentee!.attendance!.inTime != null &&
                                        absentee!.attendance!.outTime ==
                                            null)) {
                                  showInfoDialog(
                                    'ok',
                                    context: context,
                                    title: 'Hey there!',
                                    content:
                                        'Sorry time is not up for clocking out. \nPlease clockout when meeting ends.',
                                    onTap: () => Navigator.pop(context),
                                  );
                                  return;
                                }
                                if ((currentTime.isAfter(closeTime) &&
                                        !absentee!.attendance!.meetingEventId!
                                            .hasOvertime!) &&
                                    (absentee!.attendance!.inTime != null &&
                                        absentee!.attendance!.outTime ==
                                            null)) {
                                  showInfoDialog(
                                    'ok',
                                    context: context,
                                    title: 'Hey there!',
                                    content:
                                        'Sorry meeting has ended, contact admin to clock you out.',
                                    onTap: () => Navigator.pop(context),
                                  );
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title:
                                          absentee!.attendance!.inTime == null
                                              ? 'Clock In'
                                              : 'Clock Out',
                                      content: absentee!.attendance!.inTime ==
                                              null
                                          ? 'Are you sure you want to clock in?'
                                          : 'Are you sure you want to clock out?',
                                      onConfirmTap: () async {
                                        Navigator.pop(context);
                                        absentee!.attendance!.inTime == null
                                            ? await Provider.of<
                                                        SelfClockingProvider>(
                                                    context,
                                                    listen: false)
                                                .clockMemberIn(
                                                context: context,
                                                attendee: absentee!,
                                                time: null,
                                              )
                                            : await Provider.of<
                                                        SelfClockingProvider>(
                                                    context,
                                                    listen: false)
                                                .clockMemberOut(
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
                              }
                            } else {
                              debugPrint("Meeting time is not up");
                              showInfoDialog(
                                'ok',
                                context: context,
                                title: 'Hey there!',
                                content:
                                    'Meeting time is not up for clocking. \nPlease try again when it\'s time!',
                                onTap: () => Navigator.pop(context),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
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
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        absentee!.attendance!.inTime != null
                            ? Text('IN : $inTime')
                            : const SizedBox(),
                        SizedBox(
                          height: displayHeight(context) * 0.008,
                        ),
                        absentee!.attendance!.inTime != null
                            ? Text('OUT :  $outTime')
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.005,
                    ),
                    (absentee!.attendance!.meetingEventId!.hasBreakTime! &&
                            absentee!.attendance!.inTime != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SB: $startBreakTime',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                'EB: $endBreakTime',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    (absentee!.attendance!.meetingEventId!.hasBreakTime!) &&
                            (absentee!.attendance!.inTime != null &&
                                absentee!.attendance!.outTime == null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomElevatedButton(
                                label: "Start Break",
                                color: Colors.green,
                                labelSize: 14,
                                textColor: Colors.white,
                                radius: 5,
                                function: () {
                                  if (absentee!.attendance!.startBreak !=
                                      null) {
                                    showInfoDialog(
                                      'ok',
                                      context: context,
                                      title: 'Sorry!',
                                      content:
                                          'You have already started break. \nThank you!',
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
                                          title: 'Start Break',
                                          content:
                                              'Are you sure you want start break?',
                                          onConfirmTap: () {
                                            Navigator.pop(context);
                                            Provider.of<SelfClockingProvider>(
                                                    context,
                                                    listen: false)
                                                .startMeetingBreak(
                                              context: context,
                                              attendee: absentee!,
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
                              SizedBox(
                                width: displayWidth(context) * 0.02,
                              ),
                              CustomElevatedButton(
                                label: "End Break",
                                labelSize: 14,
                                color: primaryColor,
                                radius: 5,
                                function: () {
                                  if (absentee!.attendance!.endBreak != null) {
                                    showInfoDialog(
                                      'ok',
                                      context: context,
                                      title: 'Sorry!',
                                      content:
                                          'Your break has already been ended. \nThank you!',
                                      onTap: () => Navigator.pop(context),
                                    );
                                  } else if (absentee!.attendance!.startBreak ==
                                      null) {
                                    showInfoDialog(
                                      'ok',
                                      context: context,
                                      title: 'Sorry!',
                                      content:
                                          'You can\'t end a break that has not been started. Please start the break to continue!',
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
                                          title: 'End Break',
                                          content:
                                              'Are you sure you want end break?',
                                          onConfirmTap: () {
                                            Navigator.pop(context);
                                            Provider.of<SelfClockingProvider>(
                                                    context,
                                                    listen: false)
                                                .endMeetingBreak(
                                              context: context,
                                              attendee: absentee!,
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
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
