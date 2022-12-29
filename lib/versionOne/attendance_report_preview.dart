import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_theme.dart';


class AttendanceReportDetailsPage extends StatefulWidget {
  const AttendanceReportDetailsPage({Key? key}) : super(key: key);

  @override
  State<AttendanceReportDetailsPage> createState() => _AttendanceReportDetailsPageState();
}

class _AttendanceReportDetailsPageState extends State<AttendanceReportDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Report Details"),
      ),
      body:
      Padding(
        padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              defaultProfilePic(height: 110),
              const SizedBox(height: 12,),
              const Text("John Jane Doe",style: TextStyle(
                  fontSize: 19,fontWeight: FontWeight.w500
              ),),

              const SizedBox(height: 8,),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: ()async{
                            var whatsappUrl =
                                "whatsapp://send?phone=${'+2332034549084'}";
                            if (await launchUrl(Uri.parse(whatsappUrl))) {
                              //dialer opened
                            }else{
                              //dailer is not opened
                            }
                          },
                          icon: Image.asset("images/icons/whatsapp_icon.png",
                            width: 19,height: 19,),
                      ),

                      const SizedBox(width: 30,),
                      IconButton(
                          onPressed: ()async{
                            Uri phoneno = Uri.parse('tel:+2332034549084');
                            if (await launchUrl(phoneno)) {
                              //dialer opened
                            }else{
                              //dailer is not opened
                            }
                          },
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          )
                      ),
                      // const Text("0205287979",style: TextStyle(
                      //     fontWeight: FontWeight.w400,fontSize: 14,color: textColorLight
                      // ),),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                child: Text("Early",style: TextStyle(color: Colors.white,fontSize: 15),),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(24)
                ),
              ),

              const SizedBox(height: 24,),

              Row(
                children: [
                  Icon(Icons.event,size: 30,
                    color: primaryColor,),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Friday Night Duties",
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date : 17/10/2022",style: TextStyle(fontWeight: FontWeight.w500,
                                color: textColorLight,fontSize: 14),),
                            Text("Span : 2 Days",style: TextStyle(fontWeight: FontWeight.w500,
                                color: textColorLight,fontSize: 14),),
                          ],
                        ),


                        const SizedBox(height: 2,),

                        Text("Time : 7 am to 5pm",style: TextStyle(fontWeight: FontWeight.w500,
                            color: textColorLight,fontSize: 14),),



                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 12,),
              // const Divider(
              //   color: textColorPrimary,
              // ),

              const SizedBox(height: 24,),

              LabelWidgetContainer(label: "Clock Time",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customTextWidget(label: "In", text: "5:00"),
                      _customTextWidget(label: "Out", text: "5:00"),

                    ],
                  )),

              const Divider(color: textColorPrimary,),
              const SizedBox(height: 12,),

              LabelWidgetContainer(label: "Break Time",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customTextWidget(label: "Start", text: "5:00"),
                      _customTextWidget(label: "End", text: "5:00"),

                    ],
                  )),
              const Divider(color: textColorPrimary,),

              const SizedBox(height: 16,),
              LabelWidgetContainer(label: "Overtime",
                  child: Text("2:00 hrs")),
              const Divider(color: textColorPrimary,),
              const SizedBox(height: 8,),
              LabelWidgetContainer(label: "Clocked In By:",
                  child: Text("Self")),
              const Divider(color: textColorPrimary,),
              const SizedBox(height: 8,),
              LabelWidgetContainer(label: "Clocked Out by:",
                  child: Text("Kofi Mensah (Admin)")),

              const Divider(color: textColorPrimary,),
              const SizedBox(height: 12),



              Row(
                children: [
                  Text("Last Seen"),
                  const SizedBox(width: 12,),
                  Text("10 Aug. 2022 / 7:40am")
                ],
              ),

              const SizedBox(height: 16,),


             Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 InkWell(
                   onTap: (){},
                   child: Container(
                     padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                     decoration: BoxDecoration(
                       color: Colors.red,
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: const Text("Cancel",style: TextStyle(color: Colors.black),),
                   )
                 ),
                 InkWell(
                     onTap: (){},
                     child: Container(
                       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                       decoration: BoxDecoration(
                           color: Colors.orange,
                           borderRadius: BorderRadius.circular(10)
                       ),
                         child: const Text("Follow up",style: TextStyle(color: Colors.black),),
                     )
                 ),


               ],
             )







            ],

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



