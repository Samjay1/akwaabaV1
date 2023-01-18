import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/member_status.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../utils/widget_utils.dart';

class FilterPage extends StatefulWidget {
  final bool isMemberUser;
  const FilterPage({required this.isMemberUser, Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool includeLocationFilter = false;
  bool includeStatusFilter = false;
  int disabilityOption = -1;

  int selectedUserType = -1;
  String? selectedGender;
  DateTime? startYear;
  DateTime? endYear;
  int? minAge;
  int? maxAge;
  List<int> ages = [10, 11, 12, 13, 14, 15];

  selectStartPeriod() {
    displayDateSelector(
      context: context,
      initialDate: startYear ?? DateTime.now(),
      minimumDate: DateTime(DateTime.now().year - 50, 1),
      maxDate: DateTime.now(),
    ).then((value) {
      setState(() {
        startYear = value;
      });
    });
  }

  selectEndPeriod() {
    displayDateSelector(
            context: context,
            initialDate: endYear ?? DateTime.now(),
            minimumDate: DateTime(DateTime.now().year - 50, 1),
            maxDate: DateTime.now())
        .then((value) {
      setState(() {
        endYear = value;
      });
    });
  }

  selectAge({required bool isSelectingMaxAge}) {
    displayCustomDropDown(
            options: ages, listItemsIsMap: false, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          if (isSelectingMaxAge) {
            Provider.of<MembersProvider>(context, listen: false)
                .maxAgeTEC
                .text = value.toString();
          } else {
            Provider.of<MembersProvider>(context, listen: false)
                .minAgeTEC
                .text = value.toString();
          }
        });
      }
    });
  }

  late MembersProvider _membersProvider;

  String? userType;

  void loadFilters() async {
    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
    });
    Future.delayed(Duration.zero, () {
      // load all data for filters
      if (Provider.of<MembersProvider>(context, listen: false).groups.isEmpty) {
        if (userType == AppConstants.admin) {
          Provider.of<MembersProvider>(context, listen: false).getBranches();
        }
        Provider.of<MembersProvider>(context, listen: false)
            .getMemberCategories();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadFilters();
    ages = [];
    for (int i = 1; i <= 104; i++) {
      ages.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    _membersProvider = context.watch<MembersProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isMemberUser ? "Filter Members" : "Filter Organizations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
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
                                        width: 0.0,
                                        color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButtonFormField<Branch>(
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hint: const Text('Select Branch'),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    value: _membersProvider.selectedBranch,
                                    icon: Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: Colors.grey.shade500,
                                      size: 16,
                                    ),
                                    // Array list of items
                                    items: _membersProvider.branches
                                        .map((Branch branch) {
                                      return DropdownMenuItem(
                                        value: branch,
                                        child: Text(branch.name!),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _membersProvider.selectedBranch =
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
                      label: "Category",
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<MemberCategory>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Category'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _membersProvider.selectedMemberCategory,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.memberCategories
                              .map((MemberCategory category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.category!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedMemberCategory =
                                  val as MemberCategory;
                            });
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
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
                          value: _membersProvider.selectedGroup,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.groups.map((Group group) {
                            return DropdownMenuItem(
                              value: group,
                              child: Text(group.group!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedGroup = val as Group;
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
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
                          value: _membersProvider.selectedSubGroup,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.subGroups
                              .map((SubGroup subGroup) {
                            return DropdownMenuItem(
                              value: subGroup,
                              child: Text(subGroup.subgroup!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedSubGroup =
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
                      label: "Pick Registration Date Range",
                      child: Row(
                        children: [
                          Expanded(
                            child: LabelWidgetContainer(
                              label: "Start Period",
                              child: FormButton(
                                label:
                                    _membersProvider.selectedStartDate == null
                                        ? 'Start Period'
                                        : _membersProvider.selectedStartDate!
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
                                        _membersProvider.selectedStartDate =
                                            value;
                                        debugPrint(
                                            "Selected Start Date: ${_membersProvider.selectedStartDate!.toIso8601String().substring(0, 10)}");
                                      });
                                    }
                                  });
                                },
                                iconData: Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: LabelWidgetContainer(
                              label: "End Period",
                              child: FormButton(
                                label: _membersProvider.selectedEndDate == null
                                    ? 'End Period'
                                    : _membersProvider.selectedEndDate!
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
                                        _membersProvider.selectedEndDate =
                                            value;
                                        debugPrint(
                                            "Selected Start Date: ${_membersProvider.selectedEndDate!.toIso8601String().substring(0, 10)}");
                                      });
                                    }
                                  });
                                },
                                iconData: Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    LabelWidgetContainer(
                        label: "Pick Age Bracket",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FormButton(
                                label: _membersProvider.minAgeTEC.text,
                                function: () {
                                  selectAge(isSelectingMaxAge: false);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              "To",
                              //textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: FormButton(
                                label: _membersProvider.maxAgeTEC.text,
                                function: () {
                                  selectAge(isSelectingMaxAge: true);
                                },
                              ),
                            ),
                          ],
                        )),

                    Row(
                      children: [
                        CupertinoSwitch(
                            value: includeLocationFilter,
                            onChanged: (bool val) {
                              setState(() {
                                includeLocationFilter = val;
                              });
                            }),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(includeLocationFilter
                            ? "Exclude Location Filters"
                            : "Add Location Filters")
                      ],
                    ),

                    includeLocationFilter
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              LabelWidgetContainer(
                                label: "Country",
                                child: FormButton(
                                  label: "Select Country",
                                  function: () {},
                                ),
                              ),
                              LabelWidgetContainer(
                                label: "Region",
                                child: FormButton(
                                  label: "Select Region",
                                  function: () {},
                                ),
                              ),
                              LabelWidgetContainer(
                                label: "District",
                                child: FormButton(
                                  label: "Select District",
                                  function: () {},
                                ),
                              ),
                            ],
                          )
                        : Container(),

                    Row(
                      children: [
                        CupertinoSwitch(
                            value: includeStatusFilter,
                            onChanged: (bool val) {
                              setState(() {
                                includeStatusFilter = val;
                              });
                            }),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(includeStatusFilter
                            ? "Exclude Status Filters"
                            : "Add Status Filters")
                      ],
                    ),

                    includeStatusFilter
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              widget.isMemberUser
                                  ? Row(
                                      children: [
                                        const Expanded(
                                            child: Text(
                                                "Do you have a disability?")),
                                        Row(
                                          children: List.generate(2, (index) {
                                            return Row(
                                              children: [
                                                Radio(
                                                    activeColor: primaryColor,
                                                    value: index,
                                                    groupValue:
                                                        disabilityOption,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        disabilityOption =
                                                            value!;
                                                        _membersProvider
                                                                .selectedStatus =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(index == 0 ? "Yes" : "No")
                                              ],
                                            );
                                          }),
                                        )
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                            "Select Registration Status?"),
                                        Row(
                                          children: List.generate(2, (index) {
                                            return Row(
                                              children: [
                                                Radio(
                                                    activeColor: primaryColor,
                                                    value: index,
                                                    groupValue:
                                                        disabilityOption,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        disabilityOption =
                                                            value!;
                                                        _membersProvider
                                                                .selectedStatus =
                                                            value.toString();
                                                      });
                                                    }),
                                                Text(index == 0
                                                    ? "Register"
                                                    : "Unregistered")
                                              ],
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                              const SizedBox(
                                height: 16,
                              ),
                              widget.isMemberUser
                                  ? LabelWidgetContainer(
                                      label: "Marital Status",
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 0.0,
                                              color: Colors.grey.shade400),
                                        ),
                                        child: DropdownButtonFormField<
                                            MemberStatus>(
                                          isExpanded: true,
                                          style: const TextStyle(
                                            color: textColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          hint: const Text(
                                              'Select Marital Status'),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                          value: _membersProvider
                                              .selectedMaritalStatus,
                                          icon: Icon(
                                            CupertinoIcons
                                                .chevron_up_chevron_down,
                                            color: Colors.grey.shade500,
                                            size: 16,
                                          ),
                                          // Array list of items
                                          items: _membersProvider
                                              .maritalStatuses
                                              .map((MemberStatus ms) {
                                            return DropdownMenuItem(
                                              value: ms,
                                              child: Text(ms.name!),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _membersProvider
                                                      .selectedMaritalStatus =
                                                  val as MemberStatus;
                                            });
                                            // _memberProvider.getMemberCategories();
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(),
                              LabelWidgetContainer(
                                label: "Occupation",
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.0,
                                        color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButtonFormField<MemberStatus>(
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hint: const Text('Select Occupation'),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    value: _membersProvider.selectedOccupation,
                                    icon: Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: Colors.grey.shade500,
                                      size: 16,
                                    ),
                                    // Array list of items
                                    items: _membersProvider.occupations
                                        .map((MemberStatus ms) {
                                      return DropdownMenuItem(
                                        value: ms,
                                        child: Text(ms.name!),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _membersProvider.selectedOccupation =
                                            val as MemberStatus;
                                      });
                                      // _memberProvider.getMemberCategories();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.02,
                              ),
                              LabelWidgetContainer(
                                label: "Profession",
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.0,
                                        color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButtonFormField<MemberStatus>(
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hint: const Text('Select Profession'),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    value: _membersProvider.selectedProfession,
                                    icon: Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: Colors.grey.shade500,
                                      size: 16,
                                    ),
                                    // Array list of items
                                    items: _membersProvider.professions
                                        .map((MemberStatus ms) {
                                      return DropdownMenuItem(
                                        value: ms,
                                        child: Text(ms.name!),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _membersProvider.selectedProfession =
                                            val as MemberStatus;
                                      });
                                      // _memberProvider.getMemberCategories();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: displayHeight(context) * 0.02,
                              ),
                              LabelWidgetContainer(
                                label: "Educational Level",
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.0,
                                        color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButtonFormField<MemberStatus>(
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hint:
                                        const Text('Select Educational Level'),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    value: _membersProvider.selectedEducation,
                                    icon: Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: Colors.grey.shade500,
                                      size: 16,
                                    ),
                                    // Array list of items
                                    items: _membersProvider.educations
                                        .map((MemberStatus ms) {
                                      return DropdownMenuItem(
                                        value: ms,
                                        child: Text(ms.name!),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _membersProvider.selectedEducation =
                                            val as MemberStatus;
                                      });
                                      // _memberProvider.getMemberCategories();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.02,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _membersProvider.clearFilters();
                      },
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
                      function: () {
                        _membersProvider.isFilter = true; // update filter flag
                        Navigator.pop(context);
                        _membersProvider.validateFilterFields(
                            isMember: widget.isMemberUser);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}