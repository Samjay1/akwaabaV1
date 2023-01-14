import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/attendance_report_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_tab_widget.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/versionOne/attendance_report_filter_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/AttendanceReportItem.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../utils/app_theme.dart';
import 'attendance_report_preview.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({Key? key}) : super(key: key);

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  int selectedTabIndex = 0;
  String? selectedGender;
  final TextEditingController _controllerId = TextEditingController();
  final TextEditingController _controllerMinAge = TextEditingController();
  final TextEditingController _controllerMaxAge = TextEditingController();

  List<Map> members = [
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
  ];
  bool checkAll = false;
  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];

  int _selectedIndex = 0;

  bool isShowTopView = true;

  bool isTileExpanded = false;

  String? userType;

  late AttendanceProvider attendanceProvider;

  selectGender() {
    displayCustomDropDown(
            options: ["Male", "Female"],
            listItemsIsMap: false,
            context: context)
        .then((value) {
      selectedGender = value;
    });
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
  void initState() {
    Provider.of<AttendanceProvider>(context, listen: false)
        .setCurrentContext(context);

    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
    });

    Future.delayed(Duration.zero, () {
      // check if admin is main branch admin or not
      if (Provider.of<ClientProvider>(context, listen: false).branch.id ==
          AppConstants.mainAdmin) {
        Provider.of<AttendanceProvider>(context, listen: false).getBranches();
      } else {
        Provider.of<AttendanceProvider>(context, listen: false).getGenders();
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    attendanceProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    attendanceProvider = context.watch<AttendanceProvider>();
    var absentees = attendanceProvider.absentees;
    var attendees = attendanceProvider.attendees;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Report"),
      ),
      body: RefreshIndicator(
        onRefresh: () => attendanceProvider.refreshList(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isShowTopView
                  ? SizedBox(
                      height: isTileExpanded
                          ? displayHeight(context) * 0.50
                          : displayHeight(context) * 0.07,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            filterButton(),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),

              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Total Users'),
                      Text(
                        _selectedIndex == 0
                            ? attendanceProvider.totalAttendees.toString()
                            : attendanceProvider.totalAbsentees.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Total Males'),
                      Text(
                        _selectedIndex == 0
                            ? attendanceProvider.totalMaleAttendees.length
                                .toString()
                            : attendanceProvider.totalMaleAbsentees.length
                                .toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Total Females'),
                      Text(
                        _selectedIndex == 0
                            ? attendanceProvider.totalFemaleAttendees.length
                                .toString()
                            : attendanceProvider.totalFemaleAbsentees.length
                                .toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              CustomTabWidget(
                selectedIndex: _selectedIndex,
                tabTitles: const [
                  'Atendees',
                  'Absentees',
                ],
                onTaps: [
                  () {
                    setState(() {
                      _selectedIndex = 0;
                      checkAll = false;
                      attendanceProvider.selectedClockingIds.clear();
                      debugPrint('Selected Index: $_selectedIndex');
                    });
                  },
                  () {
                    setState(() {
                      _selectedIndex = 1;
                      checkAll = false;
                      attendanceProvider.selectedClockingIds.clear();
                      debugPrint('Selected Index: $_selectedIndex');
                    });
                  },
                ],
              ),

              // Row(
              //   children: [
              //     Expanded(
              //       child: CupertinoButton(
              //           color: selectedTabIndex == 1
              //               ? primaryColor
              //               : Colors.transparent,
              //           padding: EdgeInsets.zero,
              //           child: const Text(
              //             "Absentees",
              //             style: TextStyle(color: textColorPrimary),
              //           ),
              //           onPressed: () {
              //             setState(() {
              //               selectedTabIndex = 0;
              //             });
              //           }),
              //     ),
              //     const SizedBox(
              //       width: 12,
              //     ),
              //     Expanded(
              //       child: CupertinoButton(
              //           color: selectedTabIndex == 0
              //               ? primaryColor
              //               : Colors.transparent,
              //           padding: EdgeInsets.zero,
              //           child: const Text(
              //             "Attendees",
              //             style: TextStyle(color: textColorPrimary),
              //           ),
              //           onPressed: () {
              //             setState(() {
              //               selectedTabIndex = 1;
              //             });
              //           }),
              //     ),
              //   ],
              // ),

              const SizedBox(
                height: 12,
              ),

              _selectedIndex == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  for (Attendee? attendee in attendees) {
                                    attendee!.selected = checkAll;
                                    if (attendee.selected!) {
                                      attendanceProvider.selectedAttendees
                                          .add(attendee);
                                      attendanceProvider.selectedClockingIds
                                          .add(attendee.attendance!.id!);
                                    }
                                    if (!attendee.selected!) {
                                      attendanceProvider.selectedAttendees
                                          .remove(attendee);
                                      attendanceProvider.selectedClockingIds
                                          .remove(attendee.attendance!.id!);
                                    }
                                  }
                                  debugPrint(
                                    "Selected clockingIDs: ${attendanceProvider.selectedClockingIds.toString()}",
                                  );
                                } else {
                                  for (Attendee? absentee in absentees) {
                                    absentee!.selected = checkAll;
                                    if (absentee.selected!) {
                                      attendanceProvider.selectedAbsentees
                                          .add(absentee);
                                      attendanceProvider.selectedClockingIds
                                          .add(absentee.attendance!.id!);
                                    }
                                    if (!absentee.selected!) {
                                      attendanceProvider.selectedAbsentees
                                          .remove(absentee);
                                      attendanceProvider.selectedClockingIds
                                          .remove(absentee.attendance!.id!);
                                    }
                                  }
                                  debugPrint(
                                    "Selected clockingIDs: ${attendanceProvider.selectedClockingIds.toString()}",
                                  );
                                }
                              },
                            ),
                            const Text("Select All")
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () {
                            if (attendanceProvider
                                .selectedClockingIds.isEmpty) {
                              showInfoDialog(
                                'ok',
                                context: context,
                                title: 'Sorry!',
                                content:
                                    'Please select attendees to perform validation',
                                onTap: () => Navigator.pop(context),
                              );
                            } else {
                              // perform bulk clock out
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'Validate',
                                    content:
                                        'Are you sure you want to perform \nthis bulk operation?',
                                    onConfirmTap: () {
                                      Navigator.pop(context);
                                      attendanceProvider
                                          .validateMemberAttendances();
                                    },
                                    onCancelTap: () => Navigator.pop(context),
                                    confirmText: 'Yes',
                                    cancelText: 'Cancel',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: const Text("Validate"),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              attendanceProvider.loading
                  ? Expanded(
                      child: Shimmer.fromColors(
                        baseColor: greyColorShade300,
                        highlightColor: greyColorShade100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => const EventShimmerItem(),
                          itemCount: 6,
                        ),
                      ),
                    )
                  : _selectedIndex == 0
                      ? Expanded(
                          child: attendees.isEmpty
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
                                            controller: attendanceProvider
                                                .attendeesScrollController,
                                            shrinkWrap: true,
                                            itemCount: attendees.length,
                                            itemBuilder: (context, index) {
                                              if (attendees.isEmpty) {
                                                return const EmptyStateWidget(
                                                  text: 'No attendees found!',
                                                );
                                              }
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      if (attendees[index]!
                                                          .selected!) {
                                                        //remove it
                                                        attendees[index]!
                                                            .selected = false;

                                                        attendanceProvider
                                                            .selectedAttendees
                                                            .remove(attendees[
                                                                index]!);
                                                        attendanceProvider
                                                            .selectedClockingIds
                                                            .remove(absentees[
                                                                    index]!
                                                                .attendance!
                                                                .id!);
                                                      } else {
                                                        attendees[index]!
                                                            .selected = true;
                                                        attendanceProvider
                                                            .selectedAttendees
                                                            .add(attendees[
                                                                index]!);
                                                        attendanceProvider
                                                            .selectedClockingIds
                                                            .add(absentees[
                                                                    index]!
                                                                .attendance!
                                                                .id!);
                                                      }
                                                      if (attendanceProvider
                                                          .selectedAttendees
                                                          .isNotEmpty) {
                                                        itemHasBeenSelected =
                                                            true;
                                                      } else {
                                                        itemHasBeenSelected =
                                                            false;
                                                      }
                                                      debugPrint(
                                                        "Selected clockingIDs: ${attendanceProvider.selectedClockingIds.toString()}",
                                                      );
                                                    },
                                                  );
                                                },
                                                child: AttendanceReportItem(
                                                  attendee: attendees[index]!,
                                                  userType: userType,
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (attendanceProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
                                      )
                                  ],
                                ),
                        )
                      : Expanded(
                          child: absentees.isEmpty
                              ? const EmptyStateWidget(
                                  text: 'No absentees found!',
                                )
                              : Column(
                                  children: [
                                    NotificationListener<ScrollNotification>(
                                      onNotification: _handleScrollNotification,
                                      child: Expanded(
                                        child: ListView.builder(
                                            controller: attendanceProvider
                                                .absenteesScrollController,
                                            itemCount: absentees.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              if (absentees.isEmpty) {
                                                return const EmptyStateWidget(
                                                  text: 'No absentees found!',
                                                );
                                              }
                                              return GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    if (absentees[index]!
                                                        .selected!) {
                                                      //remove it
                                                      absentees[index]!
                                                          .selected = false;
                                                      attendanceProvider
                                                          .selectedAbsentees
                                                          .remove(
                                                              absentees[index]);
                                                      attendanceProvider
                                                          .selectedClockingIds
                                                          .remove(
                                                              absentees[index]!
                                                                  .attendance!
                                                                  .id!);
                                                    } else {
                                                      absentees[index]!
                                                          .selected = true;
                                                      attendanceProvider
                                                          .selectedAbsentees
                                                          .add(
                                                              absentees[index]);
                                                      attendanceProvider
                                                          .selectedClockingIds
                                                          .add(absentees[index]!
                                                              .attendance!
                                                              .id!);
                                                    }
                                                    if (attendanceProvider
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
                                                    "Selected clockingIDs: ${attendanceProvider.selectedClockingIds.toString()}",
                                                  );
                                                },
                                                child: AttendanceReportItem(
                                                  attendee: absentees[index]!,
                                                  userType: userType,
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (attendanceProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
                                      )
                                  ],
                                ),
                        ),

              // Column(
              //   children: List.generate(members.length, (index) {
              //     return GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             if (members[index]["status"]) {
              //               //remove it
              //               members[index]["status"] = false;
              //               selectedMembersList.remove(members[index]);
              //             } else {
              //               members[index]["status"] = true;
              //               selectedMembersList.add(members[index]);
              //             }
              //             if (selectedMembersList.isNotEmpty) {
              //               itemHasBeenSelected = true;
              //             } else {
              //               itemHasBeenSelected = false;
              //             }
              //           });
              //         },
              //         child: AttendanceReportItem(members[index], true));
              //   }),
              // ),
              // Container(
              //   child:  Column(
              //       children: List.generate(1, (index) {
              //         return  AttendanceReportItemWidget(
              //             isLate: index % 3==0);
              //       })
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceReportFilterOptionsList() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabelWidgetContainer(
            label: "Date",
            child: FormButton(
              label: attendanceProvider.selectedDate == null
                  ? 'Select Date'
                  : attendanceProvider.selectedDate!
                      .toIso8601String()
                      .substring(0, 10),
              function: () {
                displayDateSelector(
                  initialDate: DateTime.now(),
                  maxDate: DateTime.now(),
                  context: context,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      attendanceProvider.selectedDate = value;
                      debugPrint(
                          "Selected DateTime: ${attendanceProvider.selectedDate!.toIso8601String().substring(0, 10)}");
                    });
                    // if admin is main branch admin
                    if (context.read<ClientProvider>().branch.id == 1) {
                      attendanceProvider.getBranches();
                    }
                    // admin is just a branch admin
                    attendanceProvider.getPastMeetingEvents();
                  }
                });
              },
            ),
          ),
          Consumer<ClientProvider>(
            builder: (context, data, child) {
              return (data.branch.id == AppConstants.mainAdmin &&
                      userType == AppConstants.admin)
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
                          value: attendanceProvider.selectedBranch,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items:
                              attendanceProvider.branches.map((Branch branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              attendanceProvider.selectedBranch = val as Branch;
                            });
                            attendanceProvider.getPastMeetingEvents();
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
            label: "Meeting/Event",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<MeetingEventModel>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text(
                  'Select Meeting',
                ),
                decoration: const InputDecoration(border: InputBorder.none),
                value: attendanceProvider.selectedPastMeetingEvent,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceProvider.pastMeetingEvents
                    .map((MeetingEventModel mc) {
                  return DropdownMenuItem(
                    value: mc,
                    child: Text(mc.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceProvider.selectedPastMeetingEvent =
                        val as MeetingEventModel;
                  });
                  attendanceProvider.getMemberCategories();
                },
              ),
            ),
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
                value: attendanceProvider.selectedMemberCategory,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceProvider.memberCategories
                    .map((MemberCategory mc) {
                  return DropdownMenuItem(
                    value: mc,
                    child: Text(mc.category!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceProvider.selectedMemberCategory =
                        val as MemberCategory;
                  });
                  attendanceProvider.getMemberCategories();
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
                value: attendanceProvider.selectedGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceProvider.groups.map((Group group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(group.group!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceProvider.selectedGroup = val as Group;
                  });
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
                value: attendanceProvider.selectedSubGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceProvider.subGroups.map((SubGroup subGroup) {
                  return DropdownMenuItem(
                    value: subGroup,
                    child: Text(subGroup.subgroup!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceProvider.selectedSubGroup = val as SubGroup;
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
                value: attendanceProvider.selectedGender,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceProvider.genders.map((Gender gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceProvider.selectedGender = val as Gender;
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
                    controller: attendanceProvider.minAgeTEC,
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
                    controller: attendanceProvider.maxAgeTEC,
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
                    onTap: () => attendanceProvider.clearData(),
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
                      attendanceProvider.validateFilterFields(context);
                    }),
              ),
            ],
          ),
        ],
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
          initiallyExpanded: isTileExpanded,
          onExpansionChanged: (value) {
            setState(() {
              isTileExpanded = value;
            });
            debugPrint("Expanded: $isTileExpanded");
          },
          title: const Text(
            "Filter Options ",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[attendanceReportFilterOptionsList()],
        ),
      ),
    );
  }
}
