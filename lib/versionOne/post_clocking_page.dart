import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/postclock_clocked_member_item.dart';
import 'package:akwaaba/components/postclock_clocking_member_item.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/providers/post_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/form_textfield.dart';
import '../providers/client_provider.dart';

class PostClockingPage extends StatefulWidget {
  const PostClockingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostClockingPage> createState() => _PostClockingPageState();
}

class _PostClockingPageState extends State<PostClockingPage> {
  late ScrollController _controller;

  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];
  DateTime? generalClockTime;
  bool checkAll = false;

  bool clockingListState = true;

  bool isFilterExpanded = false;

  late PostClockingProvider postClockingProvider;

  @override
  void initState() {
    _controller = ScrollController();
    Provider.of<PostClockingProvider>(context, listen: false)
        .setCurrentContext(context);
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
    postClockingProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    postClockingProvider = context.watch<PostClockingProvider>();
    var absentees = postClockingProvider.absentees;
    var attendees = postClockingProvider.attendees;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => postClockingProvider.refreshList(),
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
                        postClockingProvider.searchAbsenteesByName(
                            searchText: val);
                      } else {
                        // search atendees by name
                        postClockingProvider.searchAttendeesByName(
                            searchText: val);
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
                        // search absentees by id
                        postClockingProvider.searchAbsenteesById(
                            searchText: val);
                      } else {
                        // search atendees by id
                        postClockingProvider.searchAttendeesById(
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
                  color: primaryColor,
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //REFRESING BUTTON
                    // Expanded(
                    //   child: InkWell(
                    //       onTap: () => postClockingProvider.clearData(),
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 10, horizontal: 10),
                    //         decoration: BoxDecoration(
                    //           color: fillColor,
                    //           borderRadius: BorderRadius.circular(
                    //             AppDimen.borderRadius8,
                    //           ),
                    //         ),
                    //         child: const Text(
                    //           'Clear',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(color: Colors.red, fontSize: 15),
                    //         ),
                    //       )),
                    // ),
                    // SizedBox(
                    //   width: displayWidth(context) * 0.02,
                    // ),
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
                                  postClockingProvider.postClockTime = value;
                                  debugPrint(
                                    "Selected PostClock Time: ${postClockingProvider.postClockTime!.toIso8601String().substring(11, 19)}",
                                  );
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              postClockingProvider.postClockTime == null
                                  ? 'Select Post Clock Time'
                                  : DateFormat.jm().format(
                                      postClockingProvider.postClockTime!),
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
                  height: displayHeight(context) * 0.00,
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
                            if (postClockingProvider
                                    .selectedAbsentees.isEmpty ||
                                postClockingProvider.selectedDate == null ||
                                postClockingProvider.postClockTime == null) {
                              showInfoDialog(
                                'ok',
                                context: context,
                                title: 'Sorry!',
                                content:
                                    'Please select the time & members to clock-in on their behalf. Thank you!',
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
                                      postClockingProvider.clockMemberIn(
                                        context: context,
                                        attendee: null,
                                        time: postClockingProvider
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
                            if (postClockingProvider
                                    .selectedAttendees.isEmpty ||
                                postClockingProvider.selectedDate == null ||
                                postClockingProvider.postClockTime == null) {
                              showInfoDialog(
                                'ok',
                                context: context,
                                title: 'Sorry!',
                                content:
                                    'Please select the time & members to clock-out on their behalf. Thank you!',
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
                                      postClockingProvider.clockMemberOut(
                                        context: context,
                                        attendee: null,
                                        time: postClockingProvider
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
                  height: 4,
                ),

                (postClockingProvider.selectedPastMeetingEvent != null &&
                        postClockingProvider
                            .selectedPastMeetingEvent!.hasBreakTime!)
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
                                textColor: whiteColor,
                                color: Colors.green,
                                labelSize: 15,
                                radius: 5,
                                function: () {
                                  if (postClockingProvider
                                          .selectedAttendees.isEmpty ||
                                      postClockingProvider.selectedDate ==
                                          null ||
                                      postClockingProvider.postClockTime ==
                                          null) {
                                    showInfoDialog(
                                      'ok',
                                      context: context,
                                      title: 'Sorry!',
                                      content:
                                          'Please select the time & members to start break on their behalf. Thank you!',
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
                                            postClockingProvider
                                                .startMeetingBreak(
                                              context: context,
                                              attendee: null,
                                              time: postClockingProvider
                                                  .getPostClockDateTime(),
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
                                color: primaryColor,
                                labelSize: 15,
                                radius: 5,
                                function: () {
                                  if (postClockingProvider
                                          .selectedAttendees.isEmpty ||
                                      postClockingProvider.selectedDate ==
                                          null ||
                                      postClockingProvider.postClockTime ==
                                          null) {
                                    showInfoDialog(
                                      'ok',
                                      context: context,
                                      title: 'Sorry!',
                                      content:
                                          'Please select the time & members to end break on their behalf. Thank you!',
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
                                            postClockingProvider
                                                .endMeetingBreak(
                                              context: context,
                                              attendee: null,
                                              time: postClockingProvider
                                                  .getPostClockDateTime(),
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
                        ))
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            clockingListState = true;
                            checkAll = false;
                            postClockingProvider.selectedAttendees.clear();
                            debugPrint(
                                'clockingListState = $clockingListState');
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: clockingListState
                                  ? primaryColor
                                  : Colors.transparent,
                              border:
                                  Border.all(color: primaryColor, width: 1.2),
                              borderRadius: BorderRadius.circular(
                                  AppRadius.borderRadius8)),
                          child: Center(
                            child: Text(
                              'Clocking List',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: clockingListState
                                    ? whiteColor
                                    : primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * 0.03,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            clockingListState = false;
                            checkAll = false;
                            postClockingProvider.selectedAbsentees.clear();
                            debugPrint(
                                'clockingListState = $clockingListState');
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: !clockingListState
                                  ? primaryColor
                                  : Colors.transparent,
                              border:
                                  Border.all(color: primaryColor, width: 1.2),
                              borderRadius: BorderRadius.circular(
                                  AppRadius.borderRadius8)),
                          child: Center(
                            child: Text(
                              'Clocked List',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: !clockingListState
                                    ? whiteColor
                                    : primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                            if (clockingListState) {
                              for (Attendee? absentee in absentees) {
                                absentee!.selected = checkAll;
                                if (absentee.selected!) {
                                  postClockingProvider.selectedAbsentees
                                      .add(absentee);
                                }
                                if (!absentee.selected!) {
                                  postClockingProvider.selectedAbsentees
                                      .remove(absentee);
                                }
                              }
                              debugPrint(
                                  "Select Absentees: ${postClockingProvider.selectedAbsentees.length}");
                            } else {
                              for (Attendee? attendee in attendees) {
                                attendee!.selected = checkAll;
                                if (attendee.selected!) {
                                  postClockingProvider.selectedAttendees
                                      .add(attendee);
                                }
                                if (!attendee.selected!) {
                                  postClockingProvider.selectedAttendees
                                      .remove(attendee);
                                }
                              }
                              debugPrint(
                                  "Select attendees: ${postClockingProvider.selectedAttendees.length}");
                            }
                          });
                        }),
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

                postClockingProvider.loading
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
                                            postClockingProvider
                                                .selectedAbsentees
                                                .remove(absentees[index]);
                                          } else {
                                            absentees[index]!.selected = true;
                                            postClockingProvider
                                                .selectedAbsentees
                                                .add(absentees[index]);
                                          }
                                          if (postClockingProvider
                                              .selectedAbsentees.isNotEmpty) {
                                            itemHasBeenSelected = true;
                                          } else {
                                            itemHasBeenSelected = false;
                                          }
                                        });
                                        debugPrint(
                                            "Select Abseentees: ${postClockingProvider.selectedAbsentees.length}");
                                      },
                                      child: PostClockClockingMemberItem(
                                        attendee: absentees[index],
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

                                                postClockingProvider
                                                    .selectedAttendees
                                                    .remove(attendees[index]!);
                                              } else {
                                                attendees[index]!.selected =
                                                    true;
                                                postClockingProvider
                                                    .selectedAttendees
                                                    .add(attendees[index]!);
                                              }
                                              if (postClockingProvider
                                                  .selectedAttendees
                                                  .isNotEmpty) {
                                                itemHasBeenSelected = true;
                                              } else {
                                                itemHasBeenSelected = false;
                                              }
                                              debugPrint(
                                                  "Select Attendees: ${postClockingProvider.selectedAttendees.length}");
                                            },
                                          );
                                        },
                                        child: PostClockClockedMemberItem(
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
            label: postClockingProvider.selectedDate == null
                ? 'Select Date'
                : postClockingProvider.selectedDate!
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
                    postClockingProvider.selectedDate = value;
                    debugPrint(
                        "Selected DateTime: ${postClockingProvider.selectedDate!.toIso8601String().substring(0, 10)}");
                  });
                  // if admin is main branch admin
                  if (context.read<ClientProvider>().branch.id == 1) {
                    postClockingProvider.getBranches();
                  }
                  // admin is just a branch admin
                  postClockingProvider.getPastMeetingEvents();
                }
              });
            },
          ),
        ),
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
                        value: postClockingProvider.selectedBranch,
                        icon: Icon(
                          CupertinoIcons.chevron_up_chevron_down,
                          color: Colors.grey.shade500,
                          size: 16,
                        ),
                        // Array list of items
                        items:
                            postClockingProvider.branches.map((Branch branch) {
                          return DropdownMenuItem(
                            value: branch,
                            child: Text(branch.name!),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            postClockingProvider.selectedBranch = val as Branch;
                          });
                          postClockingProvider.getPastMeetingEvents();
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
              value: postClockingProvider.selectedPastMeetingEvent,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: postClockingProvider.pastMeetingEvents
                  .map((MeetingEventModel mc) {
                return DropdownMenuItem(
                  value: mc,
                  child: Text(mc.name!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  postClockingProvider.selectedPastMeetingEvent =
                      val as MeetingEventModel;
                });
                postClockingProvider.getMemberCategories();
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
              value: postClockingProvider.selectedMemberCategory,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: postClockingProvider.memberCategories
                  .map((MemberCategory mc) {
                return DropdownMenuItem(
                  value: mc,
                  child: Text(mc.category!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  postClockingProvider.selectedMemberCategory =
                      val as MemberCategory;
                });
                postClockingProvider.getMemberCategories();
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
              value: postClockingProvider.selectedGroup,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: postClockingProvider.groups.map((Group group) {
                return DropdownMenuItem(
                  value: group,
                  child: Text(group.group!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  postClockingProvider.selectedGroup = val as Group;
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
              value: postClockingProvider.selectedSubGroup,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: postClockingProvider.subGroups.map((SubGroup subGroup) {
                return DropdownMenuItem(
                  value: subGroup,
                  child: Text(subGroup.subgroup!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  postClockingProvider.selectedSubGroup = val as SubGroup;
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
              value: postClockingProvider.selectedGender,
              icon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              // Array list of items
              items: postClockingProvider.genders.map((Gender gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender.name!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  postClockingProvider.selectedGender = val as Gender;
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
                  controller: postClockingProvider.minAgeTEC,
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
                  controller: postClockingProvider.maxAgeTEC,
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
                  onTap: () => postClockingProvider.clearData(),
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
                    postClockingProvider.validateFilterFields(context);
                    if (postClockingProvider.loading) {
                      // scroll to bottom of the screen to show the loading progress
                      _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        duration: const Duration(seconds: 3),
                        curve: Curves.ease,
                      );
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
