import 'package:akwaaba/screens/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/custom_cached_image_widget.dart';
import '../providers/member_provider.dart';

class MemberAccountPage extends StatefulWidget {
  const MemberAccountPage({Key? key}) : super(key: key);

  @override
  State<MemberAccountPage> createState() => _MemberAccountPageState();
}

class _MemberAccountPageState extends State<MemberAccountPage> {
  Color dividerColor = Colors.grey.shade300;
  double dividerHeight=7;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<MemberProvider>(context,listen: false).clientAccountInfo;
    var region = data.region;
    debugPrint('CLIENT ACCOUTN INFO ${region}');
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<MemberProvider>(
          builder: (context, data, child)
    {
      return NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [ //header
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
                      headerView(
                          profileImage: data.clientAccountInfo.profilePicture)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //padding: EdgeInsets.all(16),
              children: [
                Container(
                  height: dividerHeight,
                  color: dividerColor,
                ),
                profileItemView(title: "Date of Birth",
                    label: "${data.clientAccountInfo.applicantGender}"),
                profileItemView(title: "Gender",
                    label: data.clientAccountInfo.applicantGender == 1
                        ? 'Male'
                        : 'Female',
                    display: true),
                profileItemView(
                    title: "Profession", label: "N/A", display: true),
                profileItemView(
                    title: "Place of work", label: "N/A", display: true),
                profileItemView(title: "Date Joined", label: "N/A"),
                const SizedBox(height: 24,),
                Container(
                  height: dividerHeight,
                  color: dividerColor,
                ),
                const SizedBox(height: 24,),

                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text("Group", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),),
                ),
                profileItemView(title: "Group", label: "Senior Staff"),
                profileItemView(title: "Sub Group", label: "N/A"),

                const SizedBox(height: 24,),
                Container(
                  height: dividerHeight,
                  color: dividerColor,
                ),
                const SizedBox(height: 24,),


                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text("Location", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),),
                ),
                profileItemView(title: "Region", label: "Region"),
                profileItemView(title: "District", label: "N/A"),
                profileItemView(title: "Constituency", label: "N/A"),
                profileItemView(title: "Electoral Area", label: "N/A"),
                profileItemView(title: "Community", label: "N/A"),
                profileItemView(title: "Home Town", label: "N/A"),
                profileItemView(title: "Residential Area", label: "N/A"),
                profileItemView(title: "Digital Address", label: "N/A"),

                const SizedBox(height: 24,)
              ],
            ),
          ),
      );
    })
    );
  }

  Widget headerView({profileImage}){
    return  Container(
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
                    decoration: const BoxDecoration(
                        color: primaryColor
                    ),
                  ),
                ),
                Positioned(
                    top: 70,
                    child:GestureDetector(
                      child: profileImage != null
                          ? Align(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: CustomCachedImageWidget(
                            url: profileImage,
                            height: 130,
                          ),
                        ),
                      )
                          : defaultProfilePic(height: 130),
                    ),
                )
              ],
            ),
          ),

          const Text("Username ",style: TextStyle(fontWeight: FontWeight.w700,
              color: textColorPrimary,fontSize: 20),),
          const SizedBox(height: 12,),

          const Text("ID : Sample ID"),
          const SizedBox(height: 6,),
          const Text("Status: Active"),
        ],
      ),
    );
  }


  Widget profileItemView({required String title, required String label,
    bool display=false }){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey,width: 0))
        ),
        child :Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const SizedBox(width: 12,),
            Row(
              children: [
                Text(label),
                const SizedBox(width: 12,),
                Icon(
                    display?Icons.visibility:Icons.visibility_off
                )
              ],
            ),
          ],
        )
    );
  }


}