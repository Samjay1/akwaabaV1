import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/attendance_report_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/versionOne/attendance_report_filter_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/AttendanceReportItem.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../utils/app_theme.dart';
import 'attendance_report_preview.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({Key? key}) : super(key: key);

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  int attendanceStatusIndex=0;
  String? selectedGender;
  final TextEditingController _controllerId = TextEditingController();
  final TextEditingController _controllerMinAge = TextEditingController();
  final TextEditingController _controllerMaxAge = TextEditingController();



  List<Map>members=[
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
    {"status":false},
  ];
  bool checkAll=false;
  bool itemHasBeenSelected=false;//at least 1 member has been selected, so show options menu
  List<Map>selectedMembersList=[];


  selectGender(){
    displayCustomDropDown(options: ["Male","Female"],
        listItemsIsMap: false,
        context: context).then((value) {
          selectedGender=value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              
              filterButton(),

              const SizedBox(height: 12,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text('Total users'),
                      Text('30', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),
                  Column(
                    children: const [
                      Text('Total Males'),
                      Text('20', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),
                  Column(
                    children: const [
                      Text('Total Females'),
                      Text('10', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),
                ],
              ),



              const SizedBox(height: 12,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          activeColor: primaryColor,
                          shape: const CircleBorder(),
                          value: checkAll, onChanged: (val){
                        setState(() {
                          checkAll=val!;
                          for (Map map in members){
                            map["status"]=checkAll;
                          }
                        });
                      }),
                      const Text("Check All"),
                    ],
                  ),
                  const SizedBox(width: 25,),
                  InkWell(
                    onTap: (){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendees validated...')));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: const Text("Validate"),
                    ),
                  )
                ],
              ),

              Column(
                children: List.generate(members.length, (index){
                  return  GestureDetector(
                      onTap: (){
                        setState(() {
                          if(members[index]["status"]){
                            //remove it
                            members[index]["status"]=false;
                            selectedMembersList.remove(members[index]);
                          }else{
                            members[index]["status"]=true;
                            selectedMembersList.add(members[index]);
                          }
                          if(selectedMembersList.isNotEmpty){
                            itemHasBeenSelected=true;
                          }else{
                            itemHasBeenSelected=false;
                          }
                        });
                      },
                      child: AttendanceReportItem(members[index],true));
                }),




              ),
             // Container(
             //   child:  Column(
             //       children: List.generate(1, (index) {
             //         return  AttendanceReportItemWidget(
             //             isLate: index % 3==0);
             //       })
             //   ),
             // )
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceReportFilterOptionsList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: attendanceStatusIndex==0?primaryColor:Colors.transparent,
                  padding: EdgeInsets.zero,
                  child: const Text("Attendees",style: TextStyle(
                    color: textColorPrimary
                  ),),
                  onPressed: (){
                    setState(() {
                      attendanceStatusIndex=0;
                    });
                  }),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: CupertinoButton(
                  color: attendanceStatusIndex==1?primaryColor:Colors.transparent,
                  padding: EdgeInsets.zero,
                  child: const Text("Absentees",style: TextStyle(color: textColorPrimary),),
                  onPressed: (){
                    setState(() {
                      attendanceStatusIndex=1;
                    });
                  }),
            )
          ],
        ),

        const SizedBox(height: 16,),

        LabelWidgetContainer(label: "Meeting Type",
            child: FormButton(label: "Select Meeting Type",function: (){},)
        ),

        Row(
          children: [
            Expanded(
              child:  LabelWidgetContainer(label: "Start Date",
                  child: FormButton(label: "Select Start Date",function: (){},)
              ),
            ),
            const SizedBox(width: 24,),
            Expanded(
              child:  LabelWidgetContainer(label: "End Date",
                  child: FormButton(label: "Select End Date",function: (){},)
              ),
            )
          ],
        ),

        LabelWidgetContainer(label: "Select Gender ",
            child: FormButton(label: selectedGender??"Select Gender",function: (){selectGender();},)
        ),

        LabelWidgetContainer(label: "Branch",
            child: FormButton(label: "All",function: (){},)
        ),

        LabelWidgetContainer(label: "Member Category",
            child: FormButton(label: "All",function: (){},)
        ),

        LabelWidgetContainer(label: "Group",
            child: FormButton(label: "All",function: (){},)
        ),

        LabelWidgetContainer(label: "Sub Group",
            child: FormButton(label: "All",function: (){},)
        ),

        LabelWidgetContainer(label: "Members ",
            child: FormButton(label: "All",function: (){},)
        ),
        
        LabelWidgetContainer(label: "Id",
            child: FormTextField(controller: _controllerId,
            hint: "Enter Id",)),

        Text("Age Bracket"),
        const SizedBox(height: 12,),

        Row(
          children: [
            Expanded(
              child: LabelWidgetContainer(
                label: "Minimum Age",
                child: FormTextField(
                  controller: _controllerMinAge,
                ),
              ),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: LabelWidgetContainer(
                label: "Maximum Age",
                child: FormTextField(
                  controller: _controllerMaxAge,
                ),
              ),
            )
          ],
        )

      ],
    );
  }

  Widget filterButton(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "Filter Options ",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            attendanceReportFilterOptionsList()
          ],
        ),
      ),
    );
  }
}


