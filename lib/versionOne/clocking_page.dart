import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/constants/app_constants.dart';
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

  late ScrollController _controller;

  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];
  DateTime? generalClockTime;
  bool checkAll = false;

  bool clockingListState = true;

  bool isFilterExpanded = false;

  late ClockingProvider clockingProvider;

  @override
  void initState() {
    _controller = ScrollController();

    Provider.of<ClockingProvider>(context, listen: false)
        .setCurrentContext(context);

    Future.delayed(Duration.zero, () {
      // load attendance list for meeting
      Provider.of<ClockingProvider>(context, listen: false).getAllAbsentees(
        meetingEventModel: widget.meetingEventModel,
      );
      // check if admin is main branch admin or not
      if (Provider.of<ClientProvider>(context, listen: false)
              .getUser
              .branchID ==
          AppConstants.mainAdmin) {
        Provider.of<ClockingProvider>(context, listen: false).getBranches();
      } else {
        Provider.of<ClockingProvider>(context, listen: false).getGenders();
      }

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

    var absentees = clockingProvider.absentees;
    var attendees = clockingProvider.attendees;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meetingEventModel.name!),
      ),
      body: RefreshIndicator(
        onRefresh: () => clockingProvider.refreshList(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: SingleChildScrollView(
            controller: _controller,
            //physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                filterButton(),

                const SizedBox(
                  height: 24,
                ),

                // Row(
                //   children: [
                //const Expanded(child:
                CupertinoSearchTextField(
                  onChanged: (val) {
                    setState(() {
                      if (clockingListState) {
                        // search absentees by name
                        clockingProvider.searchAbsenteesByName(searchText: val);
                      } else {
                        // search atendees by name
                        clockingProvider.searchAttendeesByName(searchText: val);
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
                      if (clockingListState) {
                        // search absentees by id
                        clockingProvider.searchAbsenteesById(searchText: val);
                      } else {
                        // search atendees by id
                        clockingProvider.searchAttendeesById(searchText: val);
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

                SizedBox(
                  height: displayHeight(context) * 0.01,
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
                            if (clockingProvider.selectedAbsentees.isEmpty) {
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
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'Clock In',
                                    content:
                                        'Are you sure you want to perform \nthis bulk operation?',
                                    onConfirmTap: () {
                                      Navigator.pop(context);
                                      clockingProvider.clockMemberIn(
                                        context: context,
                                        attendee: null,
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
                            if (clockingProvider.selectedAttendees.isEmpty) {
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
                                  insetPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: ConfirmDialog(
                                    title: 'Clock Out',
                                    content:
                                        'Are you sure you want to perform \nthis bulk operation?',
                                    onConfirmTap: () {
                                      Navigator.pop(context);
                                      clockingProvider.clockMemberOut(
                                        context: context,
                                        attendee: null,
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
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

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
                                      onTap: () => Navigator.pop(context),
                                    );
                                  } else {
                                    // perform bulk start break
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: ConfirmDialog(
                                          title: 'Start Break',
                                          content:
                                              'Are you sure you want to perform \nthis bulk operation?',
                                          onConfirmTap: () {
                                            Navigator.pop(context);
                                            clockingProvider.startMeetingBreak(
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
                                      onTap: () => Navigator.pop(context),
                                    );
                                  } else {
                                    // perform bulk end break
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: ConfirmDialog(
                                          title: 'End Break',
                                          content:
                                              'Are you sure you want to perform \nthis bulk operation?',
                                          onConfirmTap: () {
                                            Navigator.pop(context);
                                            clockingProvider.endMeetingBreak(
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
                      )
                    : const SizedBox(),

                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomElevatedButton(
                            label: "Clocking List",
                            textColor: Colors.white,
                            radius: 5,
                            function: () {
                              setState(() {
                                clockingListState = true;
                                checkAll = false;
                                clockingProvider.selectedAttendees.clear();
                                debugPrint(
                                    '     clockingListState = $clockingListState');
                              });
                            })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: CustomElevatedButton(
                          label: "Clocked List",
                          color: Colors.green,
                          textColor: Colors.white,
                          radius: 5,
                          function: () {
                            setState(() {
                              clockingListState = false;
                              checkAll = false;
                              clockingProvider.selectedAbsentees.clear();
                              debugPrint(
                                  '     clockingListState = $clockingListState');
                            });
                          }),
                    ),
                  ],
                ),

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

                        if (clockingListState) {
                          for (Attendee? absentee in absentees) {
                            absentee!.selected = checkAll;
                            if (absentee.selected!) {
                              clockingProvider.selectedAbsentees.add(absentee);
                            }
                            if (!absentee.selected!) {
                              clockingProvider.selectedAbsentees
                                  .remove(absentee);
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
                              clockingProvider.selectedAttendees
                                  .remove(attendee);
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

                clockingProvider.loading
                    ? Shimmer.fromColors(
                        baseColor: greyColorShade300,
                        highlightColor: greyColorShade100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => const EventShimmerItem(),
                          itemCount: 6,
                        ),
                      )
                    : clockingListState
                        ? Column(
                            children: absentees.isEmpty
                                ? [
                                    const EmptyStateWidget(
                                      text: 'No absentees found!',
                                    )
                                  ]
                                : List.generate(absentees.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (absentees[index]!.selected!) {
                                            //remove it
                                            absentees[index]!.selected = false;
                                            clockingProvider.selectedAbsentees
                                                .remove(absentees[index]);
                                          } else {
                                            absentees[index]!.selected = true;
                                            clockingProvider.selectedAbsentees
                                                .add(absentees[index]);
                                          }
                                          if (clockingProvider
                                              .selectedAbsentees.isNotEmpty) {
                                            itemHasBeenSelected = true;
                                          } else {
                                            itemHasBeenSelected = false;
                                          }
                                        });
                                        debugPrint(
                                            "Select Absentees: ${clockingProvider.selectedAbsentees.length}");
                                      },
                                      child: ClockingMemberItem(
                                        absentee: absentees[index],
                                      ),
                                    );
                                  }),
                          )
                        : Column(
                            children: attendees.isEmpty
                                ? [
                                    const EmptyStateWidget(
                                      text: 'No attendees found!',
                                    )
                                  ]
                                : List.generate(
                                    attendees.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              if (attendees[index]!.selected!) {
                                                //remove it
                                                attendees[index]!.selected =
                                                    false;

                                                clockingProvider
                                                    .selectedAttendees
                                                    .remove(attendees[index]!);
                                              } else {
                                                attendees[index]!.selected =
                                                    true;
                                                clockingProvider
                                                    .selectedAttendees
                                                    .add(attendees[index]!);
                                              }
                                              if (clockingProvider
                                                  .selectedAttendees
                                                  .isNotEmpty) {
                                                itemHasBeenSelected = true;
                                              } else {
                                                itemHasBeenSelected = false;
                                              }
                                              debugPrint(
                                                  "Selected Attendees: ${clockingProvider.selectedAttendees.length}");
                                            },
                                          );
                                        },
                                        child: ClockedMemberItem(
                                          attendee: attendees[index]!,
                                        ),
                                      );
                                    },
                                  ),
                          ),
              ],
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<ClientProvider>(
          builder: (context, data, child) {
            return data.getUser.branchID == AppConstants.mainAdmin
                ? LabelWidgetContainer(
                    label: "Branch",
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(width: 0.0, color: Colors.grey.shade400),
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
              items: clockingProvider.memberCategories.map((MemberCategory mc) {
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
                clockingProvider.getGroups(); // call method to fetch all groups
                clockingProvider
                    .getGenders(); // call method to fetch all genders
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
        // LabelWidgetContainer(
        //     label: "Meeting Type",
        //     child: FormButton(
        //       label: "Select Meeting Type",
        //       function: () {},
        //     )),

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

        // LabelWidgetContainer(
        //     label: "Date",
        //     child: FormButton(
        //       label: clockingProvider.selectedDate == null
        //           ? 'Select Date'
        //           : clockingProvider.selectedDate!
        //               .toIso8601String()
        //               .substring(0, 10),
        //       function: () {
        //         displayDateSelector(
        //           initialDate: DateTime.now(),
        //           context: context,
        //         ).then((value) {
        //           if (value != null) {
        //             setState(() {
        //               clockingProvider.selectedDate = value;
        //               debugPrint(
        //                   "DateTime: ${clockingProvider.selectedDate!.toIso8601String().substring(0, 10)}");
        //             });
        //           }
        //         });
        //       },
        //     )),

        SizedBox(
          height: displayHeight(context) * 0.008,
        ),

        CustomElevatedButton(
            label: "Filter",
            //showProgress: clockingProvider.loading,
            function: () {
              clockingProvider.validateFilterFields();
              if (clockingProvider.loading) {
                // scroll to bottom of the screen to show the loading progress
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(seconds: 3),
                  curve: Curves.ease,
                );
              }
            }),
        // LabelWidgetContainer(
        //   label: "Set Mass Time",
        //   child: FormButton(
        //     label: generalClockTime != null
        //         ? DateFormat("hh:mm").format(generalClockTime!)
        //         : "Select time",
        //     function: () {},
        //   ),
        // ),
      ],
    );
  }
}