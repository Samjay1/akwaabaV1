import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/member_clock_selection_widget.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/attendance/attendance.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/screens/clocking_options_page.dart';
import 'package:akwaaba/screens/filter_members_page.dart';
import 'package:akwaaba/screens/filter_options_for_clocking_page.dart';
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

class ClockingPage extends StatefulWidget {
  final MeetingEventModel meetingEventModel;
  const ClockingPage({Key? key, required this.meetingEventModel})
      : super(key: key);

  @override
  State<ClockingPage> createState() => _ClockingPageState();
}

class _ClockingPageState extends State<ClockingPage> {
  final TextEditingController _controllerMinAge = TextEditingController();
  final TextEditingController _controllerMaxAge = TextEditingController();

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

  bool clockingListState = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      // load attendance list for meeting
      Provider.of<ClockingProvider>(context, listen: false).getAttendanceList(
        meetingEventModel: widget.meetingEventModel,
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var clockingProvider = context.watch<ClockingProvider>();
    var members = clockingProvider.meetingMembers;
    var clockedMembers = clockingProvider.clockedMembers;
    var selectedMembers = clockingProvider.selectedMeetingMembers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock member'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ClockingProvider>(context, listen: false)
            .getAttendanceList(meetingEventModel: widget.meetingEventModel),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                const CupertinoSearchTextField(),
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

                const CupertinoSearchTextField(
                  placeholder: "Enter ID",
                ),

                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),

                const Text("Age Bracket"),
                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    Expanded(
                      child: LabelWidgetContainer(
                        label: "Minimum Age",
                        child: FormTextField(
                          controller: _controllerMinAge,
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
                          controller: _controllerMaxAge,
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: displayHeight(context) * 0.008,
                ),

                CustomElevatedButton(label: "Filter", function: () {}),

                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),

                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     //REFRESING BUTTON
                //     InkWell(
                //         onTap: () {},
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 5, horizontal: 10),
                //           decoration: BoxDecoration(
                //               color: Colors.green,
                //               borderRadius: BorderRadius.circular(5)),
                //           child: const Text('Refresh',
                //               style: TextStyle(color: Colors.white)),
                //         )),
                //     SizedBox(
                //       width: displayWidth(context) * 0.02,
                //     ),
                //     //POST CLOCK DATE BUTTON
                //     Expanded(
                //       child: InkWell(
                //           onTap: () {},
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 5, horizontal: 10),
                //             decoration: BoxDecoration(
                //                 color: Colors.blue,
                //                 borderRadius: BorderRadius.circular(5)),
                //             child: const Text(
                //               'Post Clock Date',
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           )),
                //     ),
                //     SizedBox(
                //       width: displayWidth(context) * 0.02,
                //     ),
                //     //POST CLOCK TIME BUTTON
                //     Expanded(
                //       child: InkWell(
                //           onTap: () {},
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 5, horizontal: 10),
                //             decoration: BoxDecoration(
                //                 color: Colors.blue,
                //                 borderRadius: BorderRadius.circular(5)),
                //             child: const Text(
                //               'Post Clock Time',
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           )),
                //     )
                //   ],
                // ), // CustomElevatedButton(label: "Filter", function: (){}),\

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
                            if (clockingProvider
                                .selectedMeetingMembers.isEmpty) {
                              showNormalToast(
                                  'Please select members to clock-in on their behalf');
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
                            if (clockingProvider
                                .selectedClockedMembers.isEmpty) {
                              showNormalToast(
                                  'Please select members to clock-out on their behalf');
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
                                  .selectedClockedMembers.isEmpty) {
                                showNormalToast(
                                    'Please select members to start break on their behalf');
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
                          child: CustomElevatedButton(
                            label: "End",
                            color: Colors.blue,
                            radius: 5,
                            function: () {
                              if (clockingProvider
                                  .selectedClockedMembers.isEmpty) {
                                showNormalToast(
                                    'Please select members to end break on their behalf');
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
                              debugPrint(
                                  "Select Clocked Members: ${clockingProvider.selectedClockedMembers.length}");
                              // for (Member? member in clockedMembers) {
                              //   member!.selected = checkAll;
                              // }
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
                                child: ClockingMemberItem(
                                  meetingEventModel: widget.meetingEventModel,
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

                                          clockingProvider
                                              .selectedClockedMembers
                                              .remove(clockedMembers[index]!);
                                        } else {
                                          clockedMembers[index]!
                                              .additionalInfo!
                                              .memberInfo!
                                              .selected = true;
                                          clockingProvider
                                              .selectedClockedMembers
                                              .add(clockedMembers[index]!);
                                        }
                                        if (clockingProvider
                                            .selectedClockedMembers
                                            .isNotEmpty) {
                                          itemHasBeenSelected = true;
                                        } else {
                                          itemHasBeenSelected = false;
                                        }
                                        debugPrint(
                                            "Select Clocked Members: ${clockingProvider.selectedClockedMembers.length}");
                                      },
                                    );
                                  },
                                  child: ClockedMemberItem(
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
      children: [
        LabelWidgetContainer(
          label: "Branch",
          child: FormButton(
            label: "All",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Member Category",
          child: FormButton(
            label: "All",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Group",
          child: FormButton(
            label: "Select Group",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Sub Group",
          child: FormButton(
            label: "Select Sub Group",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
            label: "Meeting Type",
            child: FormButton(
              label: "Select Meeting Type",
              function: () {},
            )),
        LabelWidgetContainer(
            label: "Date",
            child: FormButton(
              label: "Select Date",
              function: () {},
            )),
        LabelWidgetContainer(
          label: "Set Mass Time",
          child: FormButton(
            label: generalClockTime != null
                ? DateFormat("hh:mm").format(generalClockTime!)
                : "Select time",
            function: () {},
          ),
        ),
      ],
    );
  }
}
