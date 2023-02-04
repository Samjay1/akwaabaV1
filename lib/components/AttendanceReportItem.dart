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
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../versionOne/attendance_report_preview.dart';
import 'tag_widget_solid.dart';

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
    var attendeeName =
        "${attendee!.additionalInfo!.memberInfo!.firstname!.capitalize()} ${attendee!.additionalInfo!.memberInfo!.middlename!.isEmpty ? '' : attendee!.additionalInfo!.memberInfo!.middlename!.capitalize()} ${attendee!.additionalInfo!.memberInfo!.surname!.capitalize()}";

    var meetingDate = 'N/A';
    if (attendee!.attendance!.date != null) {
      meetingDate = DateUtil.formatStringDate(
        DateFormat.yMMMEd(),
        date: DateTime.parse(attendee!.attendance!.date!),
      );
    }

    var lastSeenDate = 'N/A';
    if (attendee!.lastSeen != null) {
      lastSeenDate = DateUtil.convertToAgo(
        date: DateTime.parse(attendee!.lastSeen!),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AttendanceReportDetailsPage(
              attendee: attendee,
              isAttendee: false,
            ),
          ),
        );
      },
      child: Container(
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
                // Icon(
                //   attendee!.selected!
                //       ? CupertinoIcons.check_mark_circled_solid
                //       : CupertinoIcons.checkmark_alt_circle,
                //   color: attendee!.selected! ? primaryColor : Colors.grey,
                // ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          attendee!.additionalInfo!.memberInfo!
                                      .profilePicture !=
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
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: displayWidth(context) * 0.02,
                                    ),
                                    TagWidgetSolid(
                                      color: primaryColor,
                                      text:
                                          attendee!.attendance!.justification ??
                                              'No Excuse',
                                    ),
                                  ],
                                ),
                                Text(
                                  attendee!.attendance!.meetingEventId!.name!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textColorLight,
                                  ),
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: textColorLight,
                                      size: 16,
                                    ),
                                    Text(
                                      meetingDate,
                                      style: const TextStyle(
                                          color: textColorLight, fontSize: 14),
                                    ),
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
                                // SizedBox(
                                //   height: displayHeight(context) * 0.01,
                                // ),
                                // Text(
                                //   attendee!.attendance!.justification ?? 'N/A',
                                //   style: const TextStyle(
                                //     fontSize: 14,
                                //     color: textColorLight,
                                //   ),
                                // ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
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
      ),
    );
  }
}
