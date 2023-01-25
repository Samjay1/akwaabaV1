import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
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
    var inTime = 'N/A';
    if (attendee!.attendance!.inTime != null) {
      inTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(attendee!.attendance!.inTime!))
          .toLowerCase();
    }

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

    var lastSeenDate = DateUtil.convertToAgo(
      date: DateTime.parse(attendee!.lastSeen!),
    );

    var attendeeName =
        "${attendee!.additionalInfo!.memberInfo!.firstname!} ${attendee!.additionalInfo!.memberInfo!.surname!}";

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: displayHeight(context) * 0.008,
                    ),
                    Text(
                      'ID: ${attendee!.identification}',
                      style: const TextStyle(fontSize: 16, color: blackColor),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
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
                    SizedBox(
                      height: displayHeight(context) * 0.005,
                    ),
                    attendee!.attendance!.meetingEventId!.hasBreakTime!
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
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.01,
                            ),
                            Text(
                              attendee!.attendance!.meetingEventId!.name!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: blackColor,
                              ),
                            ),
                          ],
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
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Text(
                      "Last seen: $lastSeenDate",
                      style: const TextStyle(
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    if (attendee!.attendance!.inTime != null &&
                        userType == AppConstants.admin)
                      attendee!.attendance!.validate! == 1
                          ? const SizedBox(
                              width: double.infinity,
                              child: Expanded(
                                child: TagWidget(
                                  color: Colors.green,
                                  text: "Validated",
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title: 'Validate',
                                      content:
                                          'Are you sure you want to validate $attendeeName?',
                                      onConfirmTap: () {
                                        Navigator.pop(context);
                                        Provider.of<AttendanceProvider>(context,
                                                listen: false)
                                            .validateMemberAttendance(
                                          clockingId: attendee!.attendance!.id!,
                                        );
                                      },
                                      onCancelTap: () => Navigator.pop(context),
                                      confirmText: 'Yes',
                                      cancelText: 'Cancel',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.borderRadius8),
                                  color: Colors.green,
                                ),
                                child: const Text(
                                  "Validate",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
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
