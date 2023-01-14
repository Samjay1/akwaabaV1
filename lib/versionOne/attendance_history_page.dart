import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/attendance_history_provider.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/attendance_history_item.dart';
import '../utils/widget_utils.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late AttendanceHistoryProvider attendanceHistoryProvider;

  String? userType;

  @override
  void initState() {
    Provider.of<AttendanceHistoryProvider>(context, listen: false)
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
        Provider.of<AttendanceHistoryProvider>(context, listen: false)
            .getBranches();
      } else {
        Provider.of<AttendanceHistoryProvider>(context, listen: false)
            .getGenders();
      }

      setState(() {});
    });
    super.initState();
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
      appBar: AppBar(
        title: const Text("Attendance History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // controller: attendanceHistoryProvider.historyScrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              filterButton(),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              CupertinoSearchTextField(
                // onChanged: (val) {
                //   setState(() {
                //     attendanceProvider.search = val;
                //   });
                // },
                onSubmitted: (val) {
                  setState(() {
                    attendanceHistoryProvider.search = val;
                  });
                  // attendanceHistoryProvider.getAttendanceHistory();
                },
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
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
                  child: FormButton(
                    label: attendanceHistoryProvider.selectedStartDate == null
                        ? 'Select Start Date'
                        : attendanceHistoryProvider.selectedStartDate!
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
                            attendanceHistoryProvider.selectedStartDate = value;
                            debugPrint(
                                "Selected Start Date: ${attendanceHistoryProvider.selectedStartDate!.toIso8601String().substring(0, 10)}");
                          });
                          // if admin is main branch admin
                          if (context.read<ClientProvider>().branch.id == 1) {
                            attendanceHistoryProvider.getBranches();
                          }
                          // admin is just a branch admin
                          attendanceHistoryProvider.getPastMeetingEvents();
                        }
                      });
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
                  child: FormButton(
                    label: attendanceHistoryProvider.selectedEndDate == null
                        ? 'Select End Date'
                        : attendanceHistoryProvider.selectedEndDate!
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
                            attendanceHistoryProvider.selectedEndDate = value;
                            debugPrint(
                                "Selected Start Date: ${attendanceHistoryProvider.selectedEndDate!.toIso8601String().substring(0, 10)}");
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
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
                          value: attendanceHistoryProvider.selectedBranch,
                          icon: Icon(
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
                            attendanceHistoryProvider.getPastMeetingEvents();
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
                value: attendanceHistoryProvider.selectedPastMeetingEvent,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceHistoryProvider.pastMeetingEvents
                    .map((MeetingEventModel mc) {
                  return DropdownMenuItem(
                    value: mc,
                    child: Text(mc.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceHistoryProvider.selectedPastMeetingEvent =
                        val as MeetingEventModel;
                  });
                  attendanceHistoryProvider.getMemberCategories();
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
                value: attendanceHistoryProvider.selectedMemberCategory,
                icon: Icon(
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
                  attendanceHistoryProvider.getMemberCategories();
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
                value: attendanceHistoryProvider.selectedGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceHistoryProvider.groups.map((Group group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(group.group!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceHistoryProvider.selectedGroup = val as Group;
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
                value: attendanceHistoryProvider.selectedSubGroup,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceHistoryProvider.subGroups
                    .map((SubGroup subGroup) {
                  return DropdownMenuItem(
                    value: subGroup,
                    child: Text(subGroup.subgroup!),
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
                value: attendanceHistoryProvider.selectedGender,
                icon: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
                // Array list of items
                items: attendanceHistoryProvider.genders.map((Gender gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    attendanceHistoryProvider.selectedGender = val as Gender;
                  });
                },
              ),
            ),
          ),
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
                icon: Icon(
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
          Row(
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
          ),
          SizedBox(
            height: displayHeight(context) * 0.008,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () => attendanceHistoryProvider.clearData(),
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
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: attendanceHistoryProvider.attendanceRecords.isEmpty
          ? [const EmptyStateWidget(text: 'No Attendance History')]
          : List.generate(attendanceHistoryProvider.attendanceRecords.length,
              (index) {
              return AttendanceHistoryItemWidget(
                attendanceHistory:
                    attendanceHistoryProvider.attendanceRecords[index],
              );
            }),
    );
  }
}
