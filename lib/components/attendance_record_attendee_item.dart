import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/components/tag_widget_solid.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/attendance_report_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceReportAttendeeItem extends StatelessWidget {
  final Attendee? attendee;
  final String? userType;
  const AttendanceReportAttendeeItem({Key? key, this.attendee, this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? latenessTime;
    DateTime? inTime;
    bool isLate = true;

    var outTime = 'N/A';
    if (attendee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.outTime!))
          .toLowerCase();
    }

    var startBreakTime = 'N/A';
    if (attendee!.attendance!.startBreak != null) {
      startBreakTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.startBreak!))
          .toLowerCase();
    }

    var endBreakTime = 'N/A';
    if (attendee!.attendance!.endBreak != null) {
      endBreakTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.endBreak!))
          .toLowerCase();
    }

    var productiveHours = '0:00';
    if (attendee!.productiveHours != null) {
      productiveHours = DateUtil.getTimeStringFromDouble(
          double.parse(attendee!.productiveHours!));
    }

    var breakOverStay = '0:00';
    if (attendee!.attendance!.meetingEventId!.hasBreakTime! &&
        attendee!.breakOverstay != null) {
      breakOverStay = DateUtil.getTimeStringFromDouble(
          double.parse(attendee!.breakOverstay!));
    }

    var lastSeenDate = DateUtil.convertToAgo(
      date: DateTime.parse(attendee!.lastSeen!),
    );

    var attendeeName =
        "${attendee!.additionalInfo!.memberInfo!.firstname!.capitalize()} ${attendee!.additionalInfo!.memberInfo!.middlename!.isEmpty ? '' : attendee!.additionalInfo!.memberInfo!.middlename!.capitalize()} ${attendee!.additionalInfo!.memberInfo!.surname!.capitalize()}";

    if (attendee!.attendance!.meetingEventId!.latenessTime != null &&
        attendee!.attendance!.inTime != null) {
      var lTime = attendee!.attendance!.meetingEventId!.latenessTime!;
      var lHour = int.parse(lTime.substring(0, 2));
      final lMin = int.parse(lTime.substring(3, 5));
      final lSec = int.parse(lTime.substring(6, 8));

      var iTime = attendee!.attendance!.inTime!;
      var iHour = int.parse(iTime.substring(11, 13));
      final iMin = int.parse(iTime.substring(14, 16));
      final iSec = int.parse(iTime.substring(17, 19));

      latenessTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        lHour,
        lMin,
        lSec,
        DateTime.now().millisecond,
        DateTime.now().microsecond,
      );
      inTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        iHour,
        iMin,
        iSec,
        DateTime.now().millisecond,
        DateTime.now().microsecond,
      );

      //isLate = latenessTime.compareTo(inTime) < 0 ? true : false;
      isLate =
          inTime.isBefore(latenessTime) || inTime.isAtSameMomentAs(latenessTime)
              ? false
              : true;
    }

    var formattedInTime = 'N/A';
    if (inTime != null) {
      formattedInTime = DateUtil.formatStringDate(DateFormat.jm(), date: inTime)
          .toLowerCase();
    }

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
              Column(
                children: [
                  attendee!.additionalInfo!.memberInfo!.profilePicture != null
                      ? Align(
                          child: CustomCachedImageWidget(
                            url: attendee!
                                .additionalInfo!.memberInfo!.profilePicture!,
                            height: 60,
                          ),
                        )
                      : defaultProfilePic(height: 60),
                  SizedBox(
                    height: displayHeight(context) * 0.01,
                  ),
                  TagWidgetSolid(
                    color: isLate ? Colors.red : Colors.green,
                    text: isLate ? AppString.lateText : AppString.earlyText,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attendeeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(
                    //   height: displayHeight(context) * 0.008,
                    // ),
                    // Text(
                    //   'ID: ${attendee!.identification}',
                    //   style: const TextStyle(fontSize: 16, color: blackColor),
                    // ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text('IN : $formattedInTime')),
                        12.pw,
                        Text('OUT :  $outTime')
                      ],
                    ),
                    SizedBox(
                      height: (attendee!.attendance!.startBreak == null &&
                              attendee!.attendance!.endBreak == null)
                          ? displayHeight(context) * 0.006
                          : displayHeight(context) * 0.00,
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.003,
                    ),
                    attendee!.attendance!.meetingEventId!.hasBreakTime!
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Break: $startBreakTime',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                              16.pw,
                              Text(
                                'Resume: $endBreakTime',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: (attendee!.attendance!.startBreak == null &&
                              attendee!.attendance!.endBreak == null)
                          ? displayHeight(context) * 0.00
                          : displayHeight(context) * 0.007,
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.005,
                    ),
                    attendee!.attendance!.meetingEventId!.hasBreakTime!
                        ? Text(
                            'Breakoverstay: $breakOverStay hrs',
                            style: const TextStyle(
                              fontSize: 16,
                              color: blackColor,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: displayHeight(context) * 0.005,
                    ),
                    (attendee!.attendance!.inTime != null &&
                            attendee!.attendance!.outTime != null)
                        ? Text(
                            'Productive: $productiveHours hrs',
                            style: const TextStyle(
                              fontSize: 16,
                              color: blackColor,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: (attendee!.attendance!.inTime != null &&
                              attendee!.attendance!.outTime != null)
                          ? displayHeight(context) * 0.005
                          : 0.00,
                    ),
                    Text(
                      DateUtil.formatStringDate(DateFormat.yMMMEd(),
                          date: Provider.of<AttendanceProvider>(context,
                                  listen: false)
                              .selectedDate!),
                      style: const TextStyle(
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Last seen: $lastSeenDate",
                            style: const TextStyle(
                              fontSize: 16,
                              color: blackColor,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttendanceReportDetailsPage(
                                  attendee: attendee,
                                  isAttendee: true,
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
                    if (attendee!.attendance!.inTime != null &&
                        userType == AppConstants.admin)
                      attendee!.attendance!.validate! == 1
                          ? const SizedBox(
                              width: double.infinity,
                              child: TagWidget(
                                color: Colors.green,
                                text: "Validated",
                              ),
                            )
                          : const SizedBox(),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
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
