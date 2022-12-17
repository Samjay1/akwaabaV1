import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/assign_leader_widget.dart';
import '../utils/app_theme.dart';

class AssignContactLeadersAssignPage extends StatefulWidget {
  const AssignContactLeadersAssignPage({Key? key}) : super(key: key);

  @override
  State<AssignContactLeadersAssignPage> createState() => _AssignContactLeadersAssignPageState();
}

class _AssignContactLeadersAssignPageState extends State<AssignContactLeadersAssignPage> {
  List<Map>leaders=[];
  List<Map>selectedLeaders=[];
  bool showLeadersList = false;

  @override
  void initState() {
    super.initState();
    for (int i=0;i<12;i++){
      leaders.add({"status":false});
    }
  }


  filterLeadersList(){
    setState(() {
      showLeadersList=!showLeadersList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  selectedLeaders.isNotEmpty? selectedItemsAppBar():AppBar(
        title: const Text("Assign Leaders"),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabelWidgetContainer(label: "Branch",
                  child:FormButton(label: "Select Branch",
                  function: (){},),),

            LabelWidgetContainer(label: "Category",
                child:FormButton(label: "Select Category",
                  function: (){},)
              ),
              //
              // LabelWidgetContainer(label: "Members",
              //     child:FormButton(label: "Select Members",
              //       function: (){},)
              // ),

              CustomElevatedButton(label: "Filter List",
                  function: (){
                filterLeadersList();
                  }),

             const SizedBox(height: 36,),

             showLeadersList? availableLeadersList():SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar selectedItemsAppBar(){
    return AppBar(
      systemOverlayStyle:  const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
        statusBarColor: Colors.white,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close,),
        onPressed: () {
          setState(() {

            selectedLeaders.clear();
            for (int i=0;i<leaders.length;i++){
              leaders[i]["status"]=false;
            }

          });
        },),
      centerTitle: false,
      iconTheme:  const IconThemeData(
        color:  primaryColor, //change your color here
      ),
      titleTextStyle: const TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 16),
      backgroundColor: Colors.white,
      title: Text("${selectedLeaders.length} Selected"),
      actions: [
        //TextButton.icon(onPressed: (){}, icon: Icon(Icons.chevron_right), label: Text("Assign")),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomElevatedButton(label: "Assign", function: (){},
            labelSize: 15,),
        ),

        const SizedBox(width: 12,),


      ],
    );
  }

  Widget availableLeadersList(){
    return ListView(
      physics:const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(
          leaders.length, (index) => GestureDetector(
          onTap: (){
            setState(() {
              if(leaders[index]["status"]){
                leaders[index]["status"]=false;
                selectedLeaders.remove(leaders[index]);
              }else{
                leaders[index]["status"]=true;
                selectedLeaders.add(leaders[index]);
              }
            });
          },
          child: AssignLeaderWidget(leaders[index]))),
    );
  }

  Widget selectedSummary(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${selectedLeaders.length} selected"),

        CustomElevatedButton(label: "Assign", function: (){})
      ],
    );
  }

}
