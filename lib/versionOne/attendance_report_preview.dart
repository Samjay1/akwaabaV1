import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/follow_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_theme.dart';

class AttendanceReportDetailsPage extends StatefulWidget {
  final Attendee? attendee;
  const AttendanceReportDetailsPage({Key? key, this.attendee})
      : super(key: key);

  @override
  State<AttendanceReportDetailsPage> createState() =>
      _AttendanceReportDetailsPageState();
}

class _AttendanceReportDetailsPageState
    extends State<AttendanceReportDetailsPage> {
  String? userType;

  @override
  void initState() {
    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? latenessTime;
    DateTime? inTime;
    bool isLate = true;

    var outTime = 'N/A';
    var meetingDate = DateUtil.formatStringDate(
      DateFormat.yMMMEd(),
      date: DateTime.now(),
    );
    var startTime = DateUtil.formate12hourTime(
            myTime: widget.attendee!.attendance!.meetingEventId!.startTime!)
        .toLowerCase();
    var closeTime = DateUtil.formate12hourTime(
            myTime: widget.attendee!.attendance!.meetingEventId!.closeTime!)
        .toLowerCase();
    var attendeeName =
        "${widget.attendee!.attendance!.memberId!.firstname!} ${widget.attendee!.attendance!.memberId!.surname!}";
    var attendeePhone = widget.attendee!.attendance!.memberId!.phone!;
    if (widget.attendee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(
        DateFormat.jm(),
        date: DateTime.parse(widget.attendee!.attendance!.outTime!),
      ).toLowerCase();
    }
    if (widget.attendee!.attendance!.meetingEventId!.latenessTime != null &&
        widget.attendee!.attendance!.inTime != null) {
      var lTime = widget.attendee!.attendance!.meetingEventId!.latenessTime!;
      var lHour = int.parse(lTime.substring(0, 2));
      final lMin = int.parse(lTime.substring(3, 5));
      final lSec = int.parse(lTime.substring(6, 8));

      var iTime = widget.attendee!.attendance!.inTime!;
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

      isLate = latenessTime.compareTo(inTime) < 0 ? true : false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Report Details"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // defaultProfilePic(height: 110),
              widget.attendee!.additionalInfo!.memberInfo!.profilePicture !=
                      null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: widget.attendee!.additionalInfo!.memberInfo!
                            .profilePicture!,
                        height: 110,
                      ),
                    )
                  : defaultProfilePic(height: 110),
              const SizedBox(
                height: 12,
              ),
              Text(
                attendeeName,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),

              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          openWhatsapp(
                            context,
                            attendeePhone,
                            'Hello, \n\nI\'m experiencing an issue and I need an assistance.',
                          );
                          // var whatsappUrl =
                          //     "whatsapp://send?phone=${'+2332034549084'}";
                          // if (await launchUrl(Uri.parse(whatsappUrl))) {
                          //   //dialer opened
                          // } else {
                          //   //dailer is not opened
                          // }
                        },
                        icon: Image.asset(
                          "images/icons/whatsapp_icon.png",
                          width: 19,
                          height: 19,
                        ),
                      ),

                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                          onPressed: () async {
                            makePhoneCall(attendeePhone);
                          },
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          )),
                      // const Text("0205287979",style: TextStyle(
                      //     fontWeight: FontWeight.w400,fontSize: 14,color: textColorLight
                      // ),),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  isLate ? AppString.lateText : AppString.earlyText,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                decoration: BoxDecoration(
                  color: isLate ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 30,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.attendee!.attendance!.meetingEventId!.name!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date : ${widget.attendee!.attendance!.date == null ? "N/A" : DateUtil.formatStringDate(DateFormat.yMMMEd(), date: DateTime.parse(widget.attendee!.attendance!.date!))}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColorLight,
                                  fontSize: 14),
                            ),
                            Text(
                              "Span: ${widget.attendee!.attendance!.meetingEventId!.meetingSpan} Day(s)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColorLight,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Time : $startTime  to  $closeTime",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textColorLight,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 12,
              ),
              // const Divider(
              //   color: textColorPrimary,
              // ),

              const SizedBox(
                height: 24,
              ),

              LabelWidgetContainer(
                  label: "Clock Time",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customTextWidget(
                        label: "In",
                        text: inTime == null
                            ? "N/A"
                            : DateUtil.formatStringDate(DateFormat.jm(),
                                    date: DateTime.parse(
                                        widget.attendee!.attendance!.inTime!))
                                .toLowerCase(),
                      ),
                      _customTextWidget(label: "Out", text: outTime),
                    ],
                  )),

              const Divider(
                color: textColorPrimary,
              ),

              widget.attendee!.attendance!.meetingEventId!.hasBreakTime!
                  ? const SizedBox(
                      height: 12,
                    )
                  : const SizedBox(),

              widget.attendee!.attendance!.meetingEventId!.hasBreakTime!
                  ? LabelWidgetContainer(
                      label: "Break Time",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _customTextWidget(
                              label: "Start",
                              text: widget.attendee!.attendance!.startBreak ==
                                      null
                                  ? "N/A"
                                  : DateUtil.formatStringDate(DateFormat.jm(),
                                          date: DateTime.parse(widget.attendee!
                                              .attendance!.startBreak!))
                                      .toLowerCase()),
                          _customTextWidget(
                              label: "End",
                              text: widget.attendee!.attendance!.endBreak ==
                                      null
                                  ? "N/A"
                                  : DateUtil.formatStringDate(DateFormat.jm(),
                                          date: DateTime.parse(widget
                                              .attendee!.attendance!.endBreak!))
                                      .toLowerCase()),
                        ],
                      ))
                  : const SizedBox(),

              widget.attendee!.attendance!.meetingEventId!.hasBreakTime!
                  ? const Divider(
                      color: textColorPrimary,
                    )
                  : const SizedBox(),

              // widget.attendee!.attendance!.meetingEventId!.hasOvertime!
              //     ? const SizedBox(
              //         height: 16,
              //       )
              //     : const SizedBox(),
              // widget.attendee!.attendance!.meetingEventId!.hasOvertime!
              //     ? LabelWidgetContainer(
              //         label: "Overtime", child: Text("2:00 hrs"))
              //     : const SizedBox(),
              // widget.attendee!.attendance!.meetingEventId!.hasOvertime!
              //     ? const Divider(
              //         color: textColorPrimary,
              //       )
              //     : const SizedBox(),

              const SizedBox(
                height: 8,
              ),
              LabelWidgetContainer(
                  label: "Clocked In By:",
                  child: Text(widget.attendee!.attendance!.clockedBy == 0
                      ? "$attendeeName(Me)"
                      : "Admin")),
              const Divider(
                color: textColorPrimary,
              ),
              const SizedBox(
                height: 8,
              ),
              LabelWidgetContainer(
                  label: "Clocked Out by",
                  child: Text(widget.attendee!.attendance!.clockedBy == 0
                      ? "Me"
                      : "Admin")),

              const Divider(
                color: textColorPrimary,
              ),
              const SizedBox(height: 8),

              LabelWidgetContainer(
                label: "Last Seen",
                child: Text(
                  widget.attendee!.lastSeen == null
                      ? "N/A"
                      : DateUtil.formatStringDate(
                          DateFormat.yMMMEd().add_jm(),
                          date: DateTime.parse(widget.attendee!.lastSeen!),
                        ),
                ),
              ),

              const Divider(
                color: textColorPrimary,
              ),

              const SizedBox(
                height: 16,
              ),

              (userType == AppConstants.admin &&
                      widget.attendee!.attendance!.inTime == null)
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (_) => AlertDialog(
                        //         insetPadding: const EdgeInsets.all(10),
                        //         backgroundColor: Colors.transparent,
                        //         elevation: 0,
                        //         content: ConfirmDialog(
                        //           title: 'Cancel Clocking',
                        //           content:
                        //               'Are you sure you want to cancel clocking on behalf of $attendeeName?',
                        //           onConfirmTap: () {
                        //             Navigator.pop(context);
                        //             Provider.of<AttendanceProvider>(context,
                        //                     listen: false)
                        //                 .cancelClocking(
                        //               context: context,
                        //               attendee: widget.attendee,
                        //               time: null,
                        //             );
                        //           },
                        //           onCancelTap: () => Navigator.pop(context),
                        //           confirmText: 'Yes',
                        //           cancelText: 'Cancel',
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         vertical: 7, horizontal: 13),
                        //     decoration: BoxDecoration(
                        //         color: Colors.red,
                        //         borderRadius: BorderRadius.circular(10)),
                        //     child: const Text(
                        //       "Cancel",
                        //       style: TextStyle(color: Colors.black),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FollowUpPage(
                                    attendee: widget.attendee,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 13),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "Follow up",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    )
                  : const SizedBox(),
            ],
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
