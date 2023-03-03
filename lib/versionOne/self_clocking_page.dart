import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/components/self_clocking_member_item.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/self_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/search_util.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SelfClockingPage extends StatefulWidget {
  final MeetingEventModel meetingEventModel;
  const SelfClockingPage({Key? key, required this.meetingEventModel})
      : super(key: key);

  @override
  State<SelfClockingPage> createState() => _SelfClockingPageState();
}

class _SelfClockingPageState extends State<SelfClockingPage> {
  //bool clockingListState = true;

  int _selectedIndex = 0;

  bool isFilterExpanded = false;

  late SelfClockingProvider clockingProvider;

  bool isShowTopView = true;

  bool clockingListState = true;

  final _debouncer = Debouncer(milliseconds: AppConstants.searchTimerDuration);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<SelfClockingProvider>(context, listen: false)
          .setCurrentContext(context);
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    //clockingProvider.clearData();
    super.dispose();
  }

  Future<bool> logout() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: ConfirmDialog(
          title: 'Logout',
          content:
              'You are about to logout. \n\nAre you sure you really want to perform this operation?',
          onConfirmTap: () => SharedPrefs().logout(context),
          onCancelTap: () => Navigator.pop(context),
          confirmText: 'Confirm',
          cancelText: 'Cancel',
        ),
      ),
    );
    // SharedPrefs().logout(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    clockingProvider = context.watch<SelfClockingProvider>();
    return WillPopScope(
      onWillPop: () async => logout(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.meetingEventModel.name!),
          automaticallyImplyLeading: true,
        ),
        body: RefreshIndicator(
          onRefresh: () => clockingProvider.refreshList(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.circular(AppRadius.borderRadius8),
                  ),
                  child: const Text(
                    "Hi there, you are welcome. \nPlease enter your ID to clock in or clock out. Have a nice day!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSize.s18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.03,
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppRadius.borderRadius8),
                  ),
                  child: const Text(
                    "WARNING!! \nDON'T CLOCK FOR ANYBODY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSize.s18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                SizedBox(
                  height: displayHeight(context) * 0.04,
                ),
                CupertinoSearchTextField(
                  padding: const EdgeInsets.all(AppPadding.p18),
                  controller: clockingProvider.searchTEC,
                  keyboardType: TextInputType.number,
                  placeholder: "Enter ID",
                  onSubmitted: (val) {
                    setState(() {
                      clockingProvider.searchIdentity = val;
                    });
                    clockingProvider.getAllAbsentees(
                      meetingEventModel: widget.meetingEventModel,
                    );
                  },
                  onChanged: (val) {
                    setState(() {
                      clockingProvider.searchIdentity = val;
                    });
                    if (val.isEmpty) {
                      _debouncer.run(() {
                        clockingProvider.clearData();
                      });
                    } else {
                      _debouncer.run(() {
                        clockingProvider.getAllAbsentees(
                          meetingEventModel: widget.meetingEventModel,
                        );
                      });
                    }
                  },
                ),

                SizedBox(
                  height: displayHeight(context) * 0.020,
                ),

                // CustomTabWidget(
                //   selectedIndex: _selectedIndex,
                //   tabTitles: const [
                //     'Clockin ',
                //     'Clockout ',
                //   ],
                //   onTaps: [
                //     () {
                //       setState(() {
                //         _selectedIndex = 0;

                //         debugPrint('clockingListState = $_selectedIndex');
                //       });
                //     },
                //     () {
                //       setState(() {
                //         _selectedIndex = 1;

                //         debugPrint('clockingListState = $_selectedIndex');
                //       });
                //     },
                //   ],
                // ),

                // SizedBox(
                //   height: displayHeight(context) * 0.015,
                // ),

                // list of absentees and attendees
                clockingProvider.loading
                    ? Expanded(
                        child: Shimmer.fromColors(
                          baseColor: greyColorShade300,
                          highlightColor: greyColorShade100,
                          child: ListView.builder(
                            itemBuilder: (_, __) => const EventShimmerItem(),
                            itemCount: 10,
                          ),
                        ),
                      )
                    :
                    // _selectedIndex == 0
                    //     ?
                    Expanded(
                        child: (clockingProvider.absentees.isEmpty &&
                                clockingProvider.attendees.isEmpty)
                            ? const EmptyStateWidget(
                                text: 'No records found!',
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        controller: (clockingProvider
                                                    .attendees.isNotEmpty &&
                                                clockingProvider.attendees[0]!
                                                        .attendance!.inTime !=
                                                    null)
                                            ? clockingProvider
                                                .attendeesScrollController
                                            : clockingProvider
                                                .absenteesScrollController,
                                        itemCount: (clockingProvider
                                                    .attendees.isNotEmpty &&
                                                clockingProvider.attendees[0]!
                                                        .attendance!.inTime !=
                                                    null)
                                            ? clockingProvider.attendees.length
                                            : clockingProvider.absentees.length,
                                        itemBuilder: (context, index) {
                                          return SelfClockingMemberItem(
                                            absentee: (clockingProvider
                                                        .attendees.isNotEmpty &&
                                                    clockingProvider
                                                            .attendees[0]!
                                                            .attendance!
                                                            .inTime !=
                                                        null)
                                                ? clockingProvider
                                                    .attendees[index]!
                                                : clockingProvider
                                                    .absentees[index]!,
                                          );
                                        }),
                                  ),
                                  if (clockingProvider.loadingMore)
                                    const PaginationLoader(
                                      loadingText: 'Loading. please wait...',
                                    )
                                ],
                              ),
                      )
                // : Expanded(
                //     child: clockingProvider.attendees.isEmpty
                //         ? const EmptyStateWidget(
                //             text: 'No records found!',
                //           )
                //         : Column(
                //             children: [
                //               Expanded(
                //                 child: ListView.builder(
                //                     physics:
                //                         const BouncingScrollPhysics(),
                //                     controller: clockingProvider
                //                         .attendeesScrollController,
                //                     itemCount: clockingProvider
                //                         .attendees.length,
                //                     itemBuilder: (context, index) {
                //                       return SelfClockingMemberItem(
                //                         absentee: clockingProvider
                //                             .attendees[index]!,
                //                       );
                //                     }),
                //               ),
                //               if (clockingProvider.loadingMore)
                //                 const PaginationLoader(
                //                   loadingText:
                //                       'Loading. please wait...',
                //                 )
                //             ],
                //           ),
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
