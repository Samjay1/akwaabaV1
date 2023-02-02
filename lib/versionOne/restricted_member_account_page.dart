import 'package:akwaaba/models/general/restricted_member.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../components/custom_cached_image_widget.dart';

class RestrictedMemberAccountPage extends StatefulWidget {
  final RestrictedMember? restrictedMember;
  final String? userType;
  const RestrictedMemberAccountPage(
      {Key? key, required this.restrictedMember, required this.userType})
      : super(key: key);

  @override
  State<RestrictedMemberAccountPage> createState() =>
      _RestrictedMemberAccountPageState();
}

class _RestrictedMemberAccountPageState
    extends State<RestrictedMemberAccountPage> {
  Color dividerColor = Colors.grey.shade300;
  double dividerHeight = 7;

  bool enabledEditing = false;

  @override
  initState() {
    enabledEditing = widget.restrictedMember!.member!.editable!;
    super.initState();
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
              expandedHeight: 235,
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
              widget.restrictedMember!.contacts == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        profileItemView(
                          title: "Phone",
                          label: widget.restrictedMember!.member!.phone == null
                              ? "N/A"
                              : widget.restrictedMember!.member!.phone!,
                          display: true,
                        ),
                        profileItemView(
                          title: "Email",
                          label: widget.restrictedMember!.member!.email == null
                              ? "N/A"
                              : widget.restrictedMember!.member!.email!,
                          display: true,
                        ),
                      ],
                    ),
              profileItemView(
                title: "Date of Birth",
                label: widget.restrictedMember!.member!.dateOfBirth == null
                    ? 'N/A'
                    : widget.restrictedMember!.member!.dateOfBirth!,
                display: true,
              ),
              profileItemView(
                title: "ReferenceId",
                label: widget.restrictedMember!.member!.referenceId == null
                    ? "N/A"
                    : widget.restrictedMember!.member!.referenceId!,
                display: true,
              ),
              profileItemView(
                title: "Gender",
                label: widget.restrictedMember!.member!.gender == 1
                    ? "Male"
                    : "Female",
                display: true,
              ),
              profileItemView(title: "Profession", label: "N/A", display: true),
              widget.restrictedMember!.contacts == null
                  ? const SizedBox()
                  : profileItemView(
                      title: "Place of work", label: "N/A", display: true),
              profileItemView(
                title: "Date Joined",
                label: DateUtil.formatStringDate(
                  DateFormat.yMMMEd(),
                  date: DateTime.parse(widget.restrictedMember!.member!.date!),
                ),
                display: true,
              ),
              widget.restrictedMember!.group == null
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        profileItemView(
                          title: "Branch",
                          label: widget.restrictedMember!.branch != null
                              ? widget.restrictedMember!.branch!.name!
                              : 'N/A',
                          display: true,
                        ),
                        profileItemView(
                          title: "Category",
                          label: widget.restrictedMember!.category != null
                              ? widget.restrictedMember!.category!.category!
                              : 'N/A',
                          display: true,
                        ),
                      ],
                    ),
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
              widget.restrictedMember!.location == null
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        profileItemView(
                          title: "Region",
                          label:
                              widget.restrictedMember!.location!.region == null
                                  ? 'N/A'
                                  : widget.restrictedMember!.location!.region!
                                      .location!,
                          display: true,
                        ),
                        profileItemView(
                          title: "District",
                          label: widget.restrictedMember!.location!.district ==
                                  null
                              ? 'N/A'
                              : widget.restrictedMember!.location!.district!
                                  .location!,
                          display: true,
                        ),
                        profileItemView(
                          title: "Constituency",
                          label:
                              widget.restrictedMember!.location!.constituency ==
                                      null
                                  ? 'N/A'
                                  : widget.restrictedMember!.location!
                                      .constituency!.location!,
                          display: true,
                        ),
                        profileItemView(
                          title: "Electoral Area",
                          label: widget.restrictedMember!.location!
                                      .electoralArea ==
                                  null
                              ? 'N/A'
                              : widget.restrictedMember!.location!.electoralArea
                                  .location!,
                          display: true,
                        ),
                        profileItemView(
                          title: "Community",
                          label:
                              widget.restrictedMember!.member!.community == null
                                  ? 'N/A'
                                  : widget.restrictedMember!.member!.community!
                                      .toString(),
                          display: true,
                        ),
                        profileItemView(
                          title: "Home Town",
                          label:
                              widget.restrictedMember!.member!.hometown == null
                                  ? 'N/A'
                                  : widget.restrictedMember!.member!.hometown!
                                      .toString(),
                          display: true,
                        ),
                        // profileItemView(
                        //     title: "Residential Area",
                        //     label: widget.member!.countryOfResidence!.toString()),
                        profileItemView(
                          title: "Digital Address",
                          label:
                              widget.restrictedMember!.member!.digitalAddress ==
                                      null
                                  ? 'N/A'
                                  : widget.restrictedMember!.member!
                                      .digitalAddress!,
                          display: true,
                        ),
                      ],
                    ),
              const SizedBox(
                height: 24,
              )
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
                    child:
                        widget.restrictedMember!.member!.profilePicture != null
                            ? Align(
                                child: CustomCachedImageWidget(
                                  url: widget.restrictedMember!.member!
                                      .profilePicture!,
                                  height: 100,
                                ),
                              )
                            : defaultProfilePic(height: 100),
                  )
                ],
              ),
            ),
            Text(
              "${widget.restrictedMember!.member!.firstname} ${widget.restrictedMember!.member!.surname}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColorPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
                "ID : ${widget.restrictedMember!.member!.identification ?? 'N/A'}"),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Status: ${widget.restrictedMember!.member!.status == 1 ? 'Active' : 'Inactive'}",
            ),
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
              width: 12,
            ),
            Row(
              children: [
                Text(label),
                const SizedBox(
                  width: 12,
                ),
                Icon(display ? Icons.visibility : Icons.visibility_off)
              ],
            ),
          ],
        ));
  }
}
