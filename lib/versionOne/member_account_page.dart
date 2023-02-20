import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/versionOne/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/update_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/custom_cached_image_widget.dart';
import '../models/admin/clocked_member.dart';

class MemberAccountPage extends StatefulWidget {
  final Member? member;
  final String? userType;
  const MemberAccountPage(
      {Key? key, required this.member, required this.userType})
      : super(key: key);

  @override
  State<MemberAccountPage> createState() => _MemberAccountPageState();
}

class _MemberAccountPageState extends State<MemberAccountPage> {
  Color dividerColor = Colors.grey.shade300;
  double dividerHeight = 7;

  bool enabledEditing = false;

  @override
  initState() {
    enabledEditing = widget.member!.editable!;
    _getMemberGroups();
    _getMemberSubGroups();
    super.initState();
  }

  // GROUP - GROUPS
  List<Group> groups = [];
  void _getMemberGroups() async {
    groups = await MemberAPI().getMemberGroups(memberId: widget.member!.id!);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  // GROUP - SUBGROUPS
  List<SubGroup> subGroups = [];
  void _getMemberSubGroups() async {
    subGroups =
        await MemberAPI().getMemberSubGroups(memberId: widget.member!.id!);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            //header
            SliverAppBar(
              // backgroundColor: primaryColor,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                // statusBarIconBrightness: Brightness.light, // For Android (dark icons)
                // statusBarBrightness: Brightness.dark, // For iOS (dark icons)
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [headerView()],
                ),
              ),
              automaticallyImplyLeading: true,
              floating: true,
              pinned: true,
              expandedHeight: 300,
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: dividerHeight,
                color: dividerColor,
              ),
              profileItemView(
                title: "Phone",
                label: widget.member!.phone == null
                    ? "N/A"
                    : widget.member!.phone!,
                display: true,
              ),
              profileItemView(
                title: "Email",
                label: widget.member!.email == null
                    ? "N/A"
                    : widget.member!.email!,
                display: true,
              ),
              profileItemView(
                title: "Date of Birth",
                label: widget.member!.dateOfBirth == null
                    ? 'N/A'
                    : widget.member!.dateOfBirth!,
              ),
              profileItemView(
                title: "ReferenceId",
                label: widget.member!.referenceId == null
                    ? "N/A"
                    : widget.member!.referenceId!,
                display: false,
              ),
              profileItemView(
                title: "Gender",
                label: widget.member!.gender == 1 ? "Male" : "Female",
                display: true,
              ),
              profileItemView(title: "Profession", label: "N/A", display: true),
              profileItemView(
                  title: "Place of work", label: "N/A", display: true),
              profileItemView(
                  title: "Date Joined",
                  label: DateUtil.formatStringDate(DateFormat.yMMMEd(),
                      date: DateTime.parse(widget.member!.date!))),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: dividerHeight,
                color: dividerColor,
              ),
              const SizedBox(
                height: 24,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Group",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              profileItemView(
                title: "Branch",
                label: widget.member!.branchInfo != null
                    ? widget.member!.branchInfo!.name!
                    : 'N/A',
              ),
              profileItemView(
                title: "Category",
                label: widget.member!.categoryInfo != null
                    ? widget.member!.categoryInfo!.category!
                    : 'N/A',
              ),
              profileItemView(
                  title: groups.length > 1 ? "Groups" : "Group",
                  label: groups
                      .map((e) => e.group)
                      .toList()
                      .toString()
                      .substring(
                          1,
                          groups
                                  .map((e) => e.group)
                                  .toList()
                                  .toString()
                                  .length -
                              1)),
              profileItemView(
                  title: groups.length > 1 ? "SubGroups" : "SubGroup",
                  label: subGroups
                      .map((e) => e.subgroup)
                      .toList()
                      .toString()
                      .substring(
                          1,
                          subGroups
                                  .map((e) => e.subgroup)
                                  .toList()
                                  .toString()
                                  .length -
                              1)),

              Container(
                height: dividerHeight,
                color: dividerColor,
              ),
              const SizedBox(
                height: 24,
              ),
              // Location section
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Location",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              profileItemView(
                  title: "Region",
                  label: widget.member!.regionInfo == null
                      ? 'N/A'
                      : widget.member!.regionInfo!.location!),
              profileItemView(
                  title: "District",
                  label: widget.member!.districtInfo == null
                      ? 'N/A'
                      : widget.member!.districtInfo!.location!),
              profileItemView(
                  title: "Constituency",
                  label: widget.member!.constituencyInfo == null
                      ? 'N/A'
                      : widget.member!.constituencyInfo!.location!),
              profileItemView(
                  title: "Electoral Area",
                  label: widget.member!.electoralareaInfo == null
                      ? 'N/A'
                      : widget.member!.electoralareaInfo!.location!),
              profileItemView(
                  title: "Community",
                  label: widget.member!.community == null
                      ? 'N/A'
                      : widget.member!.community!.toString()),
              profileItemView(
                  title: "Home Town",
                  label: widget.member!.hometown == null
                      ? 'N/A'
                      : widget.member!.hometown!.toString()),
              // profileItemView(
              //     title: "Residential Area",
              //     label: widget.member!.countryOfResidence!.toString()),
              profileItemView(
                  title: "Digital Address",
                  label: widget.member!.digitalAddress == null
                      ? 'N/A'
                      : widget.member!.digitalAddress!),
              const SizedBox(
                height: 24,
              ),

              widget.member!.updatedBy != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: dividerHeight,
                          color: dividerColor,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Last Profile Update",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        profileItemView(
                            title: "Update on",
                            label: widget.member!.updateDate == null
                                ? 'N/A'
                                : DateUtil.formatStringDate(DateFormat.yMMMEd(),
                                    date: DateTime.parse(
                                        widget.member!.updateDate!))),
                        profileItemView(
                          title: "Updated by",
                          label: widget.member!.updatedBy == 0
                              ? 'Self'
                              : 'Admin (${widget.member!.updatedByInfo!.firstname!.capitalize()} ${widget.member!.updatedByInfo!.surname!.capitalize()})',
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget headerView() {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 175,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 45,
                    child: Container(
                      decoration: const BoxDecoration(color: primaryColor),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    child: widget.member!.profilePicture != null
                        ? Align(
                            child: CustomCachedImageWidget(
                              url: widget.member!.profilePicture!,
                              height: 100,
                            ),
                          )
                        : defaultProfilePic(height: 100),
                  )
                ],
              ),
            ),
            Text(
              "${widget.member!.firstname!.capitalize()} ${widget.member!.middlename!.isEmpty ? '' : widget.member!.middlename!.capitalize()} ${widget.member!.surname!.capitalize()}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColorPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text("ID : ${widget.member!.identification}"),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Status: ${widget.member!.status == 1 ? 'Active' : 'Inactive'}",
            ),
            // ß
            SizedBox(
              height: displayHeight(context) * 0.005,
            ),
            widget.userType == AppConstants.admin
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UpdateProfile(memberId: widget.member!.id!),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        primary: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultRadius))),
                    child: const Text("Update Account"),
                  )
                : const SizedBox(),
            widget.userType == AppConstants.admin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoSwitch(
                          value: enabledEditing,
                          onChanged: (bool val) {
                            setState(() {
                              enabledEditing = val;
                            });

                            if (enabledEditing) {
                              debugPrint('Enabling...');
                              Provider.of<MembersProvider>(context,
                                      listen: false)
                                  .enableSingleProfileEditing(
                                memberId: widget.member!.id!,
                              );
                            } else {
                              Provider.of<MembersProvider>(context,
                                      listen: false)
                                  .disableSingleProfileEditing(
                                memberId: widget.member!.id!,
                              );
                              debugPrint('Disabling...');
                            }
                            debugPrint('Enable: $enabledEditing');
                          }),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        enabledEditing ? "Disable" : "Enable",
                        style: const TextStyle(
                          color: textColorPrimary,
                          fontSize: 17,
                        ),
                      )
                    ],
                  )
                : const SizedBox(),

            SizedBox(
              height: displayHeight(context) * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItemView(
      {required String title, required String label, bool display = false}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(display ? Icons.visibility : Icons.visibility_off)
                ],
              ),
            ),
          ],
        ));
  }
}
