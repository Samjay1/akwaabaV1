import 'package:akwaaba/models/attendance_history_item.dart';
import 'package:akwaaba/versionOne/attendance_history_item_preview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryItemWidget extends StatelessWidget {
  final AttendanceHistoryItem attendanceHistoryItem;
  const AttendanceHistoryItemWidget(this.attendanceHistoryItem,
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>
          const AttendanceHistoryItemPreviewPage()));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8),
            child:Row(
            //  crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                defaultProfilePic(height: 50),
                const SizedBox(width: 12,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Lord Asante Fudjour",
                    style: TextStyle(fontSize: 18),),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                        size: 16,color: textColorLight,),
                        const SizedBox(width: 8,),
                        Text("2nd Jan  -  3rd Mar 2022",style: TextStyle(
                          fontSize: 14,color: textColorLight
                        ),),
                      ],
                    ),
                    const  SizedBox(height: 4,),
                    Text("Meeting Type : All",style: TextStyle(
                        fontSize: 14,color: textColorLight
                    )),
                    const  SizedBox(height: 4,),
                    Text("Under time:   2:15 hrs",style: TextStyle(
                        fontSize: 14,color: textColorLight
                    )),



                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 12),
                        child: Text("Inactive",style: TextStyle(color: Colors.white,
                        fontSize: 13),),
                      ),
                    )
                  ],)
                ),
                Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.chevron_right))



              ],
            ) ,
          ),
        ),
      ),
    );
  }

  Widget _customTextWidget({String label="", String text=""}){
    return

      RichText(
      text: TextSpan(
          text: '$label ',
          style: const TextStyle(
              color: textColorLight, fontSize: 13),
          children: <TextSpan>[
            TextSpan(text: ' $text',
                style: const TextStyle(
                    color: textColorPrimary, fontSize: 15),

            )
          ]
      ),
    );

  }
}
