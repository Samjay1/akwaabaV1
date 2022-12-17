import 'package:akwaaba/dialogs_modals/new_registrations_modal_sheet_view.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/screens/connect_users_page.dart';
import 'package:akwaaba/screens/birthday_alerts_page.dart';
import 'package:akwaaba/screens/duty_tracker_main_page.dart';
import 'package:akwaaba/screens/fee_manager_menus_page.dart';
import 'package:akwaaba/screens/login_page.dart';
import 'package:akwaaba/screens/member_registration_page_individual.dart';
import 'package:akwaaba/screens/akwaaba_modules.dart';
import 'package:akwaaba/screens/school_manager_menus_page.dart';
import 'package:akwaaba/screens/webview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schoolManager_provider.dart';
import 'attendance_report_page.dart';
import 'post_master_menus_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {

  showRegistrationOptionsView(){
    showModalBottomSheet(context: context, builder: (_){
      return Wrap(
        children: const [
          NewRegistrationModalSheetView(),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child:
        Consumer<GeneralProvider>(
          builder: (context,data,child){
            return   ListView(
              physics: const BouncingScrollPhysics(),
              children: [

                data.userIsAdmin?Column(
                  children: [
           

                    directoryItemWidget(iconData: Icons.person_add_alt_outlined,
                        title: "Register Individual/Organization",
                        function: (){
                      showRegistrationOptionsView();


                    }),

                    // directoryItemWidget(iconData: Icons.dashboard_outlined,
                    //     title: "Akwaaba Modules",
                    // function: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (_)=>const AkwaabaModules()));
                    // }),


                    // directoryItemWidget(iconData: Icons.monitor_heart_outlined,
                    //     title: "Staff Duty Tracker",
                    //     function: (){
                    //       Navigator.push(context, MaterialPageRoute(builder: (_)=>const DutyTrackerMainPage()));
                    //     }),



                    directoryItemWidget(iconData: Icons.school_outlined,
                        title: "School Manager",
                        function: (){ 
                          Provider.of<SchoolProvider>(context,listen: false).login(context: context, email: 'clickcomgh@gmail.com', password: ' password2', role: 'admin');
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>const SchoolManagerMenusPage()));
                        }),



                  ],
                ):Container(),

                directoryItemWidget(iconData: Icons.money,
                    title: "Fee Manager ",
                    function: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const FeeManagerMenusPage()));
                    }),

                directoryItemWidget(iconData: CupertinoIcons.chat_bubble_2,
                    title: "Post Master ",function: (){

                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                  PostMasterMenusPage()));


                    }),

                directoryItemWidget(iconData: Icons.celebration,
                    title: "Birthday Alerts",function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                  BirthdayAlertsPage()));
                    }),

                directoryItemWidget(iconData: Icons.verified,
                    title: "Verification Portal",function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewPage(url: "https://verify.akwaabasoftware.com",)));

                    }),

                const SizedBox(height: 24,),

                const SizedBox(height: 12,),

                TextButton.icon(onPressed: (){
                  SharedPrefs().logOut();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_)=>const LoginPage()));
                },
                    icon: const Icon(Icons.logout), label:const Text("Log out"))
              ],
            );
          },
        ),
      ),
    );
  }
  
  
  Widget directoryItemWidget({required IconData iconData, required String title,
     int? indexId, VoidCallback? function}){
    return
        GestureDetector(
          onTap:function,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius)
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultRadius)
                ),
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 18,
                      child: Icon(iconData,color: primaryColor,),
                    ),
                    const SizedBox(width: 12,),
                    Text(title)
                  ],
                ),
              ),
            ),
          ),
        );
  }

  directoryMenuTapped(int indexId){
    String url="";
    switch(indexId){
      case 1:
        //birthday alerts
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const
      BirthdayAlertsPage()));

        break;
      case 2:
        //activations and approvals
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const
        ConnectUsersPage()));
        break;
      case 3:
        //attendance reports
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const
        AttendanceReportPage()));
        break;
      case 4:
        //register member
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const
        MemberRegistrationPageIndividual()));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewPage(url: url,)));

    }


  }



}
