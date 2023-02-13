import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget_solid.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/versionOne/attendance_history_item_preview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryItemWidget extends StatefulWidget {
  final AttendanceHistory? attendanceHistory;
  final String? userType;
  const AttendanceHistoryItemWidget(
      {Key? key, this.attendanceHistory, this.userType})
      : super(key: key);

  @override
  State<AttendanceHistoryItemWidget> createState() =>
      _AttendanceHistoryItemWidgetState();
}

class _AttendanceHistoryItemWidgetState
    extends State<AttendanceHistoryItemWidget> {
  late AttendanceHistoryProvider attendanceHistoryProvider;

  bool reveal = false;

  @override
  Widget build(BuildContext context) {
    attendanceHistoryProvider = context.watch<AttendanceHistoryProvider>();

    var overtime = DateUtil.getTimeStringFromDouble(
      double.parse(widget.attendanceHistory!.overtime!),
    );

    // var undertime = DateUtil.getTimeStringFromDouble(
    //   double.parse(widget.attendanceHistory!.undertime!),
    // );

    var lateness = DateUtil.getTimeStringFromDouble(
      double.parse(
        widget.attendanceHistory!.lateness!,
      ),
    );

    var attendeeName =
        "${widget.attendanceHistory!.attendanceRecord!.member!.firstname!.capitalize()} ${widget.attendanceHistory!.attendanceRecord!.member!.middlename!.isEmpty ? '' : widget.attendanceHistory!.attendanceRecord!.member!.middlename!.capitalize()} ${widget.attendanceHistory!.attendanceRecord!.member!.surname!.capitalize()}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: widget.userType == AppConstants.member
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendanceHistoryItemPreviewPage(
                      attendanceHistory: widget.attendanceHistory,
                    ),
                  ),
                );
              },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(AppPadding.p12),
            child: Row(
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.attendanceHistory!.attendanceRecord!.member!
                            .profilePicture !=
                        null
                    ? Align(
                        child: CustomCachedImageWidget(
                          url: widget.attendanceHistory!.attendanceRecord!
                              .member!.profilePicture!,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            attendeeName,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        widget.userType == AppConstants.member
                            ? const SizedBox()
                            : const Icon(
                                Icons.chevron_right,
                                color: primaryColor,
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
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
                        // widget.attendanceHistory!.attendanceRecord!.meetings!
                        //             .length ==
                        //         1
                        //     ? Text(
                        //         widget.attendanceHistory!.attendanceRecord!
                        //             .meetings![0].meeting!.name!,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: textColorLight,
                        //         ),
                        //       )
                        //     :
                        Text(
                          '${attendanceHistoryProvider.selectedMeetingEventIndexes.length} meetings',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textColorLight,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Row(
                        //       children: List.generate(
                        //         reveal
                        //             ? widget.attendanceHistory!
                        //                 .attendanceRecord!.meetings!.length
                        //             : (widget
                        //                     .attendanceHistory!
                        //                     .attendanceRecord!
                        //                     .meetings!
                        //                     .length -
                        //                 (widget
                        //                         .attendanceHistory!
                        //                         .attendanceRecord!
                        //                         .meetings!
                        //                         .length -
                        //                     1)),
                        //         (index) => Padding(
                        //           padding: const EdgeInsets.only(left: 5.0),
                        //           child: Text(
                        //             widget.attendanceHistory!.attendanceRecord!
                        //                 .meetings![index].meeting!.name!,
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               color: textColorLight,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: displayWidth(context) * 0.01,
                        //     ),
                        //     InkWell(
                        //       onTap: () => setState(
                        //         () => reveal = !reveal,
                        //       ),
                        //       child: Text(
                        //         reveal ? 'view less...' : 'view more...',
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.w400,
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
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
                          (attendanceHistoryProvider.selectedStartDate ==
                                      null &&
                                  attendanceHistoryProvider.selectedEndDate ==
                                      null)
                              ? 'N/A'
                              : "${DateUtil.formatStringDate(DateFormat.MMMEd(), date: attendanceHistoryProvider.selectedStartDate!)} -  ${DateUtil.formatStringDate(DateFormat.yMMMEd(), date: attendanceHistoryProvider.selectedEndDate!)}",
                          style: const TextStyle(
                              fontSize: 14, color: textColorLight),
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
                      double.parse(widget.attendanceHistory!.lateness!)
                              .isNegative
                          ? 'Earliness: $lateness hrs'
                          : 'Earliness: 0.00 hrs',
                      style:
                          const TextStyle(fontSize: 14, color: textColorLight),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      !double.parse(widget.attendanceHistory!.lateness!)
                              .isNegative
                          ? 'Lateness: $lateness hrs'
                          : 'Lateness: 0.00 hrs',
                      style:
                          const TextStyle(fontSize: 14, color: textColorLight),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Total Attendance: ${widget.attendanceHistory!.totalAttendance}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: textColorLight,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.02,
                        ),
                        TagWidgetSolid(
                          text: widget.attendanceHistory!.status!.name!,
                          color:
                              widget.attendanceHistory!.status!.name == 'Active'
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ],
                    ),
                  ],
                )),
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
