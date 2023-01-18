import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/components/profile_shimmer_item.dart';
import 'package:akwaaba/components/text_shimmer_item.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/agenda_dialog.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/screens/excuse_input_page.dart';
import 'package:akwaaba/versionOne/members_page.dart';
import 'package:akwaaba/screens/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/clocking_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../components/label_widget_container.dart';
import '../models/meeting_event_item.dart';
import '../providers/client_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double screenHeight = 0;
  double screenWidth = 0;
  String userType = "";
  SharedPreferences? prefs;
  var memberToken;
  var clientToken;

  late MemberProvider memberProvider;

  late HomeProvider eventProvider;

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
    if (userType == AppConstants.member) {
      prefs = await SharedPreferences.getInstance();
      memberToken = prefs?.getString('token');

      debugPrint('HOMEPAGE USER TYPE: $userType');

      Future.delayed(Duration.zero, () {
        if (Provider.of<HomeProvider>(context, listen: false)
            .todayMeetings
            .isEmpty) {
          Provider.of<HomeProvider>(context, listen: false)
              .getTodayMeetingEvents();
          debugPrint('Loading fresh data:...');
        }
        setState(() {});
      });
    } else {
      prefs = await SharedPreferences.getInstance();
      memberToken = prefs?.getString('token');
      Future.delayed(Duration.zero, () {
        if (Provider.of<HomeProvider>(context, listen: false)
            .todayMeetings
            .isEmpty) {
          Provider.of<HomeProvider>(context, listen: false)
              .getTodayMeetingEvents();
          debugPrint('Loading fresh data:...');
        }
        setState(() {});
      });
    }
    debugPrint('Token: $memberToken');
  }

  @override
  Widget build(BuildContext context) {
    eventProvider = context.watch<HomeProvider>();

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

              eventProvider.loading
                  ? Shimmer.fromColors(
                      baseColor: greyColorShade300,
                      highlightColor: greyColorShade100,
                      child: const ProfileShimmerItem(),
                    )
                  : userType.compareTo(AppConstants.member) == 0
                      ? Consumer<MemberProvider>(
                          builder: (context, data, child) {
                            return memberHeaderView(
                              firstName: data.memberProfile.user.firstname,
                              surName: data.memberProfile.user.surname,
                              userId: data.identityNumber,
                              profileImage:
                                  data.memberProfile.user.profilePicture,
                            );
                          },
                        )
                      : userType.compareTo(AppConstants.admin) == 0
                          ? Consumer<ClientProvider>(
                              builder: (context, data, child) {
                              return adminHeaderView(
                                firstName: data.getUser?.applicantFirstname,
                                surName: data.getUser?.applicantSurname,
                                userId: data.getUser?.applicantEmail,
                                profileImage: data.adminProfile?.profilePicture,
                              );
                            })
                          : const Text("Unknown User type"),
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
              //             return adminHeaderView(
              //                 firstName: data.getUser?.firstName,
              //                 surName: data.getUser?.surName,
              //                 profileImage: data.getUser?.profilePicture);
              //           })
              //         : const Text("Unknown User type"),

              const SizedBox(
                height: 36,
              ),

              const SizedBox(
                height: 36,
              ),

              eventProvider.loading
                  ? Shimmer.fromColors(
                      baseColor: greyColorShade300,
                      highlightColor: greyColorShade100,
                      child: const TextShimmerItem(),
                    )
                  : const Text(
                      "Today's Meetings",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),

              const SizedBox(
                height: 12,
              ),

              //----------------------------------------------------------------------

              eventProvider.loading
                  ? Shimmer.fromColors(
                      baseColor: greyColorShade300,
                      highlightColor: greyColorShade100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, __) => const EventShimmerItem(),
                        itemCount: 10,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async =>
                          await eventProvider.getTodayMeetingEvents(),
                      child: Consumer<HomeProvider>(
                        builder: (context, data, child) {
                          if (data.todayMeetings.isEmpty) {
                            return const EmptyStateWidget(
                              text: 'You currently have no \nmeetings now.',
                            );
                          }
                          if (userType == AppConstants.member) {
                            return ListView.builder(
                                itemCount: data.todayMeetings.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = data.todayMeetings[index];
                                  return todaysEvents(
                                    meetingEventModel: item,
                                  );
                                });
                          }
                          return ListView.builder(
                              itemCount: data.todayMeetings.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = data.todayMeetings[index];

                                return InkWell(
                                  onTap: () {
                                    // set meeting as selected
                                    context
                                        .read<ClockingProvider>()
                                        .setSelectedMeeting(
                                            data.todayMeetings[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ClockingPage(
                                          meetingEventModel:
                                              data.todayMeetings[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: adminTodaysEvents(
                                    meetingEventModel: item,
                                  ),
                                );
                              });
                        },
                      ),
                    ),
              //----------------------------------------------------------------------
              // const SizedBox(
              //   height: 12,
              // ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(defaultRadius),
              //   child: Theme(
              //     data: Theme.of(context)
              //         .copyWith(dividerColor: Colors.transparent),
              //     child: ExpansionTile(
              //       tilePadding: EdgeInsets.zero,
              //       backgroundColor: backgroundColor,
              //       collapsedBackgroundColor: backgroundColor,
              //       initiallyExpanded: true,
              //       title: const Text(
              //         "Upcoming",
              //         style: TextStyle(
              //           color: textColorPrimary,
              //           fontWeight: FontWeight.w600,
              //           fontSize: 19,
              //           fontFamily: "Lato",
              //         ),
              //       ),
              //       children: <Widget>[
              //         SizedBox(
              //           height: MediaQuery.of(context).size.height * 0.3,
              //           width: MediaQuery.of(context).size.width,
              //           child: Consumer<AttendanceProvider>(
              //             builder: (context, data, child) {
              //               if (data.upcomingMeetings.isEmpty) {
              //                 return const EmptyStateWidget(
              //                   text:
              //                       'You currently have no upcoming \nmeetings at the moment!',
              //                 );
              //               }
              //               return ListView.builder(
              //                   itemCount: data.upcomingMeetings.length,
              //                   shrinkWrap: true,
              //                   itemBuilder: (context, index) {
              //                     var item = data.upcomingMeetings[index];
              //                     return upcomingEvents(
              //                       meetingEvent: item,
              //                     );
              //                   });
              //             },
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget adminHeaderView(
      {var firstName, var surName, var userId, var profileImage}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: profileImage != null
                  ? Align(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CustomCachedImageWidget(
                          url: profileImage,
                          height: 130,
                        ),
                      ),
                    )
                  : defaultProfilePic(height: 130),
            ),
            SizedBox(
              height: displayHeight(context) * 0.015,
            ),
            Text(
              "$firstName $surName",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.008,
            ),
            Text(
              userId,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget memberHeaderView(
      {var firstName, var surName, var userId, var profileImage}) {
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
                    : defaultProfilePic(height: 130),
              ),
              SizedBox(
                height: displayHeight(context) * 0.015,
              ),
              Text(
                "$firstName $surName",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              SizedBox(
                height: displayHeight(context) * 0.01,
              ),

              Text(
                "ID: $userId",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              // const SizedBox(
              //   height: 18,
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     const Text(
              //       "Friday Night Duties",
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              //     ),
              //     const SizedBox(
              //       height: 8,
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: const [
              //         Text(
              //           "Date : 17/10/2022",
              //           style: TextStyle(
              //               fontWeight: FontWeight.w500,
              //               color: textColorLight,
              //               fontSize: 14),
              //         ),
              //         Text(
              //           "Span : 2 Days",
              //           style: TextStyle(
              //               fontWeight: FontWeight.w500,
              //               color: textColorLight,
              //               fontSize: 14),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(
              //       height: 2,
              //     ),
              //     const Text(
              //       "Time : 7 am to 5pm",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           color: textColorLight,
              //           fontSize: 14),
              //     ),
              //     const SizedBox(
              //       height: 25,
              //     ),
              //     Align(
              //       alignment: Alignment.centerRight,
              //       child: Container(
              //         decoration: BoxDecoration(
              //             color: Colors.green,
              //             borderRadius: BorderRadius.circular(24)),
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 4, horizontal: 12),
              //         child: const Text(
              //           "Online",
              //           style: TextStyle(fontSize: 13, color: Colors.white),
              //         ),
              //       ),
              //     ),
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(16),
              //       child: Theme(
              //         data: Theme.of(context)
              //             .copyWith(dividerColor: Colors.transparent),
              //         child: ExpansionTile(
              //           backgroundColor: Colors.transparent,
              //           collapsedBackgroundColor: Colors.white,
              //           title: const Text(
              //             "Recent Clocking ",
              //             style: TextStyle(
              //               fontSize: 16.0,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //           children: <Widget>[recentClockDetailsView()],
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget adminHeaderView({var firstName, var surName, var profileImage}) {
  //     return Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       child: Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (_) => const UpdateAccountPage(),
  //                   ),
  //                 );
  //               },
  //               child: profileImage != null
  //                   ? Align(
  //                 child: CustomCachedImageWidget(
  //                   url: profileImage,
  //                   height: 130,
  //                 ),
  //               )
  //                   : defaultProfilePic(height: 130),
  //             ),
  //             Text(
  //               "$firstName $surName",
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //               ),
  //             ),
  //
  //             const SizedBox(
  //               height: 24,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  // }

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
            context, MaterialPageRoute(builder: (_) => const MembersPage(isMemberuser:false)));
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

  Widget todaysEvents({
    required MeetingEventModel meetingEventModel,
  }) {
    var date = DateUtil.formatStringDate(
      DateFormat.yMMMEd(),
      date: DateTime.now(),
    );

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  meetingEventModel.name!,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ),
                              SizedBox(
                                width: displayWidth(context) * 0.02,
                              ),
                              Text(
                                "Span: ${meetingEventModel.meetingSpan} Day(s)",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
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
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(
                                        fontSize: 13, color: textColorLight),
                                  )
                                ],
                              ),
                              Text(
                                meetingEventModel.isRecuring!
                                    ? "Recurring Weekly"
                                    : "Non-Recurring",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.alarm,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    DateUtil.formate12hourTime(
                                        myTime: meetingEventModel.startTime!),
                                    style: const TextStyle(
                                        fontSize: 13, color: textColorLight),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.alarm,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    DateUtil.formate12hourTime(
                                      myTime: meetingEventModel.closeTime!,
                                    ),
                                    style: const TextStyle(
                                        fontSize: 13, color: textColorLight),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )),
                      // CircleAvatar(
                      //   radius: 13,
                      //   backgroundColor: Colors.grey.shade200,
                      //   child: const Icon(
                      //     Icons.chevron_right,
                      //     size: 24,
                      //     color: Colors.orange,
                      //   ),
                      // )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: displayHeight(context) * 0.005,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.alarm,
                          size: 16,
                          color: primaryColor,
                        ),
                        Text(
                          meetingEventModel.inTime == null
                              ? 'CI: N/A'
                              : 'CI: ${DateUtil.formatStringDate(
                                  DateFormat.jm(),
                                  date:
                                      DateTime.parse(meetingEventModel.inTime),
                                ).toLowerCase()}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: textColorLight,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.alarm,
                          size: 16,
                          color: primaryColor,
                        ),
                        Text(
                          meetingEventModel.outTime == null
                              ? 'CO: N/A'
                              : 'CO: ${DateUtil.formatStringDate(
                                  DateFormat.jm(),
                                  date:
                                      DateTime.parse(meetingEventModel.outTime),
                                ).toLowerCase()}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: displayHeight(context) * 0.01,
                ),
                meetingEventModel.hasBreakTime!
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.alarm,
                                size: 16,
                                color: primaryColor,
                              ),
                              Text(
                                meetingEventModel.startBreak == null
                                    ? 'SB: N/A'
                                    : 'SB: ${DateUtil.formatStringDate(
                                        DateFormat.jm(),
                                        date: DateTime.parse(
                                            meetingEventModel.startBreak),
                                      ).toLowerCase()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textColorLight,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.alarm,
                                size: 16,
                                color: primaryColor,
                              ),
                              Text(
                                meetingEventModel.endBreak == null
                                    ? 'EB: N/A'
                                    : 'EB: ${DateUtil.formatStringDate(
                                        DateFormat.jm(),
                                        date: DateTime.parse(
                                            meetingEventModel.endBreak),
                                      ).toLowerCase()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // clock-in or clock-out button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.borderRadius16),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<HomeProvider>(context, listen: false)
                            .setSelectedMeeting(meetingEventModel);

                        if (meetingEventModel.outTime != null) {
                          showInfoDialog(
                            'ok',
                            context: context,
                            title: 'Hey there!',
                            content: 'You\'ve already clocked out. \nGood Bye!',
                            onTap: () => Navigator.pop(context),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: ConfirmDialog(
                                title: meetingEventModel.inOrOut!
                                    ? 'Clock Out'
                                    : 'Clock In',
                                content:
                                    '${meetingEventModel.inOrOut! ? 'Are you sure you want to clock-out?' : 'Are you sure you want to clock-in?'} \nMake sure you are within the meeting premises to continue.',
                                onConfirmTap: () {
                                  Navigator.pop(context);
                                  Provider.of<HomeProvider>(context,
                                          listen: false)
                                      .getMeetingCoordinates(
                                    context: context,
                                    isBreak: false,
                                    meetingEventModel: meetingEventModel,
                                    time: null,
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
                      child: Text(meetingEventModel.inOrOut!
                          ? 'Clock Out'
                          : 'Clock In'),
                    ),

                    // if user has clocked out, there is no need to show 'Start Break' button
                    meetingEventModel.hasBreakTime!
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppRadius.borderRadius16),
                              ),
                            ),
                            onPressed: () {
                              Provider.of<HomeProvider>(context, listen: false)
                                  .setSelectedMeeting(meetingEventModel);

                              if (meetingEventModel.startBreak != null &&
                                  meetingEventModel.endBreak != null) {
                                showInfoDialog(
                                  'ok',
                                  context: context,
                                  title: 'Hey there!',
                                  content:
                                      'You\'ve already ended your break. \nGood Bye!',
                                  onTap: () => Navigator.pop(context),
                                );
                              } else if (meetingEventModel.inTime == null) {
                                showInfoDialog(
                                  'ok',
                                  context: context,
                                  title: 'Hey there!',
                                  content:
                                      'You\'ve to clock-in before starting your break. \nThank you!',
                                  onTap: () => Navigator.pop(context),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title: (meetingEventModel.startBreak ==
                                                  null &&
                                              meetingEventModel.endBreak ==
                                                  null)
                                          ? 'Start Break'
                                          : 'End Break',
                                      content: (meetingEventModel.startBreak ==
                                                  null &&
                                              meetingEventModel.endBreak ==
                                                  null)
                                          ? 'Are you sure you want to start your break? \nMake sure you are within the meeting premises to continue.'
                                          : 'Are you sure you want to end your break? \nMake sure you are within the meeting premises to continue.',
                                      //'${meeting.startBreak != null ? 'Are you sure you want to end?' : 'Are you sure you want to clock-in?'} \nMake sure you\'re closer to the premise of the meeting or event to continue.',
                                      onConfirmTap: () {
                                        Navigator.pop(context);
                                        Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .getMeetingCoordinates(
                                          context: context,
                                          isBreak: true,
                                          time: null,
                                          meetingEventModel: meetingEventModel,
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
                              (meetingEventModel.startBreak == null &&
                                      meetingEventModel.endBreak == null)
                                  ? 'Start Break'
                                  : 'End Break',
                            ),
                          )
                        : (meetingEventModel.hasBreakTime! &&
                                meetingEventModel.inTime == null)
                            ? const SizedBox()
                            : const SizedBox()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppRadius.borderRadius16),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<HomeProvider>(context, listen: false)
                                .setSelectedMeeting(meetingEventModel);
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
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //       primary: Colors.red,
                    //     elevation: 0.0,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(23))),
                    //   onPressed: () {
                    //     // set meeting as selected
                    //     context
                    //         .read<AttendanceProvider>()
                    //         .setSelectedMeeting(meetingEventModel);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => ExcuseInputPage(),
                    //       ),
                    //     );
                    //   },
                    //   child: const Text("Excuse"),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget adminTodaysEvents({
    required MeetingEventModel meetingEventModel,
  }) {
    var date = DateUtil.formatStringDate(
      DateFormat.yMMMEd(),
      date: DateTime.now(),
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  meetingEventModel.name!,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ),
                              SizedBox(
                                width: displayWidth(context) * 0.02,
                              ),
                              Text(
                                "Span: ${meetingEventModel.meetingSpan} Day(s)",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
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
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(
                                        fontSize: 13, color: textColorLight),
                                  )
                                ],
                              ),
                              Text(
                                meetingEventModel.isRecuring!
                                    ? "Recurring Weekly "
                                    : "Non-Recurring",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      DateUtil.formate12hourTime(
                                          myTime: meetingEventModel.startTime!),
                                      style: const TextStyle(
                                          fontSize: 13, color: textColorLight),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.alarm,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    DateUtil.formate12hourTime(
                                        myTime: meetingEventModel.closeTime!),
                                    style: const TextStyle(
                                        fontSize: 13, color: textColorLight),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget upcomingEvents({
    required MeetingEventModel meetingEvent,
  }) {
    return MeetingEventWidget(
      meetingEventModel: meetingEvent,
    );
  }
}
