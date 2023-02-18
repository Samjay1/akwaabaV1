import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/components/tag_widget_solid.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/dialogs_modals/contact_admin_dialog.dart';
import 'package:akwaaba/dialogs_modals/renewal_dialog.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/profile_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/versionOne/alerts_page.dart';
import 'package:akwaaba/versionOne/apply_leave_page.dart';
import 'package:akwaaba/versionOne/attendance_history_page.dart';
import 'package:akwaaba/versionOne/device_activation_request_page.dart';
import 'package:akwaaba/versionOne/home_page.dart';
import 'package:akwaaba/versionOne/login_page.dart';
import 'package:akwaaba/versionOne/all_events_page.dart';
import 'package:akwaaba/screens/akwaaba_modules.dart';
import 'package:akwaaba/screens/web_admin_setup_page.dart';
import 'package:akwaaba/versionOne/member_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/members_page.dart';
import 'package:akwaaba/versionOne/my_account_page.dart';
import 'package:akwaaba/versionOne/post_clocking_page.dart';
import 'package:akwaaba/versionOne/view_leave_page.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_cached_image_widget.dart';
import '../utils/restriction_util.dart';
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

  late MemberProvider _memberProvider;

  final List<Widget> children = [
    const HomePage(),
    const AllEventsPage(),
    const PostClockingPage(), //only show this if user is an admin
    // const MorePage()
  ];

  String userType = "";

  String? token;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ClientAccountInfo? clientAccountInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initFunctions();
      },
    );
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  // checks if account has expired and take appropriate action to log out user
  logoutUserIfAccountExpired() {
    DateTime? expiryDate;
    if (userType == AppConstants.admin) {
      clientAccountInfo =
          Provider.of<ClientProvider>(context, listen: false).getUser;
      if (clientAccountInfo!.subscriptionInfo != null) {
        if (clientAccountInfo!.subscriptionInfo!.subscribedModules!.module1 !=
                null &&
            clientAccountInfo!.subscriptionInfo!.subscribedModules!.module3 !=
                null) {
          // expiryDate = DateTime.parse(clientAccountInfo!
          //     .subscriptionInfo!.subscribedModules!.module3!.expiresOn!);
          expiryDate = DateFormat('dd-MM-yyyy').parse(clientAccountInfo!
              .subscriptionInfo!.subscribedModules!.module3!.expiresOn!);
        }

        // show dialog if client account has expired
        if (expiryDate != null) {
          if (DateTime.now().isAtSameMomentAs(expiryDate) ||
              DateTime.now().isAfter(expiryDate)) {
            showAppAccessDialog(
              'ok',
              dismissible: false,
              context: context,
              title: 'Hey there!',
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  const TextSpan(
                    text:
                        "Sorry you don't have access to the services of this app. It's either you've not subscribe to the Android & iOS Module or your account has expired.",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: blackColor,
                      fontSize: AppSize.s18,
                    ),
                  ),
                  TextSpan(
                      text: 'Renew!',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        letterSpacing: 1.0,
                        color: Colors.blue,
                        fontSize: AppSize.s18,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          var url =
                              await AppConstants.renewAccountRedirectUrl();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WebViewPage(
                                url: url,
                                title: 'Make Payment',
                              ),
                            ),
                          );
                        }),
                ]),
              ),
              onTap: logout,
            );
          }
        }

        // Restrict access to app if client has subscribed to only database and attendance
        // if (clientAccountInfo!.subscriptionInfo!.subscribedModules!.module1 != null &&
        //     clientAccountInfo!.subscriptionInfo!.subscribedModules!.module2 !=
        //         null &&
        //     clientAccountInfo!.subscriptionInfo!.subscribedModules!.module3 ==
        //         null) {
        //   showAppAccessDialog(
        //     'ok',
        //     dismissible: false,
        //     context: context,
        //     title: 'Hey there!',
        //     content: RichText(
        //       textAlign: TextAlign.center,
        //       text: TextSpan(children: [
        //         const TextSpan(
        //           text:
        //               'Sorry you don\'t have access to the services of this app, you must subscribe to the android & iOS module.\n\nCall/WhatsApp Service Provider on ',
        //           style: TextStyle(
        //             letterSpacing: 1.0,
        //             color: blackColor,
        //             fontSize: AppSize.s18,
        //           ),
        //         ),
        //         TextSpan(
        //           text: AppConstants.supportNumber,
        //           style: const TextStyle(
        //             letterSpacing: 1.0,
        //             decoration: TextDecoration.underline,
        //             color: Colors.blue,
        //             fontSize: AppSize.s18,
        //           ),
        //           recognizer: TapGestureRecognizer()
        //             ..onTap = () {
        //               showModalBottomSheet(
        //                   shape: const RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.only(
        //                       topLeft:
        //                           Radius.circular(AppRadius.borderRadius16),
        //                       topRight:
        //                           Radius.circular(AppRadius.borderRadius16),
        //                     ),
        //                   ),
        //                   context: context,
        //                   builder: (context) {
        //                     return ContactAdminDialog(
        //                         title: 'Contact your service provider?',
        //                         subtitle:
        //                             'You can reach out to your service provider on',
        //                         firstText: 'Call',
        //                         secondText: 'Whatsapp',
        //                         onCallTap: () {
        //                           Navigator.of(context).pop();
        //                           makePhoneCall(
        //                             AppConstants.supportNumber,
        //                           );
        //                         },
        //                         onWhatsappTap: () async {
        //                           Navigator.of(context).pop();
        //                           openWhatsapp(
        //                             context,
        //                             AppConstants.supportNumber,
        //                             'Hello there, \n\nI need assistance with my account.',
        //                           );
        //                         });
        //                   });
        //             },
        //         ),
        //         const TextSpan(
        //           text: ' for any assistance.',
        //           style: TextStyle(
        //             letterSpacing: 1.0,
        //             color: blackColor,
        //             fontSize: AppSize.s18,
        //           ),
        //         ),
        //       ]),
        //     ),
        //     onTap: logout,
        //   );
        // }

        // Restrict access to app if client has subscribed to only database
        if (clientAccountInfo!.subscriptionInfo!.subscribedModules!.module1 != null &&
            clientAccountInfo!.subscriptionInfo!.subscribedModules!.module2 ==
                null &&
            clientAccountInfo!.subscriptionInfo!.subscribedModules!.module3 ==
                null) {
          showAppAccessDialog(
            'ok',
            dismissible: false,
            context: context,
            title: 'Hey there!',
            content: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: [
                TextSpan(
                  text:
                      'Sorry you don\'t have access to the attendance and android & iOS services, you must subscribe to the attendance and android & iOS module.',
                  style: TextStyle(
                    letterSpacing: 1.0,
                    color: blackColor,
                    fontSize: AppSize.s18,
                  ),
                ),
              ]),
            ),
            onTap: logout,
          );
        }
      }
    } else {
      if (_memberProvider.assignedFee != null &&
          _memberProvider.assignedFee!.endDate != null) {
        expiryDate = DateFormat('yyyy-MM-dd').parse(
          _memberProvider.assignedFee!.endDate!,
        );
        // show expiry dialog for member assigned to an invoice
        if (expiryDate != null) {
          if (DateTime.now().isAtSameMomentAs(expiryDate) ||
              DateTime.now().isAfter(expiryDate)) {
            showAppAccessDialog(
              'ok',
              dismissible: false,
              context: context,
              title: 'Hey there!',
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  const TextSpan(
                    text:
                        'Sorry you don\'t have access to the services of this app. Your account has expired. ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: blackColor,
                      fontSize: AppSize.s18,
                    ),
                  ),
                  TextSpan(
                    text: 'Renew!',
                    style: const TextStyle(
                      letterSpacing: 1.0,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: AppSize.s18,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WebViewPage(
                              url: AppConstants.akwaabaPaymentUrl,
                              title: 'Make Payment',
                            ),
                          ),
                        );
                      },
                  ),
                ]),
              ),
              onTap: logout,
            );
          }
        }
      } else {
        // check if user is not a subscriber or not assigned an invoice
        clientAccountInfo = Provider.of<MemberProvider>(context, listen: false)
            .clientAccountInfo;
        if (clientAccountInfo != null &&
            clientAccountInfo!.subscriptionInfo != null) {
          expiryDate = DateTime.parse(
            clientAccountInfo!
                .subscriptionInfo!.subscribedModules!.module1!.expiresOn!,
          );

          /// user is assigned an invoice
          // Restrict access to app if member has subscribed to only database and attendance
          // if (clientAccountInfo!.subscriptionInfo!.subscribedModules!.module1 != null &&
          //     clientAccountInfo!.subscriptionInfo!.subscribedModules!.module2 !=
          //         null &&
          //     clientAccountInfo!.subscriptionInfo!.subscribedModules!.module3 ==
          //         null) {
          //   showAppAccessDialog(
          //     'ok',
          //     dismissible: false,
          //     context: context,
          //     title: 'Hey there!',
          //     content: RichText(
          //       textAlign: TextAlign.center,
          //       text: const TextSpan(children: [
          //         TextSpan(
          //           text:
          //               'Sorry you don\'t have access to the services of this app, please contact admin for assistance.',
          //           style: TextStyle(
          //             letterSpacing: 1.0,
          //             color: blackColor,
          //             fontSize: AppSize.s18,
          //           ),
          //         ),
          //       ]),
          //     ),
          //     onTap: logout,
          //   );
          // }

          // Restrict access to app if member has subscribed to only database
          if (clientAccountInfo!.subscriptionInfo!.subscribedModules!.module1 != null &&
              clientAccountInfo!.subscriptionInfo!.subscribedModules!.module2 ==
                  null &&
              clientAccountInfo!.subscriptionInfo!.subscribedModules!.module3 ==
                  null) {
            showAppAccessDialog(
              'ok',
              dismissible: false,
              context: context,
              title: 'Hey there!',
              content: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                    text:
                        'Sorry you don\'t have access to the attendance and android & iOS services, please contact admin for assistance.',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: blackColor,
                      fontSize: AppSize.s18,
                    ),
                  ),
                ]),
              ),
              onTap: logout,
            );
          }
        }
      }
      // show expiry dialog for member assigned to an invoice
      if (expiryDate != null) {
        if (DateTime.now().isAtSameMomentAs(expiryDate) ||
            DateTime.now().isAfter(expiryDate)) {
          showAppAccessDialog(
            'ok',
            dismissible: false,
            context: context,
            title: 'Hey there!',
            content: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: [
                TextSpan(
                  text:
                      'Sorry, this account has expired, contact admin for assistance.',
                  style: TextStyle(
                    letterSpacing: 1.0,
                    color: blackColor,
                    fontSize: AppSize.s18,
                  ),
                ),
              ]),
            ),
            onTap: logout,
          );
        }
      }
    }
    //DateTime? expiryDate;
  }

  void logout() {
    Navigator.pop(context);
    SharedPrefs().logout(context);
  }

  initFunctions() async {
    //get user type and show the required bottom nav pages
    //based on the user type, call the provider function to set the user profile info
    //to what has been saved on shared prefs, on the home page, another provider function
    //will call the login api to get the current user profile info

    //userType =(await SharedPrefs().getUserType())!;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

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
          } else if (userType.compareTo("admin") == 0) {
            SharedPrefs().getAdminProfile().then((value) {
              Provider.of<ClientProvider>(context, listen: false)
                  .setAdminProfileInfo(
                adminProfile: value!,
              );
            });
          }
          logoutUserIfAccountExpired();
        } else {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _memberProvider = context.watch<MemberProvider>();
    Provider.of<MemberProvider>(context, listen: false).gettingDeviceInfo();
    return Scaffold(
      key: _scaffoldKey,
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
        // actions: [
        //   Stack(
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (_) => const AlertsPage()));
        //         },
        //         icon: const Icon(Icons.notifications),
        //         tooltip: 'hello',
        //         isSelected: true,
        //       ),
        //       Positioned(
        //           right: 5,
        //           top: 5,
        //           child: Container(
        //             padding: const EdgeInsets.symmetric(horizontal: 5),
        //             decoration: BoxDecoration(
        //                 color: Colors.black,
        //                 border: Border.all(color: Colors.orange),
        //                 borderRadius: BorderRadius.circular(100)),
        //             child: const Text(
        //               '3',
        //               style: TextStyle(fontSize: 14),
        //             ),
        //           ))
        //     ],
        //   ),
        //   const SizedBox(
        //     width: 5,
        //   ),
        // ],
      ),
      drawer: userType == 'admin'
          ? Consumer<ClientProvider>(
              builder: (context, data, child) {
                return adminDrawerView(
                  context: context,
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

  Widget adminDrawerView({context, var logo, var name, var id, var branch}) {
    return Drawer(
      backgroundColor: whiteColor,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 185,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
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
                  height: 10,
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

          Consumer<ClientProvider>(
            builder: (context, data, child) {
              DateTime? expiryDate;
              if (data.getUser.subscriptionInfo != null) {
                if (data.getUser.subscriptionInfo.subscribedModules.module1 !=
                    null) {
                  expiryDate = DateTime.parse(data.getUser.subscriptionInfo
                      .subscribedModules.module1.expiresOn!);
                  // expiryDate = DateFormat('dd-MM-yyyy').parse(
                  //   data.getUser.subscriptionInfo.subscribedModules.module1
                  //       .expiresOn!,
                  // );
                }
              }
              return data.getUser.subscriptionInfo != null
                  ? Container(
                      margin: const EdgeInsets.all(AppPadding.p8),
                      padding: const EdgeInsets.all(AppPadding.p12),
                      decoration: BoxDecoration(
                          color: fillColor.withOpacity(0.6),
                          borderRadius:
                              BorderRadius.circular(AppRadius.borderRadius8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your Account Expires In: ${DateUtil.convertToFutureTimeAgo(date: expiryDate!)}",
                            style: const TextStyle(
                              fontSize: AppSize.s15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.01,
                          ),
                          TagWidgetSolid(
                            text: isActive(expiryDate) ? 'Active' : 'Expired',
                            color: isActive(expiryDate) ? greenColor : redColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            },
          ),
          // subscription info

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
                                    title: 'Select an option:',
                                    content: '',
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
                              //toggleDrawer();
                            }),
                        drawerItemView(
                          title: "Verify New Member",
                          iconData: Icons.phone_android,
                          function: () async {
                            var url =
                                await AppConstants.verifyNewMemberRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Verify New Member',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Verify New Organization",
                          iconData: Icons.phone_android,
                          function: () async {
                            var url =
                                await AppConstants.verifyNewOrgRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Verify New Organization',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Create Meetings/Event",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            var url =
                                await AppConstants.createMeetingRedirectUrl();

                            toggleDrawer();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Create Meetings',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Update Meetings/Event",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            var url =
                                await AppConstants.updateMeetingRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Update Meetings',
                                ),
                              ),
                            );
                          },
                        ),

                        drawerItemView(
                          title: "Add Admin User",
                          iconData: Icons.phone_android,
                          function: () async {
                            var url =
                                await AppConstants.addAdminUserRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Add Admin User',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Register Connection",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.akwaabaConnectUrl,
                                  title: 'Register Connection',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Akwaaba Forms",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.adminFormUrl,
                                  title: 'Akwaaba Forms',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Attendance Report",
                          iconData: Icons.bar_chart,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AttendanceReportPage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Attendance History",
                          iconData: Icons.history,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
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
                          title: "Assign Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!hasAttendance) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            var url =
                                await AppConstants.assignLeaveRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Assign Leave/Excuse',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "View Assigned Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            var url = await AppConstants.viewLeaveRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'View Assigned Leave/Excuse',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Approve Device Request",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            var url = await AppConstants
                                .approveDeviceRequestRedirectUrl();
                            if (!mounted) return;
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Approve Device Request',
                                ),
                              ),
                            );
                          },
                        ),
                        // drawerItemView(
                        //   title: "Follow-Up Report",
                        //   iconData: Icons.phone_android,
                        //   function: () async {
                        //     var url =
                        //         await AppConstants.followUpReportRedirectUrl();
                        //     if (!mounted) return;
                        //     Navigator.pop(context);
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => WebViewPage(
                        //           url: url,
                        //           title: 'Follow-Up Report',
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
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
                                  toggleDrawer();
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
                                  toggleDrawer();
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
                                  toggleDrawer();
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
                                  toggleDrawer();
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
                                  toggleDrawer();
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
                          title: "Renew My Account",
                          iconData: Icons.phone_android,
                          function: () async {
                            var url =
                                await AppConstants.renewAccountRedirectUrl();
                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebViewPage(
                                  url: url,
                                  title: 'Renew My Account',
                                ),
                              ),
                            );
                          },
                        ),

                        drawerItemView(
                          title: "Tutorial Hub",
                          iconData: Icons.phone_android,
                          function: () async {
                            Navigator.pop(context);
                            launchURL(AppConstants.adminTutorialUrl);
                          },
                        ),
                        // drawerItemView(
                        //   title: "My Account",
                        //   iconData: Icons.phone_android,
                        //   function: () {
                        //     toggleDrawer();
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => const MyAccountPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
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
                                    onConfirmTap: () => logout(),
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

    DateTime? expiryDate;

    if (_memberProvider.assignedFee != null &&
        _memberProvider.assignedFee!.endDate != null) {
      expiryDate =
          DateFormat('yyyy-MM-dd').parse(_memberProvider.assignedFee!.endDate!);
    }

    debugPrint("Phone: $phone");
    return Drawer(
      backgroundColor: whiteColor,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 185,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomCachedImageWidget(
                    url: clientAccountInfo.logo ?? "",
                    height: 100,
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.01,
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
                  height: displayHeight(context) * 0.008,
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
          // subscription info
          _memberProvider.assignedFee == null
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.all(AppPadding.p8),
                  padding: const EdgeInsets.all(AppPadding.p12),
                  decoration: BoxDecoration(
                      color: fillColor.withOpacity(0.6),
                      borderRadius:
                          BorderRadius.circular(AppRadius.borderRadius8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Total Assigned Bill Is: GHS ${_memberProvider.assignedFee!.totalInvoice}",
                        style: const TextStyle(
                          fontSize: AppSize.s15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.01,
                      ),
                      Text(
                        "Your Outstanding Bill Is: GHS ${_memberProvider.bill ?? 'N/A'}",
                        //"Your Outstanding Bill Is: GHS ${memberProvider.bill}",
                        style: const TextStyle(
                          fontSize: AppSize.s15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.01,
                      ),
                      expiryDate == null
                          ? const SizedBox()
                          : Text(
                              "Your Account Expires In: ${DateUtil.convertToFutureTimeAgo(date: expiryDate)}",
                              style: const TextStyle(
                                fontSize: AppSize.s15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                      SizedBox(
                        height: displayHeight(context) * 0.01,
                      ),
                      TagWidgetSolid(
                        text: expiryDate == null
                            ? 'Active'
                            : isActive(expiryDate)
                                ? 'Active'
                                : 'Expired',
                        color: expiryDate == null
                            ? greenColor
                            : isActive(expiryDate)
                                ? greenColor
                                : redColor,
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
                          title: "My Profile",
                          iconData: Icons.phone_android,
                          function: () async {
                            toggleDrawer();
                            if (!mounted) return;
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
                                    title: 'Select an option:',
                                    content: '',
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
                          title: "Apply Leave/Excuse",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ApplyLeavePage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "View Leave/Absent Status ",
                          iconData: Icons.phone_android,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewLeavePage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Akwaaba Forms",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.userFormUrl,
                                  title: 'Akwaaba Forms',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Attendance Report",
                          iconData: Icons.bar_chart,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AttendanceReportPage(),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Attendance History",
                          iconData: Icons.history,
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
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
                          function: () async {
                            var hasAttendance = await RestrictionUtil()
                                .hasAttendanceModule(context);
                            if (mounted) {
                              if (!(hasAttendance)) {
                                RestrictionUtil()
                                    .showAdminAttendanceAlert(context);
                                return;
                              }
                            }
                            toggleDrawer();
                            if (!mounted) return;
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
                            toggleDrawer();
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
                          title: "Make Payment",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.akwaabaPaymentUrl,
                                  title: 'Make Payment',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Student Account",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WebViewPage(
                                  url: AppConstants.akwaabaEduUrl,
                                  title: 'Student Account',
                                ),
                              ),
                            );
                          },
                        ),
                        drawerItemView(
                          title: "Contact Admin",
                          iconData: Icons.phone_android,
                          function: () {
                            toggleDrawer();
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
                          title: "Tutorial Hub",
                          iconData: Icons.phone_android,
                          function: () async {
                            Navigator.pop(context);
                            launchURL(AppConstants.userTutorialUrl);
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
                                    onConfirmTap: () => logout(),
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
          onTap: (value) async {
            setState(() => _selectedBottomNavIndex = value);
            if (_selectedBottomNavIndex == 1) {
              var hasAttendance =
                  await RestrictionUtil().hasAttendanceModule(context);
              if (mounted) {
                if (!hasAttendance) {
                  userType == AppConstants.admin
                      ? showInfoDialog(
                          'ok',
                          dismissible: false,
                          context: context,
                          title: 'Hey there!',
                          content:
                              'Sorry, you don\'t have access to this attendance feature, you must subscribe to the attendance module. Thank you',
                          onTap: () {
                            Navigator.pop(context);
                            setState(() => _selectedBottomNavIndex = 0);
                          },
                        )
                      : showInfoDialog(
                          'ok',
                          dismissible: false,
                          context: context,
                          title: 'Hey there!',
                          content:
                              'Sorry, you don\'t have access to this attendance feature, please contact admin for assistance. Thank you',
                          onTap: () {
                            Navigator.pop(context);
                            setState(() => _selectedBottomNavIndex = 0);
                          },
                        );

                  return;
                }
              }
            }
            if (_selectedBottomNavIndex == 2) {
              if (!mounted) return;
              var hasAttendance =
                  await RestrictionUtil().hasAttendanceModule(context);
              if (mounted) {
                if (!hasAttendance) {
                  showInfoDialog(
                    'ok',
                    dismissible: false,
                    context: context,
                    title: 'Hey there!',
                    content:
                        'Sorry, you don\'t have access to this attendance feature, you must subscribe to the attendance module. Thank you',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedBottomNavIndex = 0);
                    },
                  );
                  //RestrictionUtil().showAdminAttendanceAlert(context);
                  return;
                }
              }
            }
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
