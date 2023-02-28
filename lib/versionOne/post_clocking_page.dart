import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/filter_loader.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/pagination_loader.dart';
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
import 'package:akwaaba/providers/post_clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/search_util.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];
  DateTime? generalClockTime;
  bool checkAll = false;

  bool clockingListState = true;

  bool isFilterExpanded = false;

  late PostClockingProvider postClockingProvider;

  final _debouncer = Debouncer(milliseconds: AppConstants.searchTimerDuration);

  bool isShowTopView = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (context.read<ClientProvider>().branch.id == 1) {
        Provider.of<PostClockingProvider>(context, listen: false).getBranches();
      }
      Provider.of<PostClockingProvider>(context, listen: false)
          .setCurrentContext(context);
      Provider.of<PostClockingProvider>(context, listen: false)
          .getAllMeetingEvents();
      // Provider.of<PostClockingProvider>(context, listen: false)
      //     .getMemberCategories();
      setState(() {});
    });
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
    if (context.mounted) {
      postClockingProvider.clearData();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    postClockingProvider = context.watch<PostClockingProvider>();
    var absentees = postClockingProvider.absentees;
    var attendees = postClockingProvider.attendees;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: () => postClockingProvider.refreshList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isShowTopView
                  ? Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            filterButton(),

                            const SizedBox(
                              height: 12,
                            ),

                            CupertinoSearchTextField(
                              padding: const EdgeInsets.all(AppPadding.p14),
                              controller: postClockingProvider.searchNameTEC,
                              onSubmitted: (val) {
                                setState(() {
                                  postClockingProvider.searchName = val;
                                });
                                val.isEmpty
                                    ? postClockingProvider.isSearch = false
                                    : postClockingProvider.isSearch = true;
                                if (clockingListState) {
                                  // search absentees by name
                                  if (absentees.isNotEmpty) {
                                    postClockingProvider.getAllAbsentees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  }
                                } else {
                                  // search attendees by name
                                  if (attendees.isNotEmpty) {
                                    postClockingProvider.getAllAttendees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  }
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  postClockingProvider.searchName = val;
                                });
                                val.isEmpty
                                    ? postClockingProvider.isSearch = false
                                    : postClockingProvider.isSearch = true;
                                _debouncer.run(() {
                                  if (clockingListState) {
                                    // search absentees by name
                                    postClockingProvider.getAllAbsentees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  } else {
                                    // search attendees by name
                                    //postClockingProvider.searchName = val;
                                    postClockingProvider.getAllAttendees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  }
                                });
                              },
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            CupertinoSearchTextField(
                              padding: const EdgeInsets.all(AppPadding.p14),
                              placeholder: "Enter ID",
                              controller: postClockingProvider.searchIDTEC,
                              keyboardType: TextInputType.number,
                              onSubmitted: (val) {
                                setState(() {
                                  postClockingProvider.searchIdentity = val;
                                });
                                val.isEmpty
                                    ? postClockingProvider.isSearch = false
                                    : postClockingProvider.isSearch = true;
                                if (clockingListState) {
                                  // search absentees by id
                                  if (absentees.isNotEmpty) {
                                    postClockingProvider.getAllAbsentees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  }
                                } else {
                                  // search attendees by id
                                  if (attendees.isNotEmpty) {
                                    postClockingProvider.getAllAttendees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  }
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  postClockingProvider.searchIdentity = val;
                                });
                                val.isEmpty
                                    ? postClockingProvider.isSearch = false
                                    : postClockingProvider.isSearch = true;
                                _debouncer.run(() {
                                  if (clockingListState) {
                                    postClockingProvider.getAllAbsentees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
                                  } else {
                                    postClockingProvider.getAllAttendees(
                                      meetingEventModel: postClockingProvider
                                          .selectedPastMeetingEvent!,
                                    );
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
                            InkWell(
                              onTap: () async {
                                var time = await DateUtil.selectTime(context);
                                postClockingProvider.postClockTime =
                                    DateUtil.convertTimeOfDayTo12hour(
                                        timeOfDay: time!, showAMPM: false);
                                postClockingProvider.displayClockTime =
                                    DateUtil.convertTimeOfDayTo12hour(
                                        timeOfDay: time, showAMPM: true);
                                debugPrint(
                                    "Selected: ${postClockingProvider.postClockTime}");
                                debugPrint(
                                    "Display: ${postClockingProvider.displayClockTime}");
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(AppPadding.p14),
                                decoration: BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.borderRadius8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: whiteColor,
                                      size: 24,
                                    ),
                                    Expanded(
                                      child: Text(
                                        postClockingProvider.displayClockTime ??
                                            'Select Post Clock Time',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: whiteColor,
                                          fontSize: AppSize.s16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: whiteColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
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
                                            postClockingProvider.selectedDate ==
                                                null ||
                                            postClockingProvider
                                                    .postClockTime ==
                                                null) {
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
                                                  postClockingProvider
                                                      .clockMemberIn(
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
                                    child: CustomOutlinedButton(
                                      label: "Out",
                                      mycolor: Colors.red,
                                      radius: 5,
                                      function: () {
                                        if (postClockingProvider
                                                .selectedAttendees.isEmpty ||
                                            postClockingProvider.selectedDate ==
                                                null ||
                                            postClockingProvider
                                                    .postClockTime ==
                                                null) {
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
                                                  postClockingProvider
                                                      .clockMemberOut(
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
                              ),
                            ),
                            (postClockingProvider.selectedPastMeetingEvent !=
                                        null &&
                                    postClockingProvider
                                        .selectedPastMeetingEvent!
                                        .hasBreakTime!)
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
                                                      .selectedAttendees
                                                      .isEmpty ||
                                                  postClockingProvider
                                                          .selectedDate ==
                                                      null ||
                                                  postClockingProvider
                                                          .postClockTime ==
                                                      null) {
                                                showInfoDialog(
                                                  'ok',
                                                  context: context,
                                                  title: 'Sorry!',
                                                  content:
                                                      'Please select the time & members to start break on their behalf. Thank you!',
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
                                                        postClockingProvider
                                                            .startMeetingBreak(
                                                          context: context,
                                                          attendee: null,
                                                          time: postClockingProvider
                                                              .getPostClockDateTime(),
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
                                            color: primaryColor,
                                            labelSize: 15,
                                            radius: 5,
                                            function: () {
                                              if (postClockingProvider
                                                      .selectedAttendees
                                                      .isEmpty ||
                                                  postClockingProvider
                                                          .selectedDate ==
                                                      null ||
                                                  postClockingProvider
                                                          .postClockTime ==
                                                      null) {
                                                showInfoDialog(
                                                  'ok',
                                                  context: context,
                                                  title: 'Sorry!',
                                                  content:
                                                      'Please select the time & members to end break on their behalf. Thank you!',
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
                                                        postClockingProvider
                                                            .endMeetingBreak(
                                                          context: context,
                                                          attendee: null,
                                                          time: postClockingProvider
                                                              .getPostClockDateTime(),
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
                                    ))
                                : const SizedBox(),
                            SizedBox(
                              height: displayHeight(context) * 0.01,
                            ),
                            const Divider(
                              height: 2,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),

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
                          debugPrint('clockingListState = $clockingListState');
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: clockingListState
                                ? primaryColor
                                : Colors.transparent,
                            border: Border.all(color: primaryColor, width: 1.2),
                            borderRadius:
                                BorderRadius.circular(AppRadius.borderRadius8)),
                        child: Center(
                          child: Text(
                            'Clocking List',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color:
                                  clockingListState ? whiteColor : primaryColor,
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
                          debugPrint('clockingListState = $clockingListState');
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: !clockingListState
                                ? primaryColor
                                : Colors.transparent,
                            border: Border.all(color: primaryColor, width: 1.2),
                            borderRadius:
                                BorderRadius.circular(AppRadius.borderRadius8)),
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
                  ? Expanded(
                      child: Shimmer.fromColors(
                        baseColor: greyColorShade300,
                        highlightColor: greyColorShade100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => const EventShimmerItem(),
                          itemCount: 10,
                        ),
                      ),
                    )
                  : clockingListState
                      ? Expanded(
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
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: postClockingProvider
                                                .absenteesScrollController,
                                            itemCount: absentees.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (absentees[index]!
                                                        .selected!) {
                                                      //remove it
                                                      absentees[index]!
                                                          .selected = false;
                                                      postClockingProvider
                                                          .selectedAbsentees
                                                          .remove(
                                                              absentees[index]);
                                                    } else {
                                                      absentees[index]!
                                                          .selected = true;
                                                      postClockingProvider
                                                          .selectedAbsentees
                                                          .add(
                                                              absentees[index]);
                                                    }
                                                    if (postClockingProvider
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
                                                      "Select Absentees: ${postClockingProvider.selectedAbsentees.length}");
                                                },
                                                child:
                                                    PostClockClockingMemberItem(
                                                  attendee: absentees[index],
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (postClockingProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
                                      )
                                  ],
                                ),
                        )
                      : Expanded(
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
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: postClockingProvider
                                                .attendeesScrollController,
                                            itemCount: attendees.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      if (attendees[index]!
                                                          .selected!) {
                                                        //remove it
                                                        attendees[index]!
                                                            .selected = false;

                                                        postClockingProvider
                                                            .selectedAttendees
                                                            .remove(attendees[
                                                                index]!);
                                                      } else {
                                                        attendees[index]!
                                                            .selected = true;
                                                        postClockingProvider
                                                            .selectedAttendees
                                                            .add(attendees[
                                                                index]!);
                                                      }
                                                      if (postClockingProvider
                                                          .selectedAttendees
                                                          .isNotEmpty) {
                                                        itemHasBeenSelected =
                                                            true;
                                                      } else {
                                                        itemHasBeenSelected =
                                                            false;
                                                      }
                                                      debugPrint(
                                                          "Selected Attendees: ${postClockingProvider.selectedAttendees.length}");
                                                    },
                                                  );
                                                },
                                                child:
                                                    PostClockClockedMemberItem(
                                                  attendee: attendees[index]!,
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    if (postClockingProvider.loadingMore)
                                      const PaginationLoader(
                                        loadingText: 'Loading. please wait...',
                                      )
                                  ],
                                ),
                        )
              // : Column(
              //     children: attendees.isEmpty
              //         ? [
              //             const EmptyStateWidget(
              //               text: 'No attendees found!',
              //             )
              //           ]
              //         : List.generate(
              //             attendees.length,
              //             (index) {
              //               return GestureDetector(
              //                 onTap: () {
              //                   setState(
              //                     () {
              //                       if (attendees[index]!.selected!) {
              //                         //remove it
              //                         attendees[index]!.selected =
              //                             false;

              //                         postClockingProvider
              //                             .selectedAttendees
              //                             .remove(attendees[index]!);
              //                       } else {
              //                         attendees[index]!.selected = true;
              //                         postClockingProvider
              //                             .selectedAttendees
              //                             .add(attendees[index]!);
              //                       }
              //                       if (postClockingProvider
              //                           .selectedAttendees.isNotEmpty) {
              //                         itemHasBeenSelected = true;
              //                       } else {
              //                         itemHasBeenSelected = false;
              //                       }
              //                       debugPrint(
              //                           "Select Attendees: ${postClockingProvider.selectedAttendees.length}");
              //                     },
              //                   );
              //                 },
              //                 child: PostClockClockedMemberItem(
              //                   attendee: attendees[index]!,
              //                 ),
              //               );
              //             },
              //           ),
              //   ),
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
                icon: postClockingProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
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
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Date",
            child: FormButton(
              label: postClockingProvider.selectedDate == null
                  ? "Select Date"
                  : postClockingProvider.selectedDate!
                      .toIso8601String()
                      .substring(0, 10),
              function: () async {
                postClockingProvider.selectedDate = await DateUtil.selectDate(
                  context: context,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                );
                setState(() {});
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
                          value: postClockingProvider.selectedBranch,
                          icon: postClockingProvider.loadingFilters
                              ? const FilterLoader()
                              : Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: Colors.grey.shade500,
                                  size: 16,
                                ),
                          // Array list of items
                          items: postClockingProvider.branches
                              .map((Branch branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              postClockingProvider.selectedBranch =
                                  val as Branch;
                            });
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
                value: postClockingProvider.selectedMemberCategory,
                icon: postClockingProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
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
                  postClockingProvider.getGroups();
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
                icon: postClockingProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
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
                  postClockingProvider.getSubGroups();
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
                icon: postClockingProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
                        CupertinoIcons.chevron_up_chevron_down,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                // Array list of items
                items: postClockingProvider.subGroups.map((SubGroup subGroup) {
                  return DropdownMenuItem(
                    value: subGroup,
                    child: Text(
                        '${subGroup.groupId!.group!} => ${subGroup.subgroup!}'),
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
                icon: postClockingProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
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
                    onTap: () => postClockingProvider.clearFilters(),
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
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
