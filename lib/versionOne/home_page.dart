import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/dialogs_modals/agenda_dialog.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/screens/excuse_input_page.dart';
import 'package:akwaaba/screens/members_page.dart';
import 'package:akwaaba/screens/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/label_widget_container.dart';
import '../models/meeting_event_item.dart';
import '../providers/client_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MeetingEventItem> events = [
    MeetingEventItem("Tues Office Work", "16 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Wed Office Work", "17 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Thurs Office Work", "18 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Frid Office Work", "19 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Office Retreat", "20 Aug 2022", "8:00AM", "5:00PM")
  ];
  double screenHeight = 0;
  double screenWidth = 0;
  String userType = "";
  SharedPreferences? prefs;
  var memberToken;
  var clientToken;

  MemberProvider? memberProvider;

  AttendanceProvider? attendanceProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeFunctions();
    });
  }

  initializeFunctions() async {
    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
      loadMeetingEventsByUserType(userType: userType);
    });
  }

  void loadMeetingEventsByUserType({var userType}) async {
    if (userType == 'member') {
      prefs = await SharedPreferences.getInstance();
      memberToken = prefs?.getString('memberToken');

      debugPrint('HOMEPAGE USER TYPE: $userType');
      //debugPrint('HOMEPAGE TOKEN $memberToken');
      // MemberProfile memberProfile =  Provider.of<MemberProvider>(context, listen: false).memberProfile;
      // print('HOMEPAGE member id ${memberProfile.id}');

      Future.delayed(Duration.zero, () {
        Provider.of<AttendanceProvider>(context, listen: false)
            .getUpcomingMeetingEvents(
          memberToken: memberToken,
          context: context,
        );
        setState(() {});
      });

      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   Provider.of<AttendanceProvider>(context, listen: false)
      //       .getUpcomingMeetingEvents(
      //     memberToken: memberToken,
      //     context: context,
      //   );
      //   setState(() {});
      // });
    } else {
      prefs = await SharedPreferences.getInstance();
      memberToken = prefs?.getString('memberToken');
    }
    debugPrint('Token: $memberToken');
  }

  @override
  Widget build(BuildContext context) {
    // loadMeetingEventsByUserType(userType: userType);
    // Provider.of<MemberProvider>(context, listen: false).callmeetingEventList(memberToken: memberToken!, context: context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    ClientAccountInfo? userInfo =
        Provider.of<ClientProvider>(context, listen: false).getUser;
    var profileImage = userInfo?.profilePicture;
    var firstName = userInfo?.firstName;
    var surName = userInfo?.surName;

    var subscriptionFee = 0;
    var subscriptionDuration = 0;
    // new FeeManagerAPi().feeTypesFunc(clientId: 180);

    // Provider.of<MemberProvider>(context, listen: false).getUser;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 24,
              ),

              // TODO: Uncomment it when recent clocking API is available
              // userType.compareTo("member") == 0
              //     ? Consumer<MemberProvider>(
              //         builder: (context, data, child) {
              //           return headerView(
              //               firstName: data.memberProfile.firstname,
              //               surName: data.memberProfile.surname,
              //               profileImage: data.memberProfile.profilePicture);
              //         },
              //       )
              //     : userType.compareTo("admin") == 0
              //         ? Consumer<ClientProvider>(
              //             builder: (context, data, child) {
              //             return headerView(
              //                 firstName: data.getUser?.firstName,
              //                 surName: data.getUser?.surName,
              //                 profileImage: data.getUser?.profilePicture);
              //           })
              //         : const Text("Unknown User type"),

              // const SizedBox(
              //   height: 36,
              // ),

              const Text(
                "Today's Meetings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(
                height: 12,
              ),

              //----------------------------------------------------------------------
              Consumer<AttendanceProvider>(
                builder: (context, data, child) {
                  if (data.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (data.todayMeetings.isEmpty) {
                    return const Center(
                      child: Text(
                        'You currently have no \nmeetings today!',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: data.todayMeetings.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = data.todayMeetings[index];
                        debugPrint('MEETING LIST ${item.memberType}');
                        return todaysEvents(
                          meeting: item,
                          name: item.name,
                          date: item.updateDate,
                          startTime: item.startTime,
                          closeTime: item.closeTime,
                        );
                      });
                },
              ),
              //----------------------------------------------------------------------
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: backgroundColor,
                    collapsedBackgroundColor: backgroundColor,
                    initiallyExpanded: true,
                    title: const Text(
                      "Upcoming",
                      style: TextStyle(
                        color: textColorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        fontFamily: "Lato",
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: Consumer<AttendanceProvider>(
                          builder: (context, data, child) {
                            if (data.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (data.upcomingMeetings.isEmpty) {
                              return const Center(
                                child: Text(
                                  'You currently have no upcoming \nmeetings at the moment!',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: data.upcomingMeetings.length,
                                itemBuilder: (context, index) {
                                  var item = data.upcomingMeetings[index];
                                  debugPrint('MEETING LIST ${item.memberType}');
                                  return upcomingEvents(
                                      name: item.name,
                                      date: item.updateDate,
                                      startTime: item.startTime,
                                      closeTime: item.closeTime);
                                });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerView({var firstName, var surName, var profileImage}) {
    return Consumer<GeneralProvider>(builder: (context, data, child) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpdateAccountPage(),
                    ),
                  );
                },
                child: profileImage != null
                    ? Align(
                        child: CustomCachedImageWidget(
                          url: profileImage,
                          height: 130,
                        ),
                      )

                    // FadeInImage(
                    //   image: NetworkImage("$profileImage"),
                    //   placeholder: const AssetImage(
                    //       "images/illustrations/profile_pic.svg"),
                    //   imageErrorBuilder:
                    //       (context, error, stackTrace) {
                    //     return SvgPicture.asset(
                    //         'images/illustrations/profile_pic.svg',
                    //         height:130,);
                    //   },
                    //   fit: BoxFit.fitWidth,
                    // )
                    : defaultProfilePic(height: 130),
              ),
              Text(
                "$firstName $surName",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Friday Night Duties",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Date : 17/10/2022",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textColorLight,
                            fontSize: 14),
                      ),
                      Text(
                        "Span : 2 Days",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textColorLight,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "Time : 7 am to 5pm",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColorLight,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: const Text(
                        "Online",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.white,
                        title: const Text(
                          "Recent Clocking ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        children: <Widget>[recentClockDetailsView()],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget recentClockDetailsView() {
    return Column(
      children: [
        LabelWidgetContainer(
            label: "Clock Time",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customTextWidget(label: "In", text: "5:00"),
                _customTextWidget(label: "Out", text: "5:00"),
              ],
            )),
        const Divider(
          color: textColorPrimary,
        ),
        const SizedBox(
          height: 12,
        ),
        LabelWidgetContainer(
            label: "Break Time",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customTextWidget(label: "Start", text: "5:00"),
                _customTextWidget(label: "End", text: "5:00"),
              ],
            )),
        const Divider(
          color: textColorPrimary,
        ),
        const SizedBox(
          height: 16,
        ),
        const LabelWidgetContainer(label: "Overtime", child: Text("2:00 hrs")),
        const Divider(
          color: textColorPrimary,
        ),
        const SizedBox(
          height: 8,
        ),
        const LabelWidgetContainer(
            label: "Clocked In By:", child: Text("Self")),
        const Divider(
          color: textColorPrimary,
        ),
        const SizedBox(
          height: 8,
        ),
        const LabelWidgetContainer(
            label: "Clocked Out by:", child: Text("Kofi Mensah (Admin)")),
        const Divider(
          color: textColorPrimary,
        ),
      ],
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

  Widget totalAccountUsers() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MembersPage()));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.person_2_fill,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "20",
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "members ",
                      style: TextStyle(fontSize: 13, color: textColorLight),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget billView() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.creditcard_fill,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "GHS 450",
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text("your bill ",
                      style: TextStyle(fontSize: 13, color: textColorLight))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget todaysEvents({meeting, name, date, startTime, closeTime}) {
    var months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    DateTime formatedDate = DateTime.parse(date.toString());
    var month = formatedDate.month;
    var day = formatedDate.day;
    var year = formatedDate.year;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>
                    // const AttendanceReportDetailsPage()));

                    //displayCustomDialog(context, const CurrentEventPreviewPage());
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "$name",
                            style: const TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 16,
                                color: primaryColor,
                              ),
                              Text(
                                "$day, ${months[month]} $year",
                                style: const TextStyle(
                                    fontSize: 13, color: textColorLight),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.alarm,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                    Text(
                                      "$startTime",
                                      style: const TextStyle(
                                          fontSize: 13, color: textColorLight),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.alarm,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                    Text("$closeTime",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: textColorLight))
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.chevron_right,
                          size: 24,
                          color: Colors.orange,
                        ),
                      )
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Expanded(
                //       child: Row(
                //         children: [
                //           ElevatedButton(
                //               style: ElevatedButton.styleFrom(
                //                   primary: Colors.grey,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(23))),
                //               onPressed: () {
                //                 Provider.of<AttendanceProvider>(context,
                //                         listen: false)
                //                     .setSelectedMeeting(meeting);
                //                 showModalBottomSheet(
                //                   context: context,
                //                   shape: const RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.only(
                //                       topLeft: Radius.circular(16.0),
                //                       topRight: Radius.circular(16.0),
                //                     ),
                //                   ),
                //                   builder: (context) => const AgendaDialog(),
                //                 );
                //               },
                //               child: const Text(
                //                 "Agenda",
                //                 style: TextStyle(color: Colors.white),
                //               )),
                //         ],
                //       ),
                //     ),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         primary: Colors.green,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(23),
                //         ),
                //       ),
                //       onPressed: () {
                //         Provider.of<AttendanceProvider>(context, listen: false)
                //             .setSelectedMeeting(meeting);

                //         showDialog(
                //           context: context,
                //           builder: (_) => AlertDialog(
                //             insetPadding: const EdgeInsets.all(10),
                //             backgroundColor: Colors.transparent,
                //             elevation: 0,
                //             content: ConfirmDialog(
                //               title: meeting.inOrOut ? 'Clock Out' : 'Clock In',
                //               content:
                //                   '${meeting.inOrOut ? 'Are you sure you want to clock-out?' : 'Are you sure you want to clock-in?'} \nMake sure you\'re closer to the premise of the meeting or event to continue.',
                //               onConfirmTap: () {
                //                 Provider.of<AttendanceProvider>(context,
                //                         listen: false)
                //                     .getMeetingCoordinates(
                //                   meetingEventModel: meeting,
                //                 );
                //                 Navigator.pop(context);
                //               },
                //               onCancelTap: () => Navigator.pop(context),
                //               confirmText: 'Yes',
                //               cancelText: 'Cancel',
                //             ),
                //           ),
                //         );
                //       },
                //       child: Provider.of<AttendanceProvider>(context,
                //                   listen: false)
                //               .clocking
                //           ? const Center(
                //               child: SizedBox(
                //                 width: 15,
                //                 height: 15,
                //                 child: CircularProgressIndicator(
                //                   backgroundColor: Colors.white,
                //                   strokeWidth: 2,
                //                 ),
                //               ),
                //             )
                //           : Text(meeting.inOrOut! ? 'Clock Out' : 'Clock In'),
                //     ),
                //     const SizedBox(
                //       width: 12,
                //     ),
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             primary: Colors.red,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(23))),
                //         onPressed: () {
                //           // set meeting as selected
                //           context
                //               .read<AttendanceProvider>()
                //               .setSelectedMeeting(meeting);
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (_) => ExcuseInputPage(),
                //             ),
                //           );
                //         },
                //         child: const Text("Excuse"))
                //   ],
                // )
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23))),
                        onPressed: () {
                          // set meeting as selected
                          context
                              .read<AttendanceProvider>()
                              .setSelectedMeeting(meeting);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExcuseInputPage(),
                            ),
                          );
                        },
                        child: const Text("Excuse")),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23))),
                      onPressed: () {
                        Provider.of<AttendanceProvider>(context, listen: false)
                            .setSelectedMeeting(meeting);

                        if (meeting.outTime != null) {
                          showNormalToast(
                              'You\'ve already clocked out. \nGood Bye!');
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: ConfirmDialog(
                                title:
                                    meeting.inOrOut ? 'Clock Out' : 'Clock In',
                                content:
                                    '${meeting.inOrOut ? 'Are you sure you want to clock-out?' : 'Are you sure you want to clock-in?'} \nMake sure you\'re closer to the premise of the meeting or event to continue.',
                                onConfirmTap: () {
                                  Navigator.pop(context);
                                  Provider.of<AttendanceProvider>(context,
                                          listen: false)
                                      .getMeetingCoordinates(
                                    context: context,
                                    isBreak: false,
                                    meetingEventModel: meeting,
                                  );
                                },
                                onCancelTap: () => Navigator.pop(context),
                                confirmText: 'Yes',
                                cancelText: 'Cancel',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(meeting.inOrOut! ? 'Clock Out' : 'Clock In'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23))),
                        onPressed: () {
                          Provider.of<AttendanceProvider>(context,
                                  listen: false)
                              .setSelectedMeeting(meeting);
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            builder: (context) => const AgendaDialog(),
                          );
                        },
                        child: const Text(
                          "Agenda",
                          style: TextStyle(color: Colors.white),
                        )),
                    // if user has clocked out, there is no need to show 'Start Break' button
                    meeting.hasBreakTime && meeting.outTime == null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23),
                              ),
                            ),
                            onPressed: () {
                              Provider.of<AttendanceProvider>(context,
                                      listen: false)
                                  .setSelectedMeeting(meeting);

                              if (meeting.startBreak != null &&
                                  meeting.endBreak != null) {
                                showNormalToast(
                                    'You\'ve already ended your break. \nGood Bye!');
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title: (meeting.startBreak == null &&
                                              meeting.endBreak == null)
                                          ? 'Start Break'
                                          : 'End Break',
                                      content: (meeting.startBreak == null &&
                                              meeting.endBreak == null)
                                          ? 'Are you sure you want to start your break? \nMake sure you\'re closer to the premise of the meeting or event to continue.'
                                          : 'Are you sure you want to end your break? \nMake sure you\'re closer to the premise of the meeting or event to continue.',
                                      //'${meeting.startBreak != null ? 'Are you sure you want to end?' : 'Are you sure you want to clock-in?'} \nMake sure you\'re closer to the premise of the meeting or event to continue.',
                                      onConfirmTap: () {
                                        Navigator.pop(context);
                                        Provider.of<AttendanceProvider>(context,
                                                listen: false)
                                            .getMeetingCoordinates(
                                          context: context,
                                          isBreak: true,
                                          meetingEventModel: meeting,
                                        );
                                      },
                                      onCancelTap: () => Navigator.pop(context),
                                      confirmText: 'Yes',
                                      cancelText: 'Cancel',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              (meeting.startBreak == null &&
                                      meeting.endBreak == null)
                                  ? 'Start Break'
                                  : 'End Break',
                            ),
                          )
                        : (meeting.hasBreakTime && meeting.inTime == null)
                            ? const SizedBox()
                            : const SizedBox()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget upcomingEvents({name, date, startTime, closeTime}) {
    var months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    DateTime formatedDate = DateTime.parse(date.toString());
    var month = formatedDate.month;
    var day = formatedDate.day;
    var year = formatedDate.year;
    return MeetingEventWidget(MeetingEventItem(
        name, "$day, ${months[month]} $year", startTime, closeTime));

    // return Consumer<MemberProvider>(
    //   builder: (context, data, child){
    //     return data.meetingEventList.length!= 0 ?  ListView.builder(
    //         itemCount: data.meetingEventList.length,
    //         itemBuilder: (context, index){
    //           var item = data?.meetingEventList[index];
    //           return Text('hello');
    //         }
    //     ): const Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
