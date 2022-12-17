import 'package:akwaaba/dialogs_modals/duty_tracker_report_details.dart';
import 'package:akwaaba/screens/duty_tracker_send_report_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DutyReportItemWidget extends StatefulWidget {
  const DutyReportItemWidget({Key? key}) : super(key: key);

  @override
  State<DutyReportItemWidget> createState() => _DutyReportItemWidgetState();
}

class _DutyReportItemWidgetState extends State<DutyReportItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text("Goods Delivery",
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  ),
                  statusView(),


                ],
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  const Icon(Icons.date_range,color: primaryColor,size: 16,),
                  const SizedBox(width: 8,),
                  RichText(
                    text: const TextSpan(
                        text: '1 Sep 2022 ',
                        style: TextStyle(
                            color: textColorLight, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(text: ' to 1 Sep 2022',
                              style: TextStyle(
                                  color: textColorLight, fontSize: 14),
                          )
                        ]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  const Icon(Icons.alarm,color: primaryColor,size: 16,),
                  const SizedBox(width: 8,),
                  RichText(
                    text: const TextSpan(
                        text: '8:00 AM ',
                        style: TextStyle(
                            color: textColorLight, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(text: ' to 5:00 PM',
                            style: TextStyle(
                                color: textColorLight, fontSize: 14),
                          )
                        ]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),




              Row(
                children: [
                  const Icon(Icons.pending_outlined,color: primaryColor,size: 16,),
                  const SizedBox(width: 8,),
                Text("Status",
                style: TextStyle(fontSize: 14, color: textColorLight),),
                  const SizedBox(width: 8,),
                  Text("New Assignment",
                  style: TextStyle(fontSize:  15,color: textColorDark)),
                ],
              ),

              const SizedBox(height: 8,),

              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,color: primaryColor,size: 16,),
                  const SizedBox(width: 8,),
                  Text("Assigned By:",
                    style: TextStyle(fontSize: 14, color: textColorLight),),
                  const SizedBox(width: 8,),
                  Text("Self Assigned",
                      style: TextStyle(fontSize:  15,color: textColorDark)),
                ],
              ),

              const SizedBox(height: 8,),



              Divider(color: Colors.grey,height: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //if report is sent, do not show send report button
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: const [
                          // Icon(Icons.summarize_outlined,size: 16,),
                          Text("Send Report"),
                        ],
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        DutyTrackerSendReportPage()));
                      }),

                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child:
                      Row(
                        children: const [Text("Details"),
                          Icon(Icons.chevron_right)],
                      ), onPressed: (){
                       // showNormalToast("Open Webview ");
                        displayCustomDialog(context, DutyTrackerReportDetails());

                  }),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget statusView(){
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(50)
      ),
      child: const Text("Not Submitted",
      style: TextStyle(fontSize: 12,color: Colors.white),),
    );
  }
}
