import 'package:akwaaba/components/bottom_border_textfield.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/widget_utils.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}


/*
Select Branch           [ All….             ]
Select Category       [ All……….       ]
Select Group            [ All……….       ]
Select Subgroup      [ All……….       ]
Select Member        [ All……….       ]
Enter Subject           [                       ]
Set Date [        ]        Set Time  [     ]

 */
class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _controllerSubject = TextEditingController();
  bool selectLocation=false;
  bool scheduleMsg=false;
  DateTime? startYear;
  DateTime? endYear;

  selectStartPeriod(){

    displayDateSelector(context: context,
      initialDate:startYear ?? DateTime.now(),
      minimumDate: DateTime(DateTime.now().year - 50, 1),
      maxDate: DateTime.now(),

    ).then((value) {
      setState(() {
        startYear = value;
      });
    });
  }

  selectEndPeriod(){
    displayDateSelector(context: context,
        initialDate:endYear ?? DateTime.now(),
        minimumDate: DateTime(DateTime.now().year - 50, 1),
        maxDate: DateTime.now()

    ).then((value) {
      setState(() {
        endYear = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Container(
              //   margin: EdgeInsets.only(bottom: 16),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(8),
              //       border: Border.all(width: 0.0,color:Colors.grey.shade400)
              //   ),
              //   child:
                Row(
                  children: [
                    Checkbox(
                        shape: const CircleBorder(),
                        activeColor: primaryColor,
                        value: selectLocation,
                        onChanged: (bool? val){
                      setState(() {
                        selectLocation=val!;
                      });
                        }),
                    const Text("Select Location")
                  ],
                ),
              // ),

              selectLocation?
                  Column(
                    children: [
                      LabelWidgetContainer(label: "Country",
                          child:FormButton(label: "",function: (){},),
                      ),
                      LabelWidgetContainer(label: "Province",
                        child:FormButton(label: "",function: (){},),
                      ),
                      LabelWidgetContainer(label: "Region",
                        child:FormButton(label: "",function: (){},),
                      ),
                      LabelWidgetContainer(label: "District",
                        child:FormButton(label: "",function: (){},),
                      ),
                      LabelWidgetContainer(label: "Constituency",
                        child:FormButton(label: "",function: (){},),
                      ),
                      LabelWidgetContainer(label: "Community",
                        child:FormButton(label: "",function: (){},),
                      )
                    ],
                  ):const SizedBox.shrink(),




              LabelWidgetContainer(label: "Connection Type/Status",
                  child: FormButton(
                    label: "Select Connection Type/Status",function: (){},
                  )),


              Row(
                children: [
                  Checkbox(
                      shape: const CircleBorder(),
                      activeColor: primaryColor,
                      value: scheduleMsg,
                      onChanged: (bool? val){
                        setState(() {
                          scheduleMsg=val!;
                        });
                      }),
                  const Text("Schedule Message")
                ],
              ),


              scheduleMsg?
              Column(
                children: [
                  Row(

                    children: [
                      Expanded(
                        child:

                        LabelWidgetContainer(label: "Start Date",
                          child: FormButton(label:startYear!=null?DateFormat("dd MMM yyyy").format(startYear!):
                          "Start Period" , function: (){ selectStartPeriod();},
                            iconData: Icons.calendar_month_outlined,),),

                      ),
                      const SizedBox(width: 18,),

                      Expanded(
                        child:

                        LabelWidgetContainer(label: "End Period",
                          child:   FormButton(label:endYear!=null?DateFormat("dd MMM yyyy").format(endYear!):
                          "End Period" , function: (){ selectEndPeriod();},
                            iconData: Icons.calendar_month_outlined,),),

                      ),

                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: LabelWidgetContainer(label: "Time",
                            child: FormButton(
                              label: "Select Time",
                              function: (){},
                            )),
                      ),
                      const SizedBox(width: 18,),
                      Expanded(child: Container())
                    ],
                  )
                ],
              ):SizedBox.shrink(),



              LabelWidgetContainer(label: "Branch",
                  child: FormButton(label: "Select Branch",function: (){},)),

              LabelWidgetContainer(label: "Category",
                  child: FormButton(label: "Select Category",function: (){},)),

              LabelWidgetContainer(label: "Group",
                  child: FormButton(label: "Select Group",function: (){},)),

              LabelWidgetContainer(label: "Sub Group",
                  child: FormButton(label: "Select Sub Group",function: (){},)),

              LabelWidgetContainer(label: "Member",
                  child: FormButton(label: "Select Member",function: (){},)),

             const SizedBox(height: 12,),

             FormTextField(controller: _controllerSubject,label: "Subject",),

              FormTextField(controller: _controllerSubject,label: "Message",minLines: 4,
                  maxLines: 10,),

              const SizedBox(height: 24,),

              CustomElevatedButton(label: "Post", function: (){})
            ],
          ),
        ),
      ),
    );
  }
}
