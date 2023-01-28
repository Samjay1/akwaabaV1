import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/components/tag_widget_solid.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/attendance_history_item.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/versionOne/attendance_history_item_preview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryItemWidget extends StatelessWidget {
  final AttendanceHistory? attendanceHistory;
  final String? userType;
  AttendanceHistoryItemWidget({Key? key, this.attendanceHistory, this.userType})
      : super(key: key);

  late AttendanceHistoryProvider attendanceHistoryProvider;

  @override
  Widget build(BuildContext context) {
    attendanceHistoryProvider = context.watch<AttendanceHistoryProvider>();

    var overtime = DateUtil.getTimeStringFromDouble(
      double.parse(attendanceHistory!.attendanceRecord!.meetings![0].overtime!),
    );

    var undertime = DateUtil.getTimeStringFromDouble(
      double.parse(
          attendanceHistory!.attendanceRecord!.meetings![0].undertime!),
    );

    var lateness = DateUtil.getHourStringFromDouble(
      double.parse(attendanceHistory!.attendanceRecord!.meetings![0].lateness!),
    );

    var attendeeName =
        "${attendanceHistory!.attendanceRecord!.member!.firstname!} ${attendanceHistory!.attendanceRecord!.member!.surname!}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: userType == AppConstants.member
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendanceHistoryItemPreviewPage(
                      attendanceHistory: attendanceHistory,
                    ),
                  ),
                );
              },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                attendanceHistory!.attendanceRecord!.member!.profilePicture !=
                        null
                    ? Align(
                        child: CustomCachedImageWidget(
                          url: attendanceHistory!
                              .attendanceRecord!.member!.profilePicture!,
                          height: 50,
                        ),
                      )
                    : defaultProfilePic(height: 50),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      attendeeName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: textColorLight,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "${DateUtil.formatStringDate(DateFormat.MMMEd(), date: attendanceHistoryProvider.selectedStartDate!)} -  ${DateUtil.formatStringDate(DateFormat.yMMMEd(), date: attendanceHistoryProvider.selectedEndDate!)}",
                          style: const TextStyle(
                              fontSize: 14, color: textColorLight),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.meeting_room,
                              size: 16,
                              color: textColorLight,
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.01,
                            ),
                            Text(
                              attendanceHistory!.attendanceRecord!.meetings![0]
                                  .meeting!.name!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: textColorLight,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Late: $lateness times",
                          style: const TextStyle(
                              fontSize: 14, color: primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Overtime: $overtime hrs",
                      style:
                          const TextStyle(fontSize: 14, color: textColorLight),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Lateness: $undertime hrs",
                      style:
                          const TextStyle(fontSize: 14, color: textColorLight),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Total Attendance: ${attendanceHistory!.attendanceRecord!.meetings![0].totalAttendance}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: textColorLight,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TagWidgetSolid(
                        text: attendanceHistory!.status!.name!,
                        color: attendanceHistory!.status!.name == 'Active'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                )),
                userType == AppConstants.member
                    ? const SizedBox()
                    : const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.chevron_right),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextWidget({String label = "", String text = ""}) {
    return RichText(
      text: TextSpan(
          text: '$label ',
          style: const TextStyle(color: textColorLight, fontSize: 13),
          children: <TextSpan>[
            TextSpan(
              text: ' $text',
              style: const TextStyle(color: textColorPrimary, fontSize: 15),
            )
          ]),
    );
  }
}
