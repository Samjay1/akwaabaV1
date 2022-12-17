import 'package:flutter/material.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/form_textfield.dart';
import '../components/label_widget_container.dart';

class DutyTrackerReassignDutyPage extends StatefulWidget {
  const DutyTrackerReassignDutyPage({Key? key}) : super(key: key);

  @override
  State<DutyTrackerReassignDutyPage> createState() => _DutyTrackerReassignDutyPageState();
}

class _DutyTrackerReassignDutyPageState extends State<DutyTrackerReassignDutyPage> {
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerAssignDuty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reasign Duty"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              LabelWidgetContainer(label: "Branch",
                  child: FormButton(
                    label: "Select Branch",
                    function: (){},
                  )
              ),


              LabelWidgetContainer(label: "Member Category",
                  child: FormButton(
                    label: "Select Category",
                    function: (){},
                  )
              ),

              LabelWidgetContainer(label: "Group",
                  child: FormButton(
                    label: "Select Group",
                    function: (){},
                  )
              ),

              LabelWidgetContainer(label: "Sub Group",
                  child: FormButton(
                    label: "Select Sub Group",
                    function: (){},
                  )
              ),


              LabelWidgetContainer(label:  "Member",
                  child: FormButton(
                    label: "Select Member",
                    function: (){},
                  )
              ),




              LabelWidgetContainer(label: "Subject",
                  child: FormButton(
                    label: "Select Subject",
                    function: (){},
                  )
              ),

              LabelWidgetContainer(label: "Subject", child:
              FormTextField(controller:_controllerSubject ,)
              ),

              Row(
                children: [
                  Expanded(
                    child: LabelWidgetContainer(label: "Start Date",
                        child:FormButton(
                          label: "Select Date",
                          function: (){},
                        )
                    ),
                  ),
                  const SizedBox(width: 12,),

                  Expanded(
                    child: LabelWidgetContainer(label: "End Date",
                        child:FormButton(
                          label: "Select Date",
                          function: (){},
                        )
                    ),
                  ),


                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: LabelWidgetContainer(label: "Start Time",
                        child:FormButton(
                          label: "Select Time",
                          function: (){},
                        )
                    ),
                  ),
                  const SizedBox(width: 12,),

                  Expanded(
                    child: LabelWidgetContainer(label: "End Time",
                        child:FormButton(
                          label: "Select Time",
                          function: (){},
                        )
                    ),
                  ),

                ],
              ),

              LabelWidgetContainer(
                label: "Assign Duty",
                child: FormTextField(
                  hint: "Assigne Duty",
                  controller: _controllerAssignDuty,
                  minLines: 4,maxLines: 7,textInputType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,),
              ),

              LabelWidgetContainer(label: "Attachment",
                  child: FormButton(label: "Attach File", function: (){})
              ),

              CustomElevatedButton(label: "Submit", function: (){})
            ],
          ),
        ),
      ),
    );
  }
}
