import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/marital_status.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterMembersPage extends StatefulWidget {
  final int selectedIndex;
  const FilterMembersPage({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<FilterMembersPage> createState() => _FilterMembersPageState();
}

class _FilterMembersPageState extends State<FilterMembersPage> {
  bool includeLocationFilter = false;

  late MembersProvider _membersProvider;

  void loadFilters() async {
    Future.delayed(Duration.zero, () {
      // load all data for filters
      if (Provider.of<MembersProvider>(context, listen: false).groups.isEmpty) {
        Provider.of<MembersProvider>(context, listen: false).getGroups();
      }
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    loadFilters();
  }

  @override
  Widget build(BuildContext context) {
    _membersProvider = context.watch<MembersProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Members"),
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
                      label: "Marital Status",
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<MaritalStatus>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Marital Status'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _membersProvider.selectedMaritalStatus,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.maritalStatuses
                              .map((MaritalStatus ms) {
                            return DropdownMenuItem(
                              value: ms,
                              child: Text(ms.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedMaritalStatus =
                                  val as MaritalStatus;
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
                      label: "Occupation",
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<MaritalStatus>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Occupation'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _membersProvider.selectedOccupation,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.occupations
                              .map((MaritalStatus ms) {
                            return DropdownMenuItem(
                              value: ms,
                              child: Text(ms.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedOccupation =
                                  val as MaritalStatus;
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
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<MaritalStatus>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Profession'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _membersProvider.selectedProfession,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.professions
                              .map((MaritalStatus ms) {
                            return DropdownMenuItem(
                              value: ms,
                              child: Text(ms.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedProfession =
                                  val as MaritalStatus;
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
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<MaritalStatus>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Educational Level'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _membersProvider.selectedEducation,
                          icon: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: Colors.grey.shade500,
                            size: 16,
                          ),
                          // Array list of items
                          items: _membersProvider.educations
                              .map((MaritalStatus ms) {
                            return DropdownMenuItem(
                              value: ms,
                              child: Text(ms.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _membersProvider.selectedEducation =
                                  val as MaritalStatus;
                            });
                            // _memberProvider.getMemberCategories();
                          },
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     CupertinoSwitch(
                    //         value: includeLocationFilter,
                    //         onChanged: (bool val) {
                    //           setState(() {
                    //             includeLocationFilter = val;
                    //           });
                    //         }),
                    //     const SizedBox(
                    //       width: 8,
                    //     ),
                    //     Text(includeLocationFilter
                    //         ? "Exclude Location Filters"
                    //         : "Add Location Filters")
                    //   ],
                    // ),
                    // includeLocationFilter
                    //     ? Column(
                    //         crossAxisAlignment: CrossAxisAlignment.stretch,
                    //         children: [
                    //           const SizedBox(
                    //             height: 16,
                    //           ),
                    //           LabelWidgetContainer(
                    //             label: "Country",
                    //             child: FormButton(
                    //               label: "Select Country",
                    //               function: () {},
                    //             ),
                    //           ),
                    //           LabelWidgetContainer(
                    //             label: "Region",
                    //             child: FormButton(
                    //               label: "Select Region",
                    //               function: () {},
                    //             ),
                    //           ),
                    //           LabelWidgetContainer(
                    //             label: "District",
                    //             child: FormButton(
                    //               label: "Select District",
                    //               function: () {},
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),
                  ],
                ),
              ),
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
                            selectedIndex: widget.selectedIndex);
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
