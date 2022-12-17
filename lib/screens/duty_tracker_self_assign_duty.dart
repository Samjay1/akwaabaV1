import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_button.dart';

class DutyTrackerSelfAssignDutyPage extends StatefulWidget {
  const DutyTrackerSelfAssignDutyPage({Key? key}) : super(key: key);

  @override
  State<DutyTrackerSelfAssignDutyPage> createState() => _DutyTrackerSelfAssignDutyPageState();
}

class _DutyTrackerSelfAssignDutyPageState extends State<DutyTrackerSelfAssignDutyPage> {
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerAssignDuty = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Assign Duty"),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

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
