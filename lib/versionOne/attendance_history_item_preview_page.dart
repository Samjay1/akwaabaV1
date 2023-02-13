import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/components/tag_widget_solid.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';

class AttendanceHistoryItemPreviewPage extends StatefulWidget {
  final AttendanceHistory? attendanceHistory;
  const AttendanceHistoryItemPreviewPage({Key? key, this.attendanceHistory})
      : super(key: key);

  @override
  State<AttendanceHistoryItemPreviewPage> createState() =>
      _AttendanceHistoryItemPreviewPageState();
}

class _AttendanceHistoryItemPreviewPageState
    extends State<AttendanceHistoryItemPreviewPage> {
  late AttendanceHistoryProvider attendanceHistoryProvider;
  @override
  Widget build(BuildContext context) {
    attendanceHistoryProvider = context.watch<AttendanceHistoryProvider>();
    var overtime = DateUtil.getTimeStringFromDouble(
      double.parse(widget.attendanceHistory!.overtime!),
    );

    var onTime = DateUtil.getTimeStringFromDouble(
      double.parse(
        widget.attendanceHistory!.onTime!,
      ),
    );

    var undertime = DateUtil.getTimeStringFromDouble(
      double.parse(
        widget.attendanceHistory!.undertime!,
      ),
    );

    var breakOverstay = DateUtil.getTimeStringFromDouble(
      double.parse(
        widget.attendanceHistory!.breakOverstay!,
      ),
    );

    var lateness = DateUtil.getTimeStringFromDouble(
      double.parse(
        widget.attendanceHistory!.lateness!,
      ),
    );

    var attendeeName =
        "${widget.attendanceHistory!.attendanceRecord!.member!.firstname!} ${widget.attendanceHistory!.attendanceRecord!.member!.surname!}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Records"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerWidget(attendeeName, undertime, overtime),
              const SizedBox(
                height: 12,
              ),
              meetingRecords(onTime, lateness, breakOverstay),
              widget.attendanceHistory!.attendanceRecord!.meetings!.length > 1
                  ? const SizedBox(
                      height: 12,
                    )
                  : const SizedBox(),
              widget.attendanceHistory!.attendanceRecord!.meetings!.length > 1
                  ? meetings(onTime, lateness)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget(String name, var undertime, var overtime) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.attendanceHistory!.attendanceRecord!.member!.profilePicture !=
                  null
              ? Align(
                  child: CustomCachedImageWidget(
                    url: widget.attendanceHistory!.attendanceRecord!.member!
                        .profilePicture!,
                    height: 70,
                  ),
                )
              : defaultProfilePic(height: 70),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: const TextStyle(fontSize: 15, color: textColorLight),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                widget.attendanceHistory!.attendanceRecord!.meetings![0]
                    .meeting!.name!,
                style: const TextStyle(
                  fontSize: 15,
                  color: textColorLight,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
              "Meeting Type : ${widget.attendanceHistory!.attendanceRecord!.meetings![0].meeting!.type! == 1 ? 'Meeting' : 'Event'}",
              style: const TextStyle(fontSize: 15, color: textColorLight)),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Under time:   $undertime hrs",
            style: const TextStyle(
              fontSize: 15,
              color: textColorLight,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Overtime time:   $overtime hrs",
            style: const TextStyle(
              fontSize: 15,
              color: textColorLight,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.center,
            child: TagWidgetSolid(
              text: widget.attendanceHistory!.status!.name!,
              color: widget.attendanceHistory!.status!.name == 'Active'
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget meetingRecords(var onTime, var lateness, var breakOverStay) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Meeting Records",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          attendanceRecordItemView(
              title: "Total Attendance",
              info: widget.attendanceHistory!.totalAttendance!),
          attendanceRecordItemView(title: "On Time", info: '$onTime hrs'),
          attendanceRecordItemView(
            title: double.parse(widget.attendanceHistory!.lateness!).isNegative
                ? "Earliness"
                : "Earliness",
            info: '$lateness hrs',
          ),
          attendanceRecordItemView(
            title: !double.parse(widget.attendanceHistory!.lateness!).isNegative
                ? "Lateness"
                : "Lateness",
            info: '$lateness hrs',
          ),
          attendanceRecordItemView(
            title: "BreakOverStay",
            info: '$breakOverStay hrs',
          )
        ],
      ),
    );
  }

  Widget meetings(var onTime, var lateness) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Other Meetings",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.attendanceHistory!.attendanceRecord!.meetings!.length,
              (index) {
                if (index > 0) {
                  return Text(
                    widget.attendanceHistory!.attendanceRecord!.meetings![index]
                        .meeting!.name!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textColorLight,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget attendanceRecordItemView({
    required String title,
    required String info,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title"),
              Text("$info"),
            ],
          ),
          const Divider(
            height: 0,
            color: textColorLight,
          ),
        ],
      ),
    );
  }
}
