import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/postclock_clocked_member_item.dart';
import 'package:akwaaba/components/postclock_clocking_member_item.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/clocked_member_item.dart';
import '../components/clocking_member_item.dart';
import '../components/form_textfield.dart';

class PostClockingPage extends StatefulWidget {
  const PostClockingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostClockingPage> createState() => _PostClockingPageState();
}

class _PostClockingPageState extends State<PostClockingPage> {
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
    // Future.delayed(Duration.zero, () {
    //   // load attendance list for meeting
    //   Provider.of<ClockingProvider>(context, listen: false).getAttendanceList(
    //     meetingEventModel: widget.meetingEventModel,
    //   );
    //   // loading member group for filtering
    //   Provider.of<ClockingProvider>(context, listen: false)
    //       .getMemberCategories();
    //   setState(() {});
    // });
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
    var members = clockingProvider.meetingMembers;
    var clockedMembers = clockingProvider.clockedMembers;
    return Scaffold(
      body: Container(
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
                      // search attendance list by name
                      clockingProvider.searchAttendanceList(searchText: val);
                    } else {
                      // search clocked members by name
                      clockingProvider.searchClockedList(searchText: val);
                    }
                  });
                },
              ),

              //),
              // IconButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (_)
              //   =>const FilterPageClocking()));
              // },
              //     icon: const Icon(Icons.filter_alt,color: primaryColor,))
              //   ],
              // ),

              const SizedBox(
                height: 12,
              ),

              CupertinoSearchTextField(
                placeholder: "Enter ID",
                onChanged: (val) {
                  setState(() {
                    if (clockingListState) {
                      // search attendance list by id
                      clockingProvider.searchAttendanceListById(
                          searchText: val);
                    } else {
                      // search clocked members by id
                      clockingProvider.searchClockedListById(searchText: val);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //REFRESING BUTTON
                  InkWell(
                      onTap: () => clockingProvider.clearData(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text(
                          'Clear',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  //POST CLOCK DATE BUTTON
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          displayDateSelector(
                            initialDate: DateTime.now(),
                            maxDate: DateTime.now(),
                            context: context,
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                clockingProvider.postClockDate = value;
                                debugPrint(
                                  "Selected PostClock Date: ${clockingProvider.postClockDate!.toIso8601String().substring(0, 11)}",
                                );
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            clockingProvider.postClockDate == null
                                ? 'Post Clock Date'
                                : clockingProvider.postClockDate!
                                    .toIso8601String()
                                    .substring(0, 10),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  //POST CLOCK TIME BUTTON
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          displayTimeSelector(
                            initialDate: DateTime.now(),
                            context: context,
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                clockingProvider.postClockTime = value;
                                debugPrint(
                                  "Selected PostClock Time: ${clockingProvider.postClockTime!.toIso8601String().substring(11, 19)}",
                                );
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            clockingProvider.postClockTime == null
                                ? 'Post Clock Time'
                                : clockingProvider.postClockTime!
                                    .toIso8601String()
                                    .substring(11, 19),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        )),
                  )
                ],
              ),
              //// CustomElevatedButton(label: "Filter", function: (){}),\

              SizedBox(
                height: displayHeight(context) * 0.02,
              ),

              LabelWidgetContainer(
                label: "Clocked In/Out",
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
                          if (clockingProvider.selectedMeetingMembers.isEmpty ||
                              clockingProvider.postClockDate == null ||
                              clockingProvider.postClockTime == null) {
                            showNormalToast(
                                'Please select date, time & members to clock-in on their behalf');
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
                                      member: null,
                                      clockingId: 0,
                                      time: clockingProvider
                                          .getPostClockDateTime(),
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
                          if (clockingProvider.selectedClockedMembers.isEmpty ||
                              clockingProvider.postClockDate == null ||
                              clockingProvider.postClockTime == null) {
                            showNormalToast(
                                'Please select date, time & members to clock-out on their behalf');
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
                                      clockingId: 0,
                                      time: clockingProvider
                                          .getPostClockDateTime(),
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
                height: 12,
              ),

              LabelWidgetContainer(
                  label: "Break Time",
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
                          function: () {
                            if (clockingProvider
                                    .selectedClockedMembers.isEmpty ||
                                clockingProvider.postClockDate == null ||
                                clockingProvider.postClockTime == null) {
                              showNormalToast(
                                  'Please select date, time & members to start break on their behalf');
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
                                        clockingId: 0,
                                        time: clockingProvider
                                            .getPostClockDateTime(),
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
                        child: CustomElevatedButton(
                          label: "End",
                          color: Colors.blue,
                          radius: 5,
                          function: () {
                            if (clockingProvider
                                    .selectedClockedMembers.isEmpty ||
                                clockingProvider.postClockDate == null ||
                                clockingProvider.postClockTime == null) {
                              showNormalToast(
                                  'Please select date, time & members to end break on their behalf');
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
                                        clockingId: 0,
                                        time: clockingProvider
                                            .getPostClockDateTime(),
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
                  )),

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
                children: [
                  Expanded(
                      child: CustomElevatedButton(
                          label: "Clocking List",
                          radius: 5,
                          function: () {
                            setState(() {
                              clockingListState = true;
                              checkAll = false;
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
                              debugPrint(
                                  '     clockingListState = $clockingListState');
                            });
                          })),
                ],
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
                          if (clockingListState) {
                            for (Member? member in members) {
                              member!.selected = checkAll;
                              if (member.selected!) {
                                clockingProvider.selectedMeetingMembers
                                    .add(member);
                              }
                              if (!member.selected!) {
                                clockingProvider.selectedMeetingMembers
                                    .remove(member);
                              }
                            }
                            debugPrint(
                                "Select Members: ${clockingProvider.selectedMeetingMembers.length}");
                          } else {
                            for (var i = 0; i < clockedMembers.length; i++) {
                              clockedMembers[i]!
                                  .additionalInfo!
                                  .memberInfo!
                                  .selected = checkAll;

                              if (clockedMembers[i]!
                                  .additionalInfo!
                                  .memberInfo!
                                  .selected!) {
                                clockingProvider.selectedClockedMembers
                                    .add(clockedMembers[i]!);
                              }
                              if (!clockedMembers[i]!
                                  .additionalInfo!
                                  .memberInfo!
                                  .selected!) {
                                clockingProvider.selectedClockedMembers
                                    .remove(clockedMembers[i]!);
                              }
                            }
                          }
                        });
                      }),
                  const Text("Check All")
                ],
              ),

              const SizedBox(
                height: 4,
              ),

              const Divider(
                height: 2,
                color: Colors.orange,
              ),

              const SizedBox(
                height: 12,
              ),

              clockingProvider.loading
                  ? const CustomProgressIndicator()
                  : clockingListState
                      ? Column(
                          children: List.generate(members.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (members[index]!.selected!) {
                                    //remove it
                                    members[index]!.selected = false;
                                    clockingProvider.selectedMeetingMembers
                                        .remove(members[index]);
                                  } else {
                                    members[index]!.selected = true;
                                    clockingProvider.selectedMeetingMembers
                                        .add(members[index]);
                                  }
                                  if (clockingProvider
                                      .selectedMeetingMembers.isNotEmpty) {
                                    itemHasBeenSelected = true;
                                  } else {
                                    itemHasBeenSelected = false;
                                  }
                                });
                                debugPrint(
                                    "Select Members: ${clockingProvider.selectedMeetingMembers.length}");
                              },
                              child: PostClockClockingMemberItem(
                                meetingEventModel:
                                    clockingProvider.selectedPastMeetingEvent,
                                member: members[index],
                              ),
                            );
                          }),
                        )
                      : Column(
                          children: List.generate(
                            clockedMembers.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      if (clockedMembers[index]!
                                          .additionalInfo!
                                          .memberInfo!
                                          .selected!) {
                                        //remove it
                                        clockedMembers[index]!
                                            .additionalInfo!
                                            .memberInfo!
                                            .selected = false;

                                        clockingProvider.selectedClockedMembers
                                            .remove(clockedMembers[index]!);
                                      } else {
                                        clockedMembers[index]!
                                            .additionalInfo!
                                            .memberInfo!
                                            .selected = true;
                                        clockingProvider.selectedClockedMembers
                                            .add(clockedMembers[index]!);
                                      }
                                      if (clockingProvider
                                          .selectedClockedMembers.isNotEmpty) {
                                        itemHasBeenSelected = true;
                                      } else {
                                        itemHasBeenSelected = false;
                                      }
                                      debugPrint(
                                          "Select Clocked Members: ${clockingProvider.selectedClockedMembers.length}");
                                    },
                                  );
                                },
                                child: PostClockClockedMemberItem(
                                  attendee: clockedMembers[index]!,
                                ),
                              );
                            },
                          ),
                        ),
              // itemHasBeenSelected?
              //     Container(
              //
              //       padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
              //       child: CustomElevatedButton(label: "Proceed to Clock",
              //       function: (){
              //         displayCustomCupertinoDialog(context: context,
              //             title: "Proceed to Clock", msg: "100 members have been selected,"
              //                 " do you want to clock them all now?",
              //             actionsMap: {"No":(){Navigator.pop(context);},
              //               "Yes":(){
              //               Navigator.pop(context);
              //               Navigator.push(context, MaterialPageRoute(builder: (_)=>
              //               const ClockingOptionsPage()));
              //               }});
              //       },),
              //     )
              //     :const SizedBox.shrink()
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // LabelWidgetContainer(
        //   label: "Branch",
        //   child: FormButton(
        //     label: "All",
        //     function: () {},
        //   ),
        // ),
        LabelWidgetContainer(
          label: "Date",
          child: FormButton(
            label: clockingProvider.selectedDate == null
                ? 'Select Date'
                : clockingProvider.selectedDate!
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
                    clockingProvider.selectedDate = value;
                    debugPrint(
                        "Selected DateTime: ${clockingProvider.selectedDate!.toIso8601String().substring(0, 10)}");
                  });
                  clockingProvider.getPastMeetingEvents();
                }
              });
            },
          ),
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
              hint: const Text('Select Meeting'),
              decoration: const InputDecoration(border: InputBorder.none),
              value: clockingProvider.selectedPastMeetingEvent,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: clockingProvider.pastMeetingEvents
                  .map((MeetingEventModel mc) {
                return DropdownMenuItem(
                  value: mc,
                  child: Text(mc.name!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  clockingProvider.selectedPastMeetingEvent =
                      val as MeetingEventModel;
                });
                clockingProvider.getMemberCategories();
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
                // call method to fetch all sub groups
                clockingProvider.getSubGroups();
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

        SizedBox(
          height: displayHeight(context) * 0.008,
        ),

        CustomElevatedButton(
            label: "Filter",
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
      ],
    );
  }
}
