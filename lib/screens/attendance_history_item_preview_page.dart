import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AttendanceHistoryItemPreviewPage extends StatefulWidget {
  const AttendanceHistoryItemPreviewPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryItemPreviewPage> createState() => _AttendanceHistoryItemPreviewPageState();
}

class _AttendanceHistoryItemPreviewPageState extends State<AttendanceHistoryItemPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Records"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headerWidget(),

              const SizedBox(height: 12,),

              meetingRecords(),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          defaultProfilePic(height: 70),



          Text("Lord Asante Fudjour",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),),
          const SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month,
                size: 16,color: textColorLight,),
              const SizedBox(width: 8,),
              Text("2nd Jan  -  3rd Mar 2022",style: TextStyle(
                  fontSize: 15,color: textColorLight
              ),),
            ],
          ),
          const  SizedBox(height: 4,),
          Text("Meeting Type : All",style: TextStyle(
              fontSize: 15,color: textColorLight
          )),
          const  SizedBox(height: 4,),
          Text("Under time:   2:15 hrs",style: TextStyle(
              fontSize: 15,color: textColorLight
          )),

          const  SizedBox(height: 12,),


          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.symmetric(vertical: 4,horizontal: 12),
            child: Text("Inactive",style: TextStyle(color: Colors.white,
                fontSize: 15),),
          )
        ],
      ),
    );
  }

  Widget meetingRecords(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Meeting Records",
          style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600),),

          const SizedBox(height: 8,),
          attendanceRecordItemView(title: "Total Attendance", info: "8/12"),
          attendanceRecordItemView(title: "On Time", info: "5"),
          attendanceRecordItemView(title: "Lateness ", info: "3")


        ],
      ),
    );
  }

  Widget attendanceRecordItemView({
  required String title, required String info,
}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title"),
              Text("$info"),
            ],
          ),
          Divider(height: 0,color: textColorLight,),
        ],
      ),
    );
  }
}
