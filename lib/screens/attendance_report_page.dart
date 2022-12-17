import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/attendance_report_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/screens/attendance_report_filter_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../utils/app_theme.dart';

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
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              filterButton(),

              const SizedBox(height: 12,),

              Column(
                children: List.generate(10, (index) {
                  return  AttendanceReportItemWidget(
                    isLate: index % 3==0);
                })
              ),
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
                  child: Text("Attendees",style: TextStyle(
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
                  child: Text("Abseentees",style: TextStyle(color: textColorPrimary),),
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


