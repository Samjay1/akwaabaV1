import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
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
      double.parse(
          widget.attendanceHistory!.attendanceRecord!.meetings![0].overtime!),
    );

    var onTime = DateUtil.getHourStringFromDouble(
      double.parse(
          widget.attendanceHistory!.attendanceRecord!.meetings![0].onTime!),
    );

    var undertime = DateUtil.getTimeStringFromDouble(
      double.parse(
          widget.attendanceHistory!.attendanceRecord!.meetings![0].undertime!),
    );

    var lateness = DateUtil.getHourStringFromDouble(
      double.parse(
          widget.attendanceHistory!.attendanceRecord!.meetings![0].lateness!),
    );
    var attendeeName =
        "${widget.attendanceHistory!.attendanceRecord!.member!.firstname!} ${widget.attendanceHistory!.attendanceRecord!.member!.surname!}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Records"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerWidget(attendeeName, undertime, overtime),
              const SizedBox(
                height: 12,
              ),
              meetingRecords(onTime, lateness),
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                size: 16,
                color: textColorLight,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${DateUtil.formatStringDate(DateFormat.MMMEd(), date: attendanceHistoryProvider.selectedStartDate!)} -  ${DateUtil.formatStringDate(DateFormat.yMMMEd(), date: attendanceHistoryProvider.selectedEndDate!)}",
                style: TextStyle(fontSize: 15, color: textColorLight),
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
              style: TextStyle(fontSize: 15, color: textColorLight)),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Under time:   $undertime hrs",
            style: TextStyle(
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
            child: TagWidget(
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

  Widget meetingRecords(var onTime, var lateness) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Meeting Records",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          attendanceRecordItemView(
              title: "Total Attendance",
              info: widget.attendanceHistory!.totalAttendance!),
          attendanceRecordItemView(title: "On Time", info: '$onTime times'),
          attendanceRecordItemView(title: "Lateness ", info: '$lateness times')
        ],
      ),
    );
  }

  Widget attendanceRecordItemView({
    required String title,
    required String info,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title"),
              Text("$info"),
            ],
          ),
          Divider(
            height: 0,
            color: textColorLight,
          ),
        ],
      ),
    );
  }
}
