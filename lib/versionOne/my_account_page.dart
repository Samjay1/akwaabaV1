import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/models/general/electoralArea.dart';
import 'package:akwaaba/versionOne/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../components/custom_cached_image_widget.dart';
import '../components/event_shimmer_item.dart';
import '../components/profile_shimmer_item.dart';
import '../components/text_shimmer_item.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
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

  void _getMyProfile() async {
    myProfile = (await MemberAPI().getFullProfileInfo());
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
    Future.delayed(const Duration(seconds: 8)).then((value) {
      print('1. Region ID ${myProfile?.region}'); // Don't touch
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
      DateTime? mydate = DateTime.parse(olddate!);
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
                      // profileItemView(title: "Group", label: "-"),
                      // profileItemView(title: "Sub Group", label: "-"),
                      profileItemView(
                          title: "Branch",
                          label: "${myProfile?.branchInfo['name']}"),
                      profileItemView(
                          title: "Category",
                          label: "${myProfile?.categoryInfo['category']}"),
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

                      const SizedBox(
                        height: 24,
                      ),

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
                      const SizedBox(
                        height: 24,
                      ),
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
            " ${myProfile?.firstname} ${myProfile?.surname} ",
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UpdateProfile()));
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
                // Icon(
                //   display?Icons.visibility:Icons.visibility_off
                // )
              ],
            ),
          ],
        ));
  }
}
