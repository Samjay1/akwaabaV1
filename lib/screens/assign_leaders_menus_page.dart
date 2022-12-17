import 'package:akwaaba/components/assign_leader_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/screens/assign_contact_leaders_assign_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'assign_leaders_view_list_page.dart';

class AssignLeadersPage extends StatefulWidget {
  const AssignLeadersPage({Key? key}) : super(key: key);

  @override
  State<AssignLeadersPage> createState() => _AssignLeadersPageState();
}

class _AssignLeadersPageState extends State<AssignLeadersPage> {
  List<Map>leaders=[];
  List<Map>selectedLeaders=[];


  @override
  void initState() {
    super.initState();
    for (int i=0;i<12;i++){
      leaders.add({"status":false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Assign Leaders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [


            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const AssignContactLeadersAssignPage()));
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius)
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 8),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text("Assign Leaders",
                          style: TextStyle(fontSize: 19),),
                        ),

                        Icon(Icons.chevron_right),


                      ],
                    )),
              ),
            ),

            const SizedBox(height: 24,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const AssignLeadersViewLeadersListPage()));
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius)
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 8),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text("View Leaders",
                            style: TextStyle(fontSize: 19),),
                        ),

                        Icon(Icons.chevron_right),


                      ],
                    )),
              ),
            )

            // selectedLeaders.isNotEmpty?
            //     selectedSummary():const SizedBox.shrink(),
           // const SizedBox(height: 8,),
           //
           // LabelWidgetContainer(label: "Branch",
           //     child:  FormButton(label: "Select Branch", function: (){})),
           //  const SizedBox(height: 24,),
           //
           //  const Text("Select Leaders",
           //  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19),),

            // Expanded(child: availableLeadersList()),



          ],
        ),
      ),
    );
  }

  // AppBar selectedItemsAppBar(){
  //   return AppBar(
  //     systemOverlayStyle:  const SystemUiOverlayStyle(
  //       statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  //       statusBarBrightness: Brightness.light, // For iOS (dark icons)
  //       statusBarColor: Colors.white,
  //     ),
  //     leading: IconButton(
  //       icon: const Icon(Icons.close,),
  //       onPressed: () {
  //       setState(() {
  //
  //         selectedLeaders.clear();
  //         for (int i=0;i<leaders.length;i++){
  //           leaders[i]["status"]=false;
  //         }
  //
  //       });
  //       },),
  //     centerTitle: false,
  //     iconTheme:  const IconThemeData(
  //       color:  primaryColor, //change your color here
  //     ),
  //     titleTextStyle: const TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 16),
  //     backgroundColor: Colors.white,
  //     title: Text("${selectedLeaders.length} Selected"),
  //     actions: [
  //       //TextButton.icon(onPressed: (){}, icon: Icon(Icons.chevron_right), label: Text("Assign")),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: CustomElevatedButton(label: "Assign", function: (){},
  //         labelSize: 15,),
  //       ),
  //
  //       const SizedBox(width: 12,),
  //
  //
  //     ],
  //   );
  // }
  //
  // Widget availableLeadersList(){
  //   return ListView(
  //     // physics:const NeverScrollableScrollPhysics(),
  //     // shrinkWrap: true,
  //     children: List.generate(leaders.length, (index) => GestureDetector(
  //         onTap: (){
  //           setState(() {
  //             if(leaders[index]["status"]){
  //               leaders[index]["status"]=false;
  //               selectedLeaders.remove(leaders[index]);
  //             }else{
  //               leaders[index]["status"]=true;
  //               selectedLeaders.add(leaders[index]);
  //             }
  //           });
  //         },
  //         child: AssignLeaderWidget(leaders[index]))),
  //   );
  // }
  //
  // Widget selectedSummary(){
  //   return Container(
  //    // color: Colors.white,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text("${selectedLeaders.length} selected"),
  //
  //         CustomElevatedButton(label: "Assign", function: (){})
  //       ],
  //     ),
  //   );
  // }
}
