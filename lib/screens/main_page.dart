import 'package:akwaaba/models/members/member_profile.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/screens/connect_users_page.dart';
import 'package:akwaaba/screens/alerts_page.dart';
import 'package:akwaaba/screens/assign_leaders_menus_page.dart';
import 'package:akwaaba/screens/attendance_history_page.dart';
import 'package:akwaaba/screens/clocking_page.dart';
import 'package:akwaaba/screens/contact_leaders_page.dart';
import 'package:akwaaba/screens/device_activation_request_page.dart';
import 'package:akwaaba/screens/info_center_page.dart';
import 'package:akwaaba/screens/more_menus_page.dart';
import 'package:akwaaba/screens/home_page.dart';
import 'package:akwaaba/screens/login_page.dart';
import 'package:akwaaba/screens/all_events_page.dart';
import 'package:akwaaba/screens/akwaaba_modules.dart';
import 'package:akwaaba/screens/post_master_menus_page.dart';
import 'package:akwaaba/screens/my_connections_page.dart';
import 'package:akwaaba/screens/register_connecting_users_page.dart';
import 'package:akwaaba/screens/view_users_page.dart';
import 'package:akwaaba/screens/web_admin_setup_page.dart';
import 'package:akwaaba/screens/member_registration_page_individual.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_cached_image_widget.dart';
import '../models/client_account_info.dart';
import '../utils/shared_prefs.dart';
import 'attendance_report_page.dart';
import 'members_page.dart';
import 'my_account_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map>bottomNavItems=[
    {"title":"Home","icon_data":CupertinoIcons.home},
    {"title":"Events","icon_data":Icons.calendar_month_outlined},
    {"title":"Clocking","icon_data":CupertinoIcons.alarm},
    {"title":"More","icon_data":Icons.menu},
  ];
  List<Map>bottomNavItemsFiled=[
    {"title":"Home","icon_data":CupertinoIcons.house_alt_fill},
    {"title":"Events","icon_data":Icons.calendar_month},
    {"title":"Clocking","icon_data":CupertinoIcons.alarm_fill},
    {"title":"More","icon_data":Icons.menu},
  ];

  int _selectedBottomNavIndex=0;

  final List<Widget> children = [
    const HomePage(),
    const AllEventsPage(),
    const ClockingPage(),//only show this if user is an admin
    const MorePage()
  ];
  String userType="";


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      initFunctions();
    });



  }
  
  initFunctions()async{
    //get user type and show the required bottom nav pages
    //based on the user type, call the provider function to set the user profile info 
    //to what has been saved on shared prefs, on the home page, another provider function
    //will call the login api to get the current user profile info
    
    //userType =(await SharedPrefs().getUserType())!;

    SharedPrefs().getUserType().then((value) {


      debugPrint("USer type from main page $value");
      setState(() {
        userType=value!;

        if(userType.isNotEmpty){



          if(userType.compareTo("member")==0){

            bottomNavItems.removeAt(2);
            bottomNavItemsFiled.removeAt(2);
            children.removeAt(2);

            SharedPrefs().getMemberProfile().then((value) {
              Provider.of<MemberProvider>(context,listen: false)
                  .setMemberProfileInfo(memberProfile: value!);
            });


          }else if(userType.compareTo("admin")==0){




            SharedPrefs().getAdminProfile().then((value) {
              Provider.of<ClientProvider>(context,listen: false)
                  .setAdminProfileInfo(adminProfile: value!);
            });
          }

          // SharedPrefs().getMemberProfile().then((value) {
          //   if(value!=null){
          //
          //   }
          // })
          //MemberProfile? memberProfile =  await SharedPrefs().getMemberProfile();

         // debugPrint("member profile ${memberProfile!.toJson()} ");

          // if(memberProfile!=null){
          //
          //   if(userType.compareTo("member")==0){
          //     Provider.of<MemberProvider>(context,listen: false)
          //         .setMemberProfileInfo(memberProfile: memberProfile);
          //
          //   }else if(userType.compareTo("admin")==0){
          //     bottomNavItems.removeAt(2);
          //     bottomNavItemsFiled.removeAt(2);
          //     children.removeAt(2);
          //   }
          // }


        }else{

        }
      });



    });
    



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          _selectedBottomNavIndex==0?"AKWAABA":_selectedBottomNavIndex==1?
              "All Events & Meetings":_selectedBottomNavIndex==2?"Clock Members":
              "More",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const MyAccountPage()));
              }, icon: const Icon(CupertinoIcons.person_fill,size: 25,)),
            ],
          ),

          Stack(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const AlertsPage()));
              }, icon: const Icon(Icons.notifications,size: 25,)),

                 const Positioned(
                top: 10,
                right: 7,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.white,
                  child: Text("12",
                  style: TextStyle(color: Colors.black,fontSize: 10),),
                ),
              )
            ],
          )
        ],
      ),
      drawer: Consumer<ClientProvider>(
        builder: (context,data,child){
          return drawerView(logo:data.getUser?.logo, applicantFirstname: data.getUser?.applicantFirstname, applicantSurname:data.getUser?.applicantSurname);
        },
      ),
      // drawerView(logo:logo, applicantFirstname:applicantFirstname, applicantSurname:applicantSurname),
      bottomNavigationBar: bottomNavigationView(),
      body:  Center(
        child: children[_selectedBottomNavIndex],
      ),

    );

  }

  Widget drawerView({var logo, var applicantFirstname, var applicantSurname}){
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: Column(
       
        children: [

          const SizedBox(height: 40,),
          SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomCachedImageWidget(url: logo,
                    height: 130),
                const SizedBox(height: 8,),
                Text("$applicantFirstname $applicantSurname",
                style: const TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,)
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child :
              Consumer<GeneralProvider>(
                builder: (context,data,child){
                  return ListView(
                    physics: const BouncingScrollPhysics(),

                    children: [

                      data.userIsAdmin ?  drawerItemView(title: "", iconData: Icons.person_outline,
                          function: (){},index: 8):
                      drawerItemView(title: "My Account", iconData: Icons.person_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                            MyAccountPage()));
                          },index: 8),

                      drawerItemView(title: "Update Users Profile", iconData: Icons.person_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            ///supposed to be a webview
                            showNormalToast("Webview url");
                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                            // MyConnectionsPage()));
                          },index: 8),

                      drawerItemView(title: "My Connections", iconData: Icons.person_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                            MyConnectionsPage()));
                          },index: 8),

                      drawerItemView(title: "View Members", iconData: Icons.people_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const MembersPage()));
                          },index: 8),

                      drawerItemView(title: "View Users", iconData: Icons.people_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder:
                                (_)=>const ViewUsersPage()));
                          },index: 8),


                      drawerItemView(title: "Attendance History", iconData: Icons.history,
                          function: (){
                            Navigator.pop(context);//close the drawer
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          const AttendanceHistoryPage()));
                       },index: 8,),

                      drawerItemView(title: "Attendance Report",
                          iconData: Icons.bar_chart,
                          function: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendanceReportPage()));
                          },
                          ),


                      drawerItemView(title: "Contact Leaders", iconData: Icons.support_agent_outlined,
                          function: (){
                            Navigator.pop(context);//close the drawer
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ContactLeadersPage()));
                          },index: 8),

                      drawerItemView(title: "Info Center", iconData: Icons.info_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const InfoCenterPage()));
                          },index: 8),

                      drawerItemView(title: "Post Manager", iconData: Icons.info_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                            PostMasterMenusPage()));
                          },index: 8),

                      drawerItemView(title: "Akwaaba Messenger ", iconData: Icons.info_outline,
                          function: (){
                            Navigator.pop(context);//close the drawer
                            showNormalToast("Webview URl");
                          },index: 8),

                      ///only show this when user device is ot already activated
                      drawerItemView(title: "Request Device Activation",
                          iconData: Icons.phone_android_outlined,
                                                function: (){
                                                  Navigator.pop(context);//close the drawer
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>
                                                  const DeviceActivationRequestPage()));
                                                },index: 8),

                      data.userIsAdmin?
                      Column(
                        children: [
                          drawerItemView(title: "Connect Users", iconData: Icons.phone_android,
                              function: (){
                                Navigator.pop(context);//close the drawer
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>const ConnectUsersPage()));
                              },index: 8),

                          drawerItemView(title: "Register Connecting Users", iconData: Icons.phone_android,
                              function: (){
                                Navigator.pop(context);//close the drawer
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                                const RegisterConnectingUsersPage()));
                              },index: 8),

                          drawerItemView(title: "Assign  Leaders", iconData: Icons.person_add_alt_outlined,
                              function: (){
                                Navigator.pop(context);//close the drawer
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>const AssignLeadersPage()));
                              },index: 0),

                          // drawerItemView(title: "Post Info", iconData: Icons.people_outline,
                          //     function: (){
                          //       Navigator.pop(context);//close the drawer
                          //     },index: 8),

                        ],
                      ):
                      Container(),


                     
                      drawerItemView(title: "Log out", iconData: Icons.logout_rounded,
                          function: (){
                            Navigator.pop(context);//close the drawers
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
                          },index: 21),


                    ],
                  );
                },
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationView(){
    return
      Consumer<GeneralProvider>(

          builder: (context, data,child){


            return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedBottomNavIndex,
                backgroundColor: Colors.white,
                selectedItemColor: primaryColor,
                unselectedItemColor: Colors.grey,
                selectedFontSize: 14,
                unselectedFontSize: 14,
                onTap: (value){
                  setState(() => _selectedBottomNavIndex = value);
                },
                items: List.generate(bottomNavItems.length, (index) {
                  return
                    // index==2&& data.userIsAdmin?
                    // null:
                    BottomNavigationBarItem(
                      icon:Icon(
                          _selectedBottomNavIndex==index?
                          bottomNavItemsFiled[index]["icon_data"]:
                          bottomNavItems[index]["icon_data"]),
                      label: bottomNavItems[index]["title"],
                    );
                }
                )
            );
          });
  }


  Widget drawerItemView({required String title,required IconData iconData,
  required VoidCallback function,  int? index}){
    //index is not relevant, you can ignore it
    return GestureDetector(
      onTap: function,
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0,color: Colors.grey))
        ),
        child: Row(

          children: [
            //Icon(iconData,color: primaryColor,),
            const SizedBox(width: 12,),
            Text(title)

          ],
        ),
      ),
    );
  }

  drawerItemTapped(int index){
    Navigator.pop(context);
    switch(index){
      case 0:
        //register member
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const
      MemberRegistrationPageIndividual()));
      break;
      case 1:
        //verify member
      requestClientAccountSetup();

        break;
      case 2:
        //member profile
        requestClientAccountSetup();
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const WebAdminSetupPage()));
        break;
      case 4:
        //set up web admin menus
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const
        AkwaabaModules()));

        break;
      case 8:
        //view members
        Navigator.push(context, MaterialPageRoute(builder: (_)=>const
        MembersPage()));

        break;
      case 21:
        //log out
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>
        const LoginPage()));



    }

  }

  requestClientAccountSetup(){
    displayCustomCupertinoDialog(context: context,
        title: "Hi User", msg: "Would you like to setup your client account",
        actionsMap: {
          "Later":(){
            Navigator.pop(context);
          },
          "Yes":(){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const
            WebAdminSetupPage()));
          }});
  }


}
