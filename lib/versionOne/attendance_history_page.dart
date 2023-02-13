import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/custom_date_picker.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/search_util.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/filter_loader.dart';
import '../utils/widget_utils.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late AttendanceHistoryProvider attendanceHistoryProvider;

  String? userType;

  bool isShowTopView = true;

  bool isTileExpanded = false;

  final _debouncer = Debouncer(milliseconds: AppConstants.searchTimerDuration);

  @override
  void initState() {
    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
    });

    Future.delayed(Duration.zero, () {
      Provider.of<AttendanceHistoryProvider>(context, listen: false)
          .setCurrentContext(context);
      // check if admin is main branch admin or not
      if (userType == AppConstants.admin &&
          Provider.of<ClientProvider>(context, listen: false).branch.id ==
              AppConstants.mainAdmin) {
        Provider.of<AttendanceHistoryProvider>(context, listen: false)
            .getBranches();
      }
      Provider.of<AttendanceHistoryProvider>(context, listen: false)
          .getAllMeetingEvents();

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
    attendanceHistoryProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    attendanceHistoryProvider = context.watch<AttendanceHistoryProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Attendance History"),
      ),
      body: RefreshIndicator(
        onRefresh: () => attendanceHistoryProvider.refreshList(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              //filterButton(),
              userType == AppConstants.member
                  ? const SizedBox()
                  : SizedBox(
                      height: displayHeight(context) * 0.02,
                    ),
              userType == AppConstants.member
                  ? const SizedBox()
                  : CupertinoSearchTextField(
                      padding: const EdgeInsets.all(AppPadding.p14),
                      controller: attendanceHistoryProvider.searchNameTEC,
                      onChanged: (val) {
                        setState(() {
                          attendanceHistoryProvider.search = val;
                        });
                        _debouncer.run(() {
                          attendanceHistoryProvider.getAttendanceHistory();
                        });
                      },
                      onSubmitted: (val) {
                        setState(() {
                          attendanceHistoryProvider.search = val;
                        });
                        attendanceHistoryProvider.getAttendanceHistory();
                      },
                    ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              _historyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterOptionsList() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LabelWidgetContainer(
                  label: "Start Date",
                  child: CustomDatePicker(
                    hintText: 'Select Start Date',
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                    onChanged: (dateString) {
                      setState(() {
                        attendanceHistoryProvider.selectedStartDate =
                            DateTime.parse(dateString);
                      });
                      debugPrint(
                          "Selected Start Date: ${attendanceHistoryProvider.selectedStartDate!.toIso8601String().substring(0, 10)}");
                    },
                    onSaved: (dateString) {
                      attendanceHistoryProvider.selectedStartDate =
                          DateTime.parse(dateString!);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: displayWidth(context) * 0.03,
              ),
              Expanded(
                child: LabelWidgetContainer(
                  label: "End Date",
                  child: CustomDatePicker(
                    hintText: 'Select End Date',
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                    onChanged: (dateString) {
                      setState(() {
                        attendanceHistoryProvider.selectedEndDate =
                            DateTime.parse(dateString);
                      });
                      debugPrint(
                          "Selected End Date: ${attendanceHistoryProvider.selectedEndDate!.toIso8601String().substring(0, 10)}");
                    },
                    onSaved: (dateString) {
                      attendanceHistoryProvider.selectedEndDate =
                          DateTime.parse(dateString!);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Consumer<ClientProvider>(
            builder: (context, data, child) {
              return ((data.branch != null) &&
                      (data.branch.id == AppConstants.mainAdmin &&
                          userType == AppConstants.admin))
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
                          value: attendanceHistoryProvider.selectedBranch,
                          icon: attendanceHistoryProvider.loadingFilters
                              ? const FilterLoader()
                              : Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: Colors.grey.shade500,
                                  size: 16,
                                ),
                          // Array list of items
                          items: attendanceHistoryProvider.branches
                              .map((Branch branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              attendanceHistoryProvider.selectedBranch =
                                  val as Branch;
                            });
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          userType == AppConstants.admin
              ? SizedBox(
                  height: displayHeight(context) * 0.02,
                )
              : const SizedBox(),
          LabelWidgetContainer(
            label: "Meeting/Event",
            child: GFMultiSelect<MeetingEventModel>(
              items: attendanceHistoryProvider.pastMeetingEvents
                  .map((mc) => mc.name)
                  .toList(),
              onSelect: (value) {
                setState(() {
                  attendanceHistoryProvider
                      .setSelectedMeetingEventIndexes(value.cast<int>());
                });
              },
              dropdownTitleTileText: 'Select Meeting',
              dropdownTitleTileMargin: const EdgeInsets.all(0),
              dropdownTitleTilePadding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p16, horizontal: AppPadding.p8),
              dropdownUnderlineBorder:
                  const BorderSide(color: Colors.transparent, width: 2),
              dropdownTitleTileBorder:
                  Border.all(color: Colors.grey[300]!, width: 1),
              dropdownTitleTileBorderRadius: BorderRadius.circular(10),
              expandedIcon: attendanceHistoryProvider.loadingFilters
                  ? const FilterLoader()
                  : Icon(
                      CupertinoIcons.chevron_up_chevron_down,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
              collapsedIcon: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,
              ),
              size: GFSize.SMALL,
              submitButton: const Text('OK'),
              cancelButton: const Text('Cancel'),
              buttonColor: primaryColor,
              dropdownTitleTileTextStyle: const TextStyle(
                color: textColorPrimary,
                fontSize: AppSize.s15,
                fontWeight: FontWeight.w400,
              ),
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.all(6),
              type: GFCheckboxType.circle,
              activeBgColor: GFColors.SUCCESS,
              activeBorderColor: GFColors.SUCCESS,
              inactiveBorderColor: Colors.grey[300]!,
            ),
          ),
          userType == AppConstants.admin
              ? SizedBox(
                  height: displayHeight(context) * 0.02,
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? LabelWidgetContainer(
                  label: "Member Category",
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 0.0, color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonFormField<MemberCategory>(
                      isExpanded: true,
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      hint: const Text('Select Member Category'),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      value: attendanceHistoryProvider.selectedMemberCategory,
                      icon: attendanceHistoryProvider.loadingFilters
                          ? const FilterLoader()
                          : Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                      // Array list of items
                      items: attendanceHistoryProvider.memberCategories
                          .map((MemberCategory mc) {
                        return DropdownMenuItem(
                          value: mc,
                          child: Text(mc.category!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          attendanceHistoryProvider.selectedMemberCategory =
                              val as MemberCategory;
                        });
                        attendanceHistoryProvider.getGroups();
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? SizedBox(
                  height: displayHeight(context) * 0.02,
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? LabelWidgetContainer(
                  label: "Group",
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 0.0, color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonFormField<Group>(
                      isExpanded: true,
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      hint: const Text('Select Group'),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      value: attendanceHistoryProvider.selectedGroup,
                      icon: attendanceHistoryProvider.loadingFilters
                          ? const FilterLoader()
                          : Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                      // Array list of items
                      items:
                          attendanceHistoryProvider.groups.map((Group group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group.group!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          attendanceHistoryProvider.selectedGroup =
                              val as Group;
                        });
                        attendanceHistoryProvider.getSubGroups();
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? SizedBox(
                  height: displayHeight(context) * 0.02,
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? LabelWidgetContainer(
                  label: "Sub Group",
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 0.0, color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonFormField<SubGroup>(
                      isExpanded: true,
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      hint: const Text('Select SubGroup'),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      value: attendanceHistoryProvider.selectedSubGroup,
                      icon: attendanceHistoryProvider.loadingFilters
                          ? const FilterLoader()
                          : Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                      // Array list of items
                      items: attendanceHistoryProvider.subGroups
                          .map((SubGroup subGroup) {
                        return DropdownMenuItem(
                          value: subGroup,
                          child: Text(
                              '${subGroup.groupId!.group!} => ${subGroup.subgroup!}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          attendanceHistoryProvider.selectedSubGroup =
                              val as SubGroup;
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? SizedBox(
                  height: displayHeight(context) * 0.02,
                )
              : const SizedBox(),
          userType == AppConstants.admin
              ? LabelWidgetContainer(
                  label: "Gender",
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 0.0, color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonFormField<Gender>(
                      isExpanded: true,
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      hint: const Text('Select Gender'),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      value: attendanceHistoryProvider.selectedGender,
                      icon: attendanceHistoryProvider.loadingFilters
                          ? const FilterLoader()
                          : Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                      // Array list of items
                      items: attendanceHistoryProvider.genders
                          .map((Gender gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender.name!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          attendanceHistoryProvider.selectedGender =
                              val as Gender;
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          LabelWidgetContainer(
            label: "Status",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                hint: const Text('Select Status'),
                decoration: const InputDecoration(border: InputBorder.none),
                value: attendanceHistoryProvider.selectedStatus,
                icon: attendanceHistoryProvider.loadingFilters
                    ? const FilterLoader()
                    : Icon(
                        CupertinoIcons.chevron_up_chevron_down,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                // Array list of items
                items: attendanceHistoryProvider.statuses.map((String status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceHistoryProvider.selectedStatus = val as String;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          userType == AppConstants.admin
              ? Row(
                  children: [
                    Expanded(
                      child: LabelWidgetContainer(
                        label: "Minimum Age",
                        child: FormTextField(
                          controller: attendanceHistoryProvider.minAgeTEC,
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
                          controller: attendanceHistoryProvider.maxAgeTEC,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          SizedBox(
            height: displayHeight(context) * 0.008,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () => attendanceHistoryProvider.clearFilters(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
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
                      //showErrorToast('This feature is under development');
                      attendanceHistoryProvider.validateFilterFields(context);
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
          backgroundColor: backgroundColor,
          collapsedBackgroundColor: Colors.white,
          initiallyExpanded: isTileExpanded,
          onExpansionChanged: (value) {
            setState(() {
              isTileExpanded = value;
            });
            debugPrint("Expanded: $isTileExpanded");
          },
          title: const Text(
            "Filter Options",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[filterOptionsList()],
        ),
      ),
    );
  }

  Widget _historyList() {
    return attendanceHistoryProvider.loading
        ? Expanded(
            child: Shimmer.fromColors(
              baseColor: greyColorShade300,
              highlightColor: greyColorShade100,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, __) => const EventShimmerItem(),
                itemCount: 20,
              ),
            ),
          )
        : Expanded(
            child: Column(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: _handleScrollNotification,
                  child: Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      controller:
                          attendanceHistoryProvider.historyScrollController,
                      children: attendanceHistoryProvider
                              .attendanceRecords.isEmpty
                          ? [const EmptyStateWidget(text: 'No records found!')]
                          : List.generate(
                              attendanceHistoryProvider
                                  .attendanceRecords.length, (index) {
                              return AttendanceHistoryItemWidget(
                                attendanceHistory: attendanceHistoryProvider
                                    .attendanceRecords[index],
                                userType: userType,
                              );
                            }),
                    ),
                  ),
                ),
                if (attendanceHistoryProvider.loadingMore)
                  const PaginationLoader(
                    loadingText: 'Loading. please wait...',
                  )
              ],
            ),
          );
  }
}
