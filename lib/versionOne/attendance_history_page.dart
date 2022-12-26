import 'package:akwaaba/components/attendance_history_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/attendance_history_item.dart';
import '../utils/widget_utils.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<AttendanceHistoryItem>list=[
    AttendanceHistoryItem(name: "Meeting Type",fromDate: "8:00AM",
    toDate: "5:30PM",meetingType: "10:30AM",endBreak: "11:30AM",status: "early"),
    AttendanceHistoryItem(name: "Meeting Type",fromDate: "8:00AM",
        toDate: "5:30PM",meetingType: "10:30AM",endBreak: "11:30AM",status: "late"),
    AttendanceHistoryItem(name: "Meeting Type",fromDate: "8:00AM",
        toDate: "5:30PM",meetingType: "10:30AM",endBreak: "11:30AM",status: "late"),
    AttendanceHistoryItem(name: "Meeting Type",fromDate: "8:00AM",
        toDate: "5:30PM",meetingType: "10:30AM",endBreak: "11:30AM",status: "early"),
    AttendanceHistoryItem(name: "Meeting Type",fromDate: "8:00AM",
        toDate: "5:30PM",meetingType: "10:30AM",endBreak: "11:30AM",status: "late")
  ];

  final TextEditingController _controllerId = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;//start and end year | month for filter range


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              filterButton(),
              const SizedBox(height: 16,),
                  _historyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterView(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [


          Row(

            children: [
              Expanded(
                child:

                LabelWidgetContainer(label: "Start Date",
                  child: FormButton(label:startDate!=null?DateFormat("dd-MM-yyyy").format(startDate!):
                  "Start Period" , function: (){ selectStartPeriod();},
                    iconData: Icons.calendar_month_outlined,),),

              ),
              const SizedBox(width: 18,),

              Expanded(
                child:

                LabelWidgetContainer(label: "End Period",
                  child:   FormButton(label:endDate!=null?DateFormat("dd-MM-yyyy").format(endDate!):
                  "End Period" , function: (){ selectEndPeriod();},
                    iconData: Icons.calendar_month_outlined,),),

              ),

            ],
          ),

          LabelWidgetContainer(label: "Branch",
              child: FormButton(label: "Select Branch",function: (){},)),

          LabelWidgetContainer(label: "Member Category",
              child: FormButton(label: "Select Member Category",function: (){},)),

          LabelWidgetContainer(label: "Group",
              child: FormButton(label: "Select Group",function: (){},)),

          LabelWidgetContainer(label: "Sub Group",
              child: FormButton(label: "Select Sub Group",function: (){},)),

          LabelWidgetContainer(label: "Meeting/Attendance Name",
              child: FormButton(label: "Select Meeting/Attendance Name",function: (){},)),

          LabelWidgetContainer(label: "Name",
              child: FormButton(label: "Select Name",function: (){},)),

          LabelWidgetContainer(label: "Id",
              child:FormTextField(controller: _controllerId,)),



          const SizedBox(height: 24,),

          CustomElevatedButton(label: "Apply Filter", function: (){}),

          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget filterButton(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(

          backgroundColor: backgroundColor,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "Filter Options",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            filterView()
          ],
        ),
      ),
    );
  }

  Widget _historyList(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(list.length, (index) {
        return AttendanceHistoryItemWidget(list[index]);
      }),
    );
  }

  selectStartPeriod(){

    displayDateSelector(context: context,
      initialDate:startDate ?? DateTime.now(),
      minimumDate: DateTime(DateTime.now().year - 50, 1),
      maxDate: DateTime.now(),

    ).then((value) {
      setState(() {
        startDate = value;
      });
    });
  }

  selectEndPeriod(){
    displayDateSelector(context: context,
        initialDate:endDate ?? DateTime.now(),
        minimumDate: DateTime(DateTime.now().year - 50, 1),
        maxDate: DateTime.now()

    ).then((value) {
      setState(() {
        endDate = value;
      });
    });

  }
}
