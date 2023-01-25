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

class ClockingPage extends StatefulWidget {
  final MeetingEventModel meetingEventModel;
  const ClockingPage({Key? key, required this.meetingEventModel})
      : super(key: key);

  @override
  State<ClockingPage> createState() => _ClockingPageState();
}

class _ClockingPageState extends State<ClockingPage> {
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
      Provider.of<ClockingProvider>(context, listen: false).getAllAbsentees(
        meetingEventModel: widget.meetingEventModel,
      );
      // check if admin is main branch admin or not
      if (Provider.of<ClientProvider>(context, listen: false).branch.id ==
          AppConstants.mainAdmin) {
        Provider.of<ClockingProvider>(context, listen: false).getBranches();
      } else {
        Provider.of<ClockingProvider>(context, listen: false).getGenders();
      }
      setState(() {});
    });
    // setState(() {});
    super.initState();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            setState(() {
              isShowTopView = true;
            });
            break;
          case ScrollDirection.reverse:
            setState(() {
              isShowTopView = false;
            });
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    clockingProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    clockingProvider = context.watch<ClockingProvider>();
    var absentees = clockingProvider.absentees;
    var attendees = clockingProvider.attendees;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.meetingEventModel.name!),
      ),
      body: RefreshIndicator(
        onRefresh: () => clockingProvider.refreshList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isShowTopView
                  ? SizedBox(
                      height: displayHeight(context) * 0.35,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            filterButton(),
                            const SizedBox(
                              height: 12,
                            ),
                            CupertinoSearchTextField(
                              onChanged: (val) {
                                setState(() {
                                  if (_selectedIndex == 0) {
                                    // search absentees by name
                                    clockingProvider.searchAbsenteesByName(
                                        searchText: val);
                                  } else {
                                    // search atendees by name
                                    clockingProvider.searchAttendeesByName(
                                        searchText: val);
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            CupertinoSearchTextField(
                              placeholder: "Enter ID",
                              onChanged: (val) {
                                setState(() {
                                  if (_selectedIndex == 0) {
                                    // search absentees by id
                                    clockingProvider.searchAbsenteesById(
                                        searchText: val);
                                  } else {
                                    // search atendees by id
                                    clockingProvider.searchAttendeesById(
                                        searchText: val);
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: displayHeight(context) * 0.02,
                            ),
                            const Divider(
                              height: 2,
                              color: Colors.orange,
                            ),
                            LabelWidgetContainer(
                              label: "",
                              child: Row(
                                children: [
                                  const Text("Bulk Clock"),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Expanded(
                                    child: CustomOutlinedButton(
                                      label: "In",
                                      mycolor: Colors.green,
                                      radius: 5,
                                      function: () {
                                        if (clockingProvider
                                            .selectedAbsentees.isEmpty) {
                                          showInfoDialog(
                                            'ok',
                                            context: context,
                                            title: 'Sorry!',
                                            content:
                                                'Please select members to clock-in on their behalf',
                                            onTap: () => Navigator.pop(context),
                                          );
                                        } else {
                                          // perform bulk clock in
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.all(10),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              content: ConfirmDialog(
                                                title: 'Clock In',
                                                content:
                                                    'Are you sure you want to perform \nthis bulk operation?',
                                                onConfirmTap: () {
                                                  Navigator.pop(context);
                                                  clockingProvider
                                                      .clockMemberIn(
                                                    context: context,
                                                    attendee: null,
                                                    time: null,
                                                  );
                                                },
                                                onCancelTap: () =>
                                                    Navigator.pop(context),
                                                confirmText: 'Yes',
                                                cancelText: 'Cancel',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: CustomOutlinedButton(
                                      label: "Out",
                                      mycolor: Colors.red,
                                      radius: 5,
                                      function: () {
                                        if (clockingProvider
                                            .selectedAttendees.isEmpty) {
                                          showInfoDialog(
                                            'ok',
                                            context: context,
                                            title: 'Sorry!',
                                            content:
                                                'Please select members to clock-out on their behalf',
                                            onTap: () => Navigator.pop(context),
                                          );
                                        } else {
                                          // perform bulk clock out
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.all(10),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              content: ConfirmDialog(
                                                title: 'Clock Out',
                                                content:
                                                    'Are you sure you want to perform \nthis bulk operation?',
                                                onConfirmTap: () {
                                                  Navigator.pop(context);
                                                  clockingProvider
                                                      .clockMemberOut(
                                                    context: context,
                                                    attendee: null,
                                                    time: null,
                                                  );
                                                },
                                                onCancelTap: () =>
                                                    Navigator.pop(context),
                                                confirmText: 'Yes',
                                                cancelText: 'Cancel',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.meetingEventModel.hasBreakTime!
                                ? SizedBox(
                                    height: displayHeight(context) * 0.025,
                                  )
                                : const SizedBox(),
                            widget.meetingEventModel.hasBreakTime!
                                ? const Divider(
                                    height: 2,
                                    color: primaryColor,
                                  )
                                : const SizedBox(),
                            // SizedBox(
                            //   height: displayHeight(context) * 0.01,
                            // ),
                            widget.meetingEventModel.hasBreakTime!
                                ? LabelWidgetContainer(
                                    label: "",
                                    child: Row(
                                      children: [
                                        const Text("Bulk Break"),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        Expanded(
                                          child: CustomElevatedButton(
                                            label: "Start",
                                            radius: 5,
                                            labelSize: 15,
                                            textColor: whiteColor,
                                            color: Colors.green,
                                            function: () {
                                              if (clockingProvider
                                                  .selectedAttendees.isEmpty) {
                                                showInfoDialog(
                                                  'ok',
                                                  context: context,
                                                  title: 'Sorry!',
                                                  content:
                                                      'Please select members to start break on their behalf',
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                );
                                              } else {
                                                // perform bulk start break
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    content: ConfirmDialog(
                                                      title: 'Start Break',
                                                      content:
                                                          'Are you sure you want to perform \nthis bulk operation?',
                                                      onConfirmTap: () {
                                                        Navigator.pop(context);
                                                        clockingProvider
                                                            .startMeetingBreak(
                                                          context: context,
                                                          attendee: null,
                                                          time: null,
                                                        );
                                                      },
                                                      onCancelTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      confirmText: 'Yes',
                                                      cancelText: 'Cancel',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: CustomElevatedButton(
                                            label: "End",
                                            labelSize: 15,
                                            color: primaryColor,
                                            radius: 5,
                                            function: () {
                                              if (clockingProvider
                                                  .selectedAttendees.isEmpty) {
                                                showInfoDialog(
                                                  'ok',
                                                  context: context,
                                                  title: 'Sorry!',
                                                  content:
                                                      'Please select members to end break on their behalf',
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                );
                                              } else {
                                                // perform bulk end break
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    content: ConfirmDialog(
                                                      title: 'End Break',
                                                      content:
                                                          'Are you sure you want to perform \nthis bulk operation?',
                                                      onConfirmTap: () {
                                                        Navigator.pop(context);
                                                        clockingProvider
                                                            .endMeetingBreak(
                                                          context: context,
                                                          attendee: null,
                                                          time: null,
                                                        );
                                                      },
                                                      onCancelTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      confirmText: 'Yes',
                                                      cancelText: 'Cancel',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),

                            SizedBox(
                              height: displayHeight(context) * 0.02,
                            ),
                            const Divider(
                              height: 2,
                              color: primaryColor,
                            ),
                            SizedBox(
                              height: displayHeight(context) * 0.01,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),

              CustomTabWidget(
                selectedIndex: _selectedIndex,
                tabTitles: const [
                  'Clocking List',
                  'Clocked List',
                ],
                onTaps: [
                  () {
                    setState(() {
                      _selectedIndex = 0;
                      checkAll = false;
                      clockingProvider.selectedAttendees.clear();
                      debugPrint('clockingListState = $_selectedIndex');
                    });
                  },
                  () {
                    setState(() {
                      _selectedIndex = 1;
                      checkAll = false;
                      clockingProvider.selectedAbsentees.clear();
                      debugPrint('clockingListState = $_selectedIndex');
                    });
                  },
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: InkWell(
              //         onTap: () {
              //           setState(() {
              //             clockingListState = true;
              //             checkAll = false;
              //             clockingProvider.selectedAttendees.clear();
              //             debugPrint(
              //                 '     clockingListState = $clockingListState');
              //           });
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.all(12.0),
              //           decoration: BoxDecoration(
              //               color: clockingListState
              //                   ? primaryColor
              //                   : Colors.transparent,
              //               border: Border.all(color: primaryColor, width: 1.2),
              //               borderRadius:
              //                   BorderRadius.circular(AppRadius.borderRadius8)),
              //           child: Center(
              //             child: Text(
              //               'Clocking List',
              //               style: TextStyle(
              //                 fontSize: 16.0,
              //                 fontWeight: FontWeight.w600,
              //                 color:
              //                     clockingListState ? whiteColor : primaryColor,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: displayWidth(context) * 0.03,
              //     ),
              //     Expanded(
              //       child: InkWell(
              //         onTap: () {
              //           setState(() {
              //             clockingListState = false;
              //             checkAll = false;
              //             clockingProvider.selectedAbsentees.clear();
              //             debugPrint('clockingListState = $clockingListState');
              //           });
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.all(12.0),
              //           decoration: BoxDecoration(
              //               color: !clockingListState
              //                   ? primaryColor
              //                   : Colors.transparent,
              //               border: Border.all(color: primaryColor, width: 1.2),
              //               borderRadius:
              //                   BorderRadius.circular(AppRadius.borderRadius8)),
              //           child: Center(
              //             child: Text(
              //               'Clocked List',
              //               style: TextStyle(
              //                 fontSize: 16.0,
              //                 fontWeight: FontWeight.w600,
              //                 color: !clockingListState
              //                     ? whiteColor
              //                     : primaryColor,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: primaryColor,
                    shape: const CircleBorder(),
                    value: checkAll,
                    onChanged: (val) {
                      setState(() {
                        checkAll = val!;
                      });

                      if (_selectedIndex == 0) {
                        for (Attendee? absentee in absentees) {
                          absentee!.selected = checkAll;
                          if (absentee.selected!) {
                            clockingProvider.selectedAbsentees.add(absentee);
                          }
                          if (!absentee.selected!) {
                            clockingProvider.selectedAbsentees.remove(absentee);
                          }
                          debugPrint(
                              "Absentee: ${absentee.attendance!.memberId!.selected}");
                        }

                        debugPrint(
                            "Selected Absentees: ${clockingProvider.selectedAbsentees.length}");
                      } else {
                        for (Attendee? attendee in attendees) {
                          attendee!.selected = checkAll;
                          if (attendee.selected!) {
                            clockingProvider.selectedAttendees.add(attendee);
                            debugPrint(
                                "Attendee: ${attendee.attendance!.memberId!.selected}");
                          }
                          if (!attendee.selected!) {
                            clockingProvider.selectedAttendees.remove(attendee);
                          }
                        }

                        debugPrint(
                            "Selected attendees: ${clockingProvider.selectedAttendees.length}");
                      }
                    },
                  ),
                  const Text("Select All")
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.008,
              ),
              const Divider(
                height: 2,
                color: Colors.orange,
              ),
              const SizedBox(
                height: 12,
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
                                  text: 'No absentees found!',
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification:
                                            _handleScrollNotification,
                                        child: ListView.builder(
                                            controller: clockingProvider
                                                .absenteesScrollController,
                                            itemCount: clockingProvider
                                                .absentees.length,
                                            itemBuilder: (context, index) {
                                              // if (clockingProvider.absentees.isEmpty) {
                                              //   return const EmptyStateWidget(
                                              //     text: 'No absentees found!',
                                              //   );
                                              // }
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (clockingProvider
                                                        .absentees[index]!
                                                        .selected!) {
                                                      //remove it
                                                      clockingProvider
                                                          .absentees[index]!
                                                          .selected = false;
                                                      clockingProvider
                                                          .selectedAbsentees
                                                          .remove(
                                                              clockingProvider
                                                                      .absentees[
                                                                  index]);
                                                    } else {
                                                      clockingProvider
                                                          .absentees[index]!
                                                          .selected = true;
                                                      clockingProvider
                                                          .selectedAbsentees
                                                          .add(clockingProvider
                                                                  .absentees[
                                                              index]);
                                                    }
                                                    if (clockingProvider
                                                        .selectedAbsentees
                                                        .isNotEmpty) {
                                                      itemHasBeenSelected =
                                                          true;
                                                    } else {
                                                      itemHasBeenSelected =
                                                          false;
                                                    }
                                                  });
                                                  debugPrint(
                                                      "Select Absentees: ${clockingProvider.selectedAbsentees.length}");
                                                },
                                                child: ClockingMemberItem(
                                                  absentee: clockingProvider
                                                      .absentees[index],
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (clockingProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
                                      )
                                  ],
                                ),
                        )
                      : Expanded(
                          child: clockingProvider.attendees.isEmpty
                              ? const EmptyStateWidget(
                                  text: 'No attendees found!',
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification:
                                            _handleScrollNotification,
                                        child: ListView.builder(
                                            controller: clockingProvider
                                                .attendeesScrollController,
                                            itemCount: clockingProvider
                                                .attendees.length,
                                            itemBuilder: (context, index) {
                                              // if (clockingProvider.attendees.isEmpty) {
                                              //   return const EmptyStateWidget(
                                              //     text: 'No attendees found!',
                                              //   );
                                              // }
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      if (clockingProvider
                                                          .attendees[index]!
                                                          .selected!) {
                                                        //remove it
                                                        clockingProvider
                                                            .attendees[index]!
                                                            .selected = false;

                                                        clockingProvider
                                                            .selectedAttendees
                                                            .remove(
                                                                clockingProvider
                                                                        .attendees[
                                                                    index]!);
                                                      } else {
                                                        clockingProvider
                                                            .attendees[index]!
                                                            .selected = true;
                                                        clockingProvider
                                                            .selectedAttendees
                                                            .add(clockingProvider
                                                                    .attendees[
                                                                index]!);
                                                      }
                                                      if (clockingProvider
                                                          .selectedAttendees
                                                          .isNotEmpty) {
                                                        itemHasBeenSelected =
                                                            true;
                                                      } else {
                                                        itemHasBeenSelected =
                                                            false;
                                                      }
                                                      debugPrint(
                                                          "Selected Attendees: ${clockingProvider.selectedAttendees.length}");
                                                    },
                                                  );
                                                },
                                                child: ClockedMemberItem(
                                                  attendee: clockingProvider
                                                      .attendees[index]!,
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (clockingProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
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

  Widget filterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "More Filters ",
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: textColorPrimary),
          ),
          children: <Widget>[filterOptionsListView()],
        ),
      ),
    );
  }

  Widget filterOptionsListView() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<ClientProvider>(
            builder: (context, data, child) {
              return data.branch.id == AppConstants.mainAdmin
                  ? LabelWidgetContainer(
                      label: "Branch",
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<Branch>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Branch'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: clockingProvider.selectedBranch,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: clockingProvider.branches.map((Branch branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              clockingProvider.selectedBranch = val as Branch;
                            });
                            clockingProvider.getMemberCategories();
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Member Category",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<MemberCategory>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text('Select Member Category'),
                decoration: const InputDecoration(border: InputBorder.none),
                value: clockingProvider.selectedMemberCategory,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items:
                    clockingProvider.memberCategories.map((MemberCategory mc) {
                  return DropdownMenuItem(
                    value: mc,
                    child: Text(mc.category!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    clockingProvider.selectedMemberCategory =
                        val as MemberCategory;
                  });
                  clockingProvider
                      .getGroups(); // call method to fetch all groups
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Group",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<Group>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text('Select Group'),
                decoration: const InputDecoration(border: InputBorder.none),
                value: clockingProvider.selectedGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: clockingProvider.groups.map((Group group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(group.group!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    clockingProvider.selectedGroup = val as Group;
                  });
                  clockingProvider.getSubGroups();
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Sub Group",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<SubGroup>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text('Select SubGroup'),
                decoration: const InputDecoration(border: InputBorder.none),
                value: clockingProvider.selectedSubGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: clockingProvider.subGroups.map((SubGroup subGroup) {
                  return DropdownMenuItem(
                    value: subGroup,
                    child: Text(subGroup.subgroup!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    clockingProvider.selectedSubGroup = val as SubGroup;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Gender",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<Gender>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text('Select Gender'),
                decoration: const InputDecoration(border: InputBorder.none),
                value: clockingProvider.selectedGender,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: clockingProvider.genders.map((Gender gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    clockingProvider.selectedGender = val as Gender;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Row(
            children: [
              Expanded(
                child: LabelWidgetContainer(
                  label: "Minimum Age",
                  child: FormTextField(
                    controller: clockingProvider.minAgeTEC,
                    textInputType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: LabelWidgetContainer(
                  label: "Maximum Age",
                  child: FormTextField(
                    controller: clockingProvider.maxAgeTEC,
                    textInputType: TextInputType.number,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: displayHeight(context) * 0.008,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () => clockingProvider.clearFilters(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius:
                            BorderRadius.circular(AppRadius.borderRadius8),
                      ),
                      child: const Text(
                        'Clear',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    )),
              ),
              SizedBox(
                width: displayWidth(context) * 0.04,
              ),
              Expanded(
                child: CustomElevatedButton(
                    label: "Filter",
                    radius: AppRadius.borderRadius8,
                    function: () {
                      clockingProvider.validateFilterFields();
                      // if (clockingProvider.loading) {
                      //   // scroll to bottom of the screen to show the loading progress
                      //   _controller.animateTo(
                      //     _controller.position.maxScrollExtent,
                      //     duration: const Duration(seconds: 3),
                      //     curve: Curves.ease,
                      //   );
                      // }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
