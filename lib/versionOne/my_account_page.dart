import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/general/electoralArea.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../components/custom_cached_image_widget.dart';
import '../components/profile_shimmer_item.dart';
import '../components/text_shimmer_item.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/district.dart';
import '../models/general/region.dart';
import '../models/members/previewMemberProfile.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  Color dividerColor = Colors.grey.shade300;
  double dividerHeight = 7;
  PreviewMemberProfile? myProfile;

  Future<void> _getMyProfile() async {
    myProfile =
        await MemberAPI().getFullProfileInfo(memberId: await getMemberId());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  Future<int> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('memberId')!;
  }

  // GROUP - GROUPS
  List<Group> groups = [];
  void _getMemberGroups() async {
    groups = await MemberAPI().getMemberGroups(memberId: await getMemberId());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  // GROUP - SUBGROUPS
  List<SubGroup> subGroups = [];
  void _getMemberSubGroups() async {
    subGroups =
        await MemberAPI().getMemberSubGroups(memberId: await getMemberId());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  //LOCATION - REGION
  Region? singleRegion;
  void _getSingleRegion({required regionId}) async {
    singleRegion = await MemberAPI().getSingleRegion(regionId: regionId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  //LOCATION - DISTRICT
  District? singleDistrict;
  void _getSingleDistrict({required districtId}) async {
    singleDistrict =
        await MemberAPI().getSingleDistrict(districtId: districtId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  //LOCATION - CONSTITUENCY
  Constituency? singleConstituency;
  void _getsingleConstituency({required ConstId}) async {
    singleConstituency =
        await MemberAPI().getSingleConstituency(ConstId: ConstId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  //LOCATION - ELECTORAL AREA
  ElectoralArea? singleElectoral;
  void _getsingleElectoralArea({required electoralId}) async {
    singleElectoral =
        await MemberAPI().getSingleElectoralArea(electoralId: electoralId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  String? formatedDate;
  @override
  void initState() {
    // TODO: implement initState
    _getMyProfile();
    _getMemberGroups();
    _getMemberSubGroups();
    Future.delayed(const Duration(seconds: 8)).then((value) {
      print('1. Region ID: ${myProfile?.region}'); // Don't touch
      _getSingleRegion(regionId: myProfile?.region);
      _getSingleDistrict(districtId: myProfile?.district);
      _getsingleConstituency(
        ConstId: myProfile?.constituency,
      );
      _getsingleElectoralArea(
        electoralId: myProfile?.electoralArea,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late var olddate = myProfile?.date;
    if (olddate != null) {
      DateTime? mydate = DateTime.parse(olddate);
      formatedDate = '${mydate.day}-${mydate.month}-${mydate.year}';
    }
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
                  children: [
                    myProfile?.firstname == null
                        ? Shimmer.fromColors(
                            baseColor: greyColorShade300,
                            highlightColor: greyColorShade100,
                            child: const ProfileShimmerItem(),
                          )
                        : headerView()
                  ],
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
            child: myProfile?.firstname == null
                ? Shimmer.fromColors(
                    baseColor: greyColorShade300,
                    highlightColor: greyColorShade100,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const TextShimmerItem(),
                    ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //padding: EdgeInsets.all(16),
                    children: [
                      Container(
                        height: dividerHeight,
                        color: dividerColor,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Bio Info",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      profileItemView(
                          title: "Firstname", label: "${myProfile?.firstname}"),
                      profileItemView(
                          title: "Middle name",
                          label: "${myProfile?.middlename}"),
                      profileItemView(
                          title: "Surname", label: "${myProfile?.surname}"),
                      profileItemView(
                          title: "Email", label: "${myProfile?.email}"),
                      profileItemView(
                          title: "Date of Birth",
                          label: "${myProfile?.dateOfBirth}"),
                      profileItemView(
                          title: "Gender",
                          label: myProfile?.gender == 1 ? 'Male' : 'Female',
                          display: true),
                      profileItemView(
                          title: "Reference Id",
                          label: "${myProfile?.referenceId}"),
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
                          label: "${myProfile?.branchInfo['name']}"),
                      profileItemView(
                          title: "Category",
                          label: "${myProfile?.categoryInfo['category']}"),
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
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Location",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      profileItemView(
                          title: "Country",
                          label: "${myProfile?.countryOfResidence}"),
                      profileItemView(
                          title: "Region",
                          label: singleRegion?.location == null
                              ? "-"
                              : "${singleRegion?.location}"),
                      profileItemView(
                          title: "District",
                          label: singleDistrict?.location == null
                              ? "-"
                              : "${singleDistrict?.location}"),
                      profileItemView(
                          title: "Constituency",
                          label: singleConstituency?.location == null
                              ? "-"
                              : "${singleConstituency?.location}"),
                      profileItemView(
                          title: "Electoral Area",
                          label: singleElectoral?.location == null
                              ? "-"
                              : "${singleElectoral?.location}"),
                      profileItemView(
                          title: "Community",
                          label: myProfile?.community == null
                              ? "-"
                              : "${myProfile?.community}"),
                      profileItemView(
                          title: "Home Town",
                          label: myProfile?.hometown == null
                              ? "-"
                              : "${myProfile?.hometown}"),
                      profileItemView(
                          title: "Residential Area",
                          label: myProfile?.houseNoDigitalAddress == null
                              ? "-"
                              : "${myProfile?.houseNoDigitalAddress}"),
                      profileItemView(
                          title: "Digital Address",
                          label: myProfile?.digitalAddress == null
                              ? "-"
                              : "${myProfile?.digitalAddress}"),
                      Container(
                        height: dividerHeight,
                        color: dividerColor,
                      ),
                      profileItemView(
                          title: "CV",
                          label: myProfile?.profileResume != null
                              ? 'Submitted'
                              : "N/A",
                          display: true),
                      profileItemView(
                          title: "ID Card",
                          label: myProfile?.profileIdentification != null
                              ? 'Submitted'
                              : "N/A",
                          display: true),
                      profileItemView(
                          title: "Date Joined",
                          label: "$formatedDate",
                          display: true),
                      myProfile?.updatedBy != null
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                profileItemView(
                                    title: "Update on",
                                    label: myProfile?.updateDate == null
                                        ? 'N/A'
                                        : DateUtil.formatStringDate(
                                            DateFormat.yMMMEd(),
                                            date: DateTime.parse(
                                                myProfile!.updateDate!))),
                                profileItemView(
                                  title: "Updated by",
                                  label: myProfile?.updatedBy == 0
                                      ? 'Self'
                                      : 'Admin (${myProfile?.updatedByInfo!.firstname!.capitalize()} ${myProfile?.updatedByInfo!.surname!.capitalize()})',
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  )),
      ),
    );
  }

  Widget headerView() {
    return Container(
      color: backgroundColor,
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
                  top: 50,
                  child: myProfile?.profilePicture != null
                      ? Align(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CustomCachedImageWidget(
                              url: '${myProfile?.profilePicture}',
                              height: 125,
                            ),
                          ),
                        )
                      : defaultProfilePic(height: 130),
                )
              ],
            ),
          ),
          Text(
            " ${myProfile?.firstname!.capitalize()} ${(myProfile?.middlename == null || myProfile!.middlename!.isEmpty) ? '' : myProfile?.middlename!.capitalize()} ${myProfile?.surname!.capitalize()} ",
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColorPrimary,
                fontSize: 20),
          ),
          const SizedBox(
            height: 12,
          ),
          Text("ID :  ${myProfile?.identification}"),
          const SizedBox(
            height: 6,
          ),
          myProfile?.status == 1
              ? const Text("Status: Active")
              : const Text("Status: InActive"),
          const SizedBox(
            height: 6,
          ),
          OutlinedButton(
            onPressed: () {
              if (myProfile!.editable!) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UpdateProfile(
                              memberId: null,
                            )));
              } else {
                showInfoDialog(
                  'ok',
                  context: context,
                  title: 'Hey there!',
                  content:
                      'Sorry, you currently do not have access to update your profile, contact Admin for assistance. Thanks!',
                  onTap: () => Navigator.pop(context),
                );
              }
            },
            style: OutlinedButton.styleFrom(
                primary: primaryColor,
                side: const BorderSide(color: primaryColor, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius))),
            child: const Text("Update Account"),
          ),
        ],
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
            Text(
              title,
            ),
            SizedBox(
              width: displayWidth(context) * 0.05,
            ),
            Expanded(
                child: Text(
              label,
              textAlign: TextAlign.end,
            )),
          ],
        ));
  }
}
