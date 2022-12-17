import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/screens/duty_tracker_reasign_duty_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class DutyTrackerReportDetails extends StatefulWidget {
  const DutyTrackerReportDetails({Key? key}) : super(key: key);

  @override
  State<DutyTrackerReportDetails> createState() => _DutyTrackerReportDetailsState();
}

class _DutyTrackerReportDetailsState extends State<DutyTrackerReportDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.symmetric(vertical: 36,horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Report Details",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600
          ),),
          const SizedBox(height: 24,),
          rowBorderView(title: "Work Done", info: "30%"),
          rowBorderView(title: "Rating", info: "Good"),
          const SizedBox(height: 24,),
          CustomElevatedButton(label: 'View Report', function: (){}),
          const SizedBox(height: 12,),
          CustomElevatedButton(label: 'Rate Work Done ', function: (){}),
          const SizedBox(height: 12,),
          CustomElevatedButton(label: 'View Remarks', function: (){}),
          const SizedBox(height: 12,),
          CustomElevatedButton(label: 'Reassign Duty ', function: (){
            Navigator.pop(context);//closes the dialog
            Navigator.push(context, MaterialPageRoute(builder: (_)=>
            DutyTrackerReassignDutyPage()));
          }),
          const SizedBox(height: 24,),


          Row(
            children: [
              Expanded(child:
              CustomOutlinedButton(
                label: "Delete Duty",
                function: (){},
              )
              ),
              const SizedBox(width: 12,),
              Expanded(child:
              CustomOutlinedButton(
                label: "Edit Duty",
                function: (){},
              )
              )
            ],
          ),

          Divider(color: textColorDark,),
          CupertinoButton(child: const Text("Close "),
          onPressed: (){
            Navigator.pop(context);
          },)
        ],
      ),
    );
  }

  Widget rowBorderView({
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
