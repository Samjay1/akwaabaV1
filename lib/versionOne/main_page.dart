import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/dialogs_modals/contact_admin_dialog.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/versionOne/alerts_page.dart';
import 'package:akwaaba/versionOne/attendance_history_page.dart';
import 'package:akwaaba/versionOne/device_activation_request_page.dart';
import 'package:akwaaba/versionOne/home_page.dart';
import 'package:akwaaba/versionOne/login_page.dart';
import 'package:akwaaba/versionOne/all_events_page.dart';
import 'package:akwaaba/screens/akwaaba_modules.dart';
import 'package:akwaaba/screens/web_admin_setup_page.dart';
import 'package:akwaaba/versionOne/member_account_page.dart';
import 'package:akwaaba/versionOne/member_registration_page_individual.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/members_page.dart';
import 'package:akwaaba/versionOne/my_account_page.dart';
import 'package:akwaaba/versionOne/post_clocking_page.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_cached_image_widget.dart';
import '../utils/shared_prefs.dart';
import '../versionOne/attendance_report_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map> bottomNavItems = [
    {"title": "Home", "icon_data": CupertinoIcons.home},
    {"title": "Events", "icon_data": Icons.calendar_month_outlined},
    {"title": "Post Clocking", "icon_data": CupertinoIcons.alarm},
    // {"title":"More","icon_data":Icons.menu},
  ];

  List<Map> bottomNavItemsFiled = [
    {"title": "Home", "icon_data": CupertinoIcons.house_alt_fill},
    {"title": "Events", "icon_data": Icons.calendar_month},
    {"title": "Post Clocking", "icon_data": CupertinoIcons.alarm_fill},
    // {"title":"More","icon_data":Icons.menu},
  ];

  // List<Map> bottomNavItems = [];
  // List<Map> bottomNavItemsFiled = [];

  // List<Map> bottomNavItemsFiled = [
  //   {"title": "Home", "icon_data": CupertinoIcons.house_alt_fill},
  //   {"title": "Events", "icon_data": Icons.calendar_month},
  //   {"title": "Clocking", "icon_data": CupertinoIcons.alarm_fill},
  //   // {"title":"More","icon_data":Icons.menu},
  // ];

  int _selectedBottomNavIndex = 0;

  final List<Widget> children = [
    const HomePage(),
    const AllEventsPage(),
    const PostClockingPage(), //only show this if user is an admin
    // const MorePage()
  ];

  String userType = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initFunctions();
      },
    );
  }

  initFunctions() async {
    //get user type and show the required bottom nav pages
    //based on the user type, call the provider function to set the user profile info
    //to what has been saved on shared prefs, on the home page, another provider function
    //will call the login api to get the current user profile info

    //userType =(await SharedPrefs().getUserType())!;

    SharedPrefs().getUserType().then((value) {
      debugPrint("User type from main page $value");
      setState(() {
        userType = value!;

        if (userType.isNotEmpty) {
          if (userType.compareTo("member") == 0) {
            bottomNavItems.removeAt(2);
            bottomNavItemsFiled.removeAt(2);
            children.removeAt(2);

            SharedPrefs().getMemberProfile().then((value) {
              Provider.of<MemberProvider>(context, listen: false)
                  .setMemberProfileInfo(memberProfile: value!);
            });
            // bottomNavItems = [
            //   {"title": "Home", "icon_data": CupertinoIcons.home},
            //   {"title": "Events", "icon_data": Icons.calendar_month_outlined},
            //   // {"title":"More","icon_data":Icons.menu},
            // ];
            // bottomNavItemsFiled = [
            //   {"title": "Home", "icon_data": CupertinoIcons.house_alt_fill},
            //   {"title": "Events", "icon_data": Icons.calendar_month},
            //   // {"title":"More","icon_data":Icons.menu},
            // ];
          } else if (userType.compareTo("admin") == 0) {
            SharedPrefs().getAdminProfile().then((value) {
              Provider.of<ClientProvider>(context, listen: false)
                  .setAdminProfileInfo(
                adminProfile: value!,
              );
            });
            // bottomNavItems = [
            //   {"title": "Home", "icon_data": CupertinoIcons.home},
            //   {"title": "Events", "icon_data": Icons.calendar_month_outlined},
            //   {"title": "Post Clocking", "icon_data": CupertinoIcons.alarm},
            //   // {"title":"More","icon_data":Icons.menu},
            // ];
            // bottomNavItemsFiled = [
            //   {"title": "Home", "icon_data": CupertinoIcons.house_alt_fill},
            //   {"title": "Events", "icon_data": Icons.calendar_month},
            //   {
            //     "title": "Post Clocking",
            //     "icon_data": CupertinoIcons.alarm_fill
            //   },
            //   // {"title":"More","icon_data":Icons.menu},
            // ];
          }

          // SharedPrefs().getMemberProfile().then((value) {
          //   if(value!=null){
          //
          //   }
          // })
          //MemberProfile? memberProfile =  await SharedPrefs().getMemberProfile();

          // debugPrint("member profile ${memberProfile!.toJson()} ");

          // if(memberProfile!=null){
          //
          //   if(userType.compareTo("member")==0){
          //     Provider.of<MemberProvider>(context,listen: false)
          //         .setMemberProfileInfo(memberProfile: memberProfile);
          //
          //   }else if(userType.compareTo("admin")==0){
          //     bottomNavItems.removeAt(2);
          //     bottomNavItemsFiled.removeAt(2);
          //     children.removeAt(2);
          //   }
          // }

        } else {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MemberProvider>(context, listen: false).gettingDeviceInfo();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          _selectedBottomNavIndex == 0
              ? "AKWAABA"
              : _selectedBottomNavIndex == 1
                  ? "All Events & Meetings"
                  : _selectedBottomNavIndex == 2
                      ? "Post Clocking"
                      : "More",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AlertsPage()));
                },
                icon: Icon(Icons.notifications),
                tooltip: 'hello',
                isSelected: true,
              ),
              Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      '3',
                      style: TextStyle(fontSize: 14),
                    ),
                  ))
            ],
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      drawer: userType == 'admin'
          ? Consumer<ClientProvider>(
              builder: (context, data, child) {
                return adminDrawerView(
                  logo: data.getUser?.logo,
                  name: data.getUser?.name,
                  branch: data.branch?.name,
                  id: data.getUser?.id,
                );
              },
            )
          : Consumer<MemberProvider>(
              builder: (context, data, child) {
                return memberDrawerView(
                  clientAccountInfo: data.clientAccountInfo,
                  branch: data.branch?.name,
                );
              },
            ),
      // drawerView(logo:logo, applicantFirstname:applicantFirstname, applicantSurname:applicantSurname),
      bottomNavigationBar: bottomNavigationView(),
      body: Center(
        child: children[_selectedBottomNavIndex],
      ),
    );
  }

  Widget adminDrawerView({var logo, var name, var id, var branch}) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CustomCachedImageWidget(
                      url: logo ?? "",
                      height: 110,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "${name ?? ""}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "(${branch ?? ""})",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: Consumer<GeneralProvider>(
                  builder: (context, data, child) {
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        drawerItemView(
                          title: "Profile Page",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyAccountPage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                            title: "View Members",
                            iconData: Icons.phone_android,
                            function: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'View all Members/Organisations',
                                    content:
                                        'Select the Clients you want to view',
                                    onConfirmTap: () {
                                      Navigator.pop(context); //close the popup
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MembersPage(
                                              isMemberuser: true),
                                        ),
                                      );
                                    },
                                    onCancelTap: () {
                                      Navigator.pop(context); //close the popup
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MembersPage(
                                              isMemberuser: false),
                                        ),
                                      );
                                    },
                                    confirmText: 'Members',
                                    cancelText: 'Organisations',
                                  ),
                                ),
                              );
                            }),
                        drawerItemView(
                          title: "Create Meetings/Event",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const WebViewPage(
                                        url: AppConstants.createMeetingUrl,
                                        title: 'Create Meetings')));
                          },
                        ),
                        drawerItemView(
                          title: "Update Meetings/Event",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const WebViewPage(
                                        url: AppConstants.updateMeetingUrl,
                                        title: 'Update Meetings')));
                          },
                        ),
                        drawerItemView(
                          title: "Attendance History",
                          iconData: Icons.history,
                          function: () {
                            Navigator.pop(context); //close the drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AttendanceHistoryPage(),
                              ),
                            );
                          },
                          index: 8,
                        ),
                        drawerItemView(
                          title: "Attendance Report",
                          iconData: Icons.bar_chart,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AttendanceReportPage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Assign Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.assignLeaveUrl,
                                    title: 'Assign Leave/Excuse'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "View Assigned Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.viewLeaveUrl,
                                    title: 'View Assigned Leave/Excuse'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Approve Device Request",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.deviceRequestUrl,
                                    title: 'Approve Device Request'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Follow-Up Report",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.followUpReportUrl,
                                  title: 'Follow-Up Report',
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 0, color: Colors.grey),
                            ),
                          ),
                          child: ExpansionTile(
                            title: const Text(
                              'Akwaaba Modules',
                              style: TextStyle(fontSize: 16),
                            ),
                            iconColor: blackColor,
                            collapsedIconColor: blackColor,
                            collapsedTextColor: blackColor,
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 26),
                            children: [
                              drawerItemView(
                                title: "Database Manager",
                                iconData: Icons.phone_android,
                                function: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WebViewPage(
                                        url: AppConstants.databaseManagerUrl,
                                        title: 'Database Manager',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              drawerItemView(
                                title: "Attendance Manager",
                                iconData: Icons.phone_android,
                                function: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WebViewPage(
                                        url: AppConstants.databaseManagerUrl,
                                        title: 'Attendance Manager',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              drawerItemView(
                                title: "Cash Manager",
                                iconData: Icons.phone_android,
                                function: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WebViewPage(
                                        url: AppConstants.cashManagerUrl,
                                        title: 'Cash Manager',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              drawerItemView(
                                title: "Akwaaba Messenger",
                                iconData: Icons.phone_android,
                                function: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WebViewPage(
                                        url: AppConstants.akwaabaMessengerUrl,
                                        title: 'Akwaaba Messenger',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              drawerItemView(
                                title: "School Manager",
                                iconData: Icons.phone_android,
                                function: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WebViewPage(
                                        url: AppConstants.akwaabaEduUrl,
                                        title: 'School Manager',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        drawerItemView(
                            title: "Log out",
                            iconData: Icons.logout_rounded,
                            function: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'Logout',
                                    content:
                                        'Do you really want to logout? \n\nWe appreciate your time and can\'t wait to have you back!',
                                    onConfirmTap: () async {
                                      Navigator.pop(context); //close the popup
                                      SharedPrefs().logout(context);
                                    },
                                    onCancelTap: () => Navigator.pop(context),
                                    confirmText: 'Confirm',
                                    cancelText: 'Cancel',
                                  ),
                                ),
                              );
                            },
                            index: 21),
                      ],
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget memberDrawerView({
    required ClientAccountInfo clientAccountInfo,
    required String branch,
  }) {
    var phone = clientAccountInfo.countryInfo == null
        ? formattedPhone('+233', clientAccountInfo.applicantPhone!)
        : formattedPhone(clientAccountInfo.countryInfo![0].code!,
            clientAccountInfo.applicantPhone!);
    debugPrint("Phone: $phone");
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CustomCachedImageWidget(
                    url: clientAccountInfo.logo ?? "",
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  clientAccountInfo.name ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: displayHeight(context) * 0.01,
                ),
                Text(
                  "($branch)",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: Consumer<GeneralProvider>(
                  builder: (context, data, child) {
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        drawerItemView(
                            title: "View Members",
                            iconData: Icons.phone_android,
                            function: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'View all Members/Organisations',
                                    content:
                                        'Select the Clients you want to view',
                                    onConfirmTap: () {
                                      Navigator.pop(context); //close the popup
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MembersPage(
                                              isMemberuser: true),
                                        ),
                                      );
                                    },
                                    onCancelTap: () {
                                      Navigator.pop(context); //close the popup
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MembersPage(
                                              isMemberuser: false),
                                        ),
                                      );
                                    },
                                    confirmText: 'Members',
                                    cancelText: 'Organisations',
                                  ),
                                ),
                              );
                            }),
                        drawerItemView(
                          title: "Update Profile",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MemberAccountPage(
                                  member: null,
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Apply Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.applyLeaveUrl,
                                  title: 'Apply Leave/Excuse',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "View Leave/Absent Status ",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.viewLeaveStatusUrl,
                                  title: 'View Leave/Absent Status',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Attendance Report",
                          iconData: Icons.bar_chart,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const AttendanceReportPage()));
                          },
                        ),
                        drawerItemView(
                          title: "Attendance History",
                          iconData: Icons.history,
                          function: () {
                            Navigator.pop(context); //close the drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AttendanceHistoryPage(),
                              ),
                            );
                          },
                          index: 8,
                        ),
                        drawerItemView(
                          title: "Request Device Activation",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DeviceActivationRequestPage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Akwaaba Messenger",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.akwaabaMessengerUrl,
                                    title: 'Akwaaba Messenger'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Make Payment",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.akwaabaPaymentUrl,
                                    title: 'Make Payment'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Student Account",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                    url: AppConstants.akwaabaEduUrl,
                                    title: 'Student Account'),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Contact Admin",
                          iconData: Icons.phone_android,
                          function: () {
                            Navigator.pop(context);
                            //TODO: show popup with call and whatsapp buttons
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        AppRadius.borderRadius16),
                                    topRight: Radius.circular(
                                        AppRadius.borderRadius16),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return ContactAdminDialog(
                                      title: 'Are you experiencing issues?',
                                      subtitle:
                                          'You can reach out to your admin on',
                                      firstText: 'Call',
                                      secondText: 'Whatsapp',
                                      onCallTap: () {
                                        Navigator.of(context).pop();
                                        makePhoneCall(phone);
                                      },
                                      onWhatsappTap: () async {
                                        Navigator.of(context).pop();
                                        openWhatsapp(
                                          context,
                                          phone,
                                          'Hello ${clientAccountInfo.name}, \n\nI\'m experiencing an issue and I need an assistance.',
                                        );
                                      });
                                });
                          },
                        ),
                        drawerItemView(
                            title: "Log out",
                            iconData: Icons.logout_rounded,
                            function: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'Logout',
                                    content:
                                        'Do you really want to logout? \n\nWe appreciate your time and can\'t wait to have you back!',
                                    onConfirmTap: () {
                                      Navigator.pop(context); //close the popup
                                      SharedPrefs().logout(context);
                                    },
                                    onCancelTap: () => Navigator.pop(context),
                                    confirmText: 'Confirm',
                                    cancelText: 'Cancel',
                                  ),
                                ),
                              );
                            },
                            index: 21),
                      ],
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationView() {
    return Consumer<GeneralProvider>(builder: (context, data, child) {
      return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedBottomNavIndex,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            setState(() => _selectedBottomNavIndex = value);
          },
          items: List.generate(bottomNavItems.length, (index) {
            return
                // index==2&& data.userIsAdmin?
                // null:
                BottomNavigationBarItem(
              icon: Icon(_selectedBottomNavIndex == index
                  ? bottomNavItemsFiled[index]["icon_data"]
                  : bottomNavItems[index]["icon_data"]),
              label: bottomNavItems[index]["title"],
            );
          }));
    });
  }

  Widget drawerItemView(
      {required String title,
      required IconData iconData,
      required VoidCallback function,
      int? index}) {
    //index is not relevant, you can ignore it
    return InkWell(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0, color: Colors.grey),
          ),
        ),
        child: Row(
          children: [
            //Icon(iconData,color: primaryColor,),
            const SizedBox(
              width: 12,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }

  drawerItemTapped(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        //register member
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const MemberRegistrationPageIndividual(),
        //   ),
        // );
        break;
      case 1:
        //verify member
        requestClientAccountSetup();

        break;
      case 2:
        //member profile
        requestClientAccountSetup();
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const WebAdminSetupPage()));
        break;
      case 4:
        //set up web admin menus
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AkwaabaModules()));

        break;
      case 8:
        //view members
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const MembersPage(
                      isMemberuser: true,
                    )));

        break;
      case 21:
        //log out
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  requestClientAccountSetup() {
    displayCustomCupertinoDialog(
        context: context,
        title: "Hi User",
        msg: "Would you like to setup your client account",
        actionsMap: {
          "Later": () {
            Navigator.pop(context);
          },
          "Yes": () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const WebAdminSetupPage()));
          }
        });
  }
}
