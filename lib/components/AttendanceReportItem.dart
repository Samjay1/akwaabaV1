import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../versionOne/attendance_report_preview.dart';

class AttendanceReportItem extends StatelessWidget {
  final Attendee? attendee;

  final String? userType;
  const AttendanceReportItem({
    Key? key,
    required this.attendee,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? latenessTime;
    DateTime? inTime;
    bool isLate = true;
    var attendeeName =
        "${attendee!.attendance!.memberId!.firstname!} ${attendee!.attendance!.memberId!.surname!}";
    if (attendee!.attendance!.meetingEventId!.latenessTime != null &&
        attendee!.attendance!.inTime != null) {
      // var isLate = DateUtil.formatStringDate(
      //   DateFormat.yMMMEd(),
      //   date: DateTime.parse(attendee!.attendance!.date!),
      // );

      var lTime = attendee!.attendance!.meetingEventId!.latenessTime!;
      var lHour = int.parse(lTime.substring(0, 2));
      final lMin = int.parse(lTime.substring(3, 5));
      final lSec = int.parse(lTime.substring(6, 8));

      var iTime = attendee!.attendance!.inTime!;
      var iHour = int.parse(iTime.substring(11, 13));
      final iMin = int.parse(iTime.substring(14, 16));
      final iSec = int.parse(iTime.substring(17, 19));

      // debugPrint("Time: $iTime");
      // debugPrint(
      //     "NewTime: ${iTime.substring(11, 13)}: ${iTime.substring(14, 16)}: $iSec");

      latenessTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          lHour,
          lMin,
          lSec,
          DateTime.now().millisecond,
          DateTime.now().microsecond);
      inTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          iHour,
          iMin,
          iSec,
          DateTime.now().millisecond,
          DateTime.now().microsecond);

      //var inTime = DateTime.parse(attendee!.attendance!.inTime!);
      // debugPrint("Name: ${attendee!.attendance!.memberId!.firstname}");
      // debugPrint(
      //     "12 hour lateness: ${DateFormat('HH:mm:ss').format(latenessTime)}");
      // debugPrint("Now: ${DateTime.now().toIso8601String()}");
      // debugPrint("Lateness time: ${latenessTime.toIso8601String()}");
      // debugPrint("inTime: ${inTime.toIso8601String()}");

      // DateTime dt1 = DateTime.parse("2023-01-10 17:27:00");
      // DateTime dt2 = DateTime.parse("2023-01-10 20:09:00");

      isLate = latenessTime.compareTo(inTime) < 0 ? true : false;

      // if (latenessTime.compareTo(inTime) == 0) {
      //   print("Both date time are at same moment.");
      // }

      // if (latenessTime.compareTo(inTime) < 0) {
      //   print("DT1 is before DT2");
      // }

      // if (latenessTime.compareTo(inTime) > 0) {
      //   print("DT1 is after DT2");
      // }
    }

    var meetingDate = DateUtil.formatStringDate(
      DateFormat.yMMMEd(),
      date: DateTime.parse(attendee!.attendance!.date!),
    );
    var lastSeenDate = DateUtil.convertToAgo(
      date: DateTime.parse(attendee!.lastSeen!),
    );
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        attendee!.additionalInfo!.memberInfo!.profilePicture !=
                                null
                            ? Align(
                                child: CustomCachedImageWidget(
                                  url: attendee!.additionalInfo!.memberInfo!
                                      .profilePicture!,
                                  height: 60,
                                ),
                              )
                            : defaultProfilePic(height: 60),

                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      attendeeName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: displayWidth(context) * 0.02,
                                  ),
                                  TagWidget(
                                    color: isLate ? Colors.red : primaryColor,
                                    text: isLate
                                        ? AppString.lateText
                                        : AppString.earlyText,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.003,
                              ),
                              Text(
                                attendee!.attendance!.meetingEventId!.name!,
                                style: const TextStyle(
                                    fontSize: 14, color: textColorLight),
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.005,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: textColorLight,
                                        size: 16,
                                      ),
                                      Text(
                                        meetingDate,
                                        style: TextStyle(
                                            color: textColorLight,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.005,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AttendanceReportDetailsPage(
                                            attendee: attendee,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.005,
                              ),
                              Text(
                                "Last seen: $lastSeenDate",
                                style: const TextStyle(
                                    color: textColorLight, fontSize: 14),
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.005,
                              ),
                              if (attendee!.attendance!.inTime != null)
                                userType == AppConstants.admin
                                    ? attendee!.attendance!.validate! == 1
                                        ? const TagWidget(
                                            color: Colors.green,
                                            text: "Validated",
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      insetPadding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      content: ConfirmDialog(
                                                        title: 'Validate',
                                                        content:
                                                            'Are you sure you want to validate $attendeeName?',
                                                        onConfirmTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          Provider.of<AttendanceProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .validateMemberAttendance(
                                                            clockingId:
                                                                attendee!
                                                                    .attendance!
                                                                    .id!,
                                                          );
                                                        },
                                                        onCancelTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        confirmText: 'Yes',
                                                        cancelText: 'Cancel',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 7.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppRadius
                                                                .borderRadius8),
                                                    color: Colors.green,
                                                  ),
                                                  child: const Text(
                                                    "Validate",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                    : const SizedBox(),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   width: 8,
                        // ),
                        // IconButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (_) =>
                        //               const AttendanceReportDetailsPage(),
                        //         ),
                        //       );
                        //     },
                        //     icon: const Icon(
                        //       Icons.chevron_right,
                        //       size: 20,
                        //       color: primaryColor,
                        //     ))
                      ],
                    ),
                    const SizedBox(
                      width: 8,
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
