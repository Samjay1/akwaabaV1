import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/models/attendance_history_item.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/versionOne/attendance_history_item_preview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryItemWidget extends StatelessWidget {
  final AttendanceHistory? attendanceHistory;
  AttendanceHistoryItemWidget({
    Key? key,
    this.attendanceHistory,
  }) : super(key: key);

  late AttendanceHistoryProvider attendanceHistoryProvider;

  @override
  Widget build(BuildContext context) {
    attendanceHistoryProvider = context.watch<AttendanceHistoryProvider>();
    var attendeeName =
        "${attendanceHistory!.attendanceRecord!.member!.firstname!} ${attendanceHistory!.attendanceRecord!.member!.surname!}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
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
                      style: TextStyle(fontSize: 18),
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
                          style: TextStyle(fontSize: 14, color: textColorLight),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                        "Meeting Type : ${attendanceHistory!.attendanceRecord!.meetings![0].meeting!.type! == 1 ? 'Meeting' : 'Event'}",
                        style: TextStyle(fontSize: 14, color: textColorLight)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Under time: ${attendanceHistory!.attendanceRecord!.meetings![0].undertime} hrs",
                      style: TextStyle(fontSize: 14, color: textColorLight),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TagWidget(
                        text: attendanceHistory!
                            .attendanceRecord!.meetings![0].status!.name!,
                        color: attendanceHistory!.attendanceRecord!.meetings![0]
                                    .status!.name ==
                                'Inactive'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                )),
                Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.chevron_right))
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
