import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../versionOne/attendance_report_preview.dart';

class AttendanceReportItem extends StatefulWidget {
  final Map member;
  final bool isLate;
  const AttendanceReportItem(this.member,this.isLate,{Key? key}) : super(key: key);

  @override
  State<AttendanceReportItem> createState() => _AttendanceReportItemState();
}

class _AttendanceReportItemState extends State<AttendanceReportItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
      child: Card(
        color: widget.member["status"]?Colors.orange.shade100:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: widget.member["status"]?3:0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                widget.member["status"]?
                CupertinoIcons.check_mark_circled_solid:
                CupertinoIcons.checkmark_alt_circle,
                color: widget.member["status"]?primaryColor:Colors.grey,),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        defaultProfilePic(height: 50),
                        const SizedBox(width: 6,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("John Jane Doe",
                                style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text("Friday Night Duties",
                                      style: TextStyle(
                                          fontSize: 14,color: textColorLight
                                      ),),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color:widget.isLate? Colors.red:Colors.green
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                    child: Text(widget.isLate?"Late": "Early",style: TextStyle(
                                        fontSize: 13,color: Colors.white
                                    ),),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 Row(
                                   children: const [
                                     Icon(Icons.calendar_month_outlined,color: textColorLight,
                                       size: 16,),
                                     Text("12 Aug 2022",
                                       style: TextStyle(color: textColorLight,fontSize: 14),),
                                   ],
                                 ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color:Colors.green
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                    child: Text("Validate",style: TextStyle(
                                        fontSize: 13,color: Colors.white
                                    ),),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              const Text("last seen: 10 Aug 2022 / 7:40am",
                                style: TextStyle(color: textColorLight,fontSize: 14),),
                            ],
                          ),
                        ),


                        const SizedBox(width: 8,),
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>
                              const AttendanceReportDetailsPage()));
                            },
                            icon: Icon(Icons.chevron_right,size: 20,color: primaryColor,))
                      ],
                    ),

                  ],
                ) ,
              )

            ],
          ),
        ),
      ),
    );
  }
}
