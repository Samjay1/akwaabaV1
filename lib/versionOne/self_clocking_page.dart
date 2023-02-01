import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/custom_tab_widget.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/components/self_clocking_member_item.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/clocked_member_item.dart';
import '../components/clocking_member_item.dart';
import '../components/form_textfield.dart';

class SelfClockingPage extends StatefulWidget {
  final MeetingEventModel meetingEventModel;
  const SelfClockingPage({Key? key, required this.meetingEventModel})
      : super(key: key);

  @override
  State<SelfClockingPage> createState() => _SelfClockingPageState();
}

class _SelfClockingPageState extends State<SelfClockingPage> {
  // List<Map> members = [
  //   {"status": true},
  //   {"status": true},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  //   {"status": false},
  // ];

  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];
  DateTime? generalClockTime;
  bool checkAll = false;

  //bool clockingListState = true;

  int _selectedIndex = 0;

  bool isFilterExpanded = false;

  late ClockingProvider clockingProvider;

  bool isShowTopView = true;

  bool clockingListState = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ClockingProvider>(context, listen: false)
          .setCurrentContext(context);
      // load attendance list for meeting
      // Provider.of<ClockingProvider>(context, listen: false).getAllAbsentees(
      //   meetingEventModel: widget.meetingEventModel,
      // );
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    clockingProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    clockingProvider = context.watch<ClockingProvider>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.meetingEventModel.name!),
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: () => clockingProvider.refreshList(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoSearchTextField(
                  placeholder: "Enter ID",
                  onSubmitted: (val) {
                    setState(() {
                      clockingProvider.search = val;
                    });
                    clockingProvider.getAllAbsentees(
                        meetingEventModel: widget.meetingEventModel);
                  },
                ),

                SizedBox(
                  height: displayHeight(context) * 0.025,
                ),

                CustomTabWidget(
                  selectedIndex: _selectedIndex,
                  tabTitles: const [
                    'Clockin ',
                    'Clockout ',
                  ],
                  onTaps: [
                    () {
                      setState(() {
                        _selectedIndex = 0;

                        clockingProvider.selectedAttendees.clear();
                        debugPrint('clockingListState = $_selectedIndex');
                      });
                    },
                    () {
                      setState(() {
                        _selectedIndex = 1;

                        clockingProvider.selectedAbsentees.clear();
                        debugPrint('clockingListState = $_selectedIndex');
                      });
                    },
                  ],
                ),

                SizedBox(
                  height: displayHeight(context) * 0.015,
                ),

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
                    : _selectedIndex == 0
                        ? Expanded(
                            child: clockingProvider.absentees.isEmpty
                                ? const EmptyStateWidget(
                                    text:
                                        'No records found! \nType in your ID to clockin',
                                  )
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: clockingProvider
                                                .absenteesScrollController,
                                            itemCount: clockingProvider
                                                .absentees.length,
                                            itemBuilder: (context, index) {
                                              return SelfClockingMemberItem(
                                                absentee: clockingProvider
                                                    .absentees[index]!,
                                              );
                                            }),
                                      ),
                                      if (clockingProvider.loadingMore)
                                        const PaginationLoader(
                                          loadingText:
                                              'Loading. please wait...',
                                        )
                                    ],
                                  ),
                          )
                        : Expanded(
                            child: clockingProvider.attendees.isEmpty
                                ? const EmptyStateWidget(
                                    text:
                                        'No records found! \nType in your ID to clockout',
                                  )
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: clockingProvider
                                                .attendeesScrollController,
                                            itemCount: clockingProvider
                                                .attendees.length,
                                            itemBuilder: (context, index) {
                                              return SelfClockingMemberItem(
                                                absentee: clockingProvider
                                                    .attendees[index]!,
                                              );
                                            }),
                                      ),
                                      if (clockingProvider.loadingMore)
                                        const PaginationLoader(
                                          loadingText:
                                              'Loading. please wait...',
                                        )
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
