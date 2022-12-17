import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/material.dart';

class ReportNewMsgPage extends StatefulWidget {
  const ReportNewMsgPage({Key? key}) : super(key: key);

  @override
  State<ReportNewMsgPage> createState() => _ReportNewMsgPageState();
}

class _ReportNewMsgPageState extends State<ReportNewMsgPage> {
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerMsg = TextEditingController();
  int msgOptionIndex=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        border: Border.all(color: textColorLight,width: 0)
                      ),
                      child: Row(
                        children: List.generate(2, (index) {
                          return
                          Row(
                            children: [
                              Radio(
                                  activeColor: primaryColor,
                                  value: index, groupValue: msgOptionIndex,
                                  onChanged: (int? val){
                                setState(() {
                                  msgOptionIndex=val!;
                                });
                                  }),
                              Text(index==0?"Private Message":"Open Message")
                            ],
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16,),

                    // LabelWidgetContainer(label: "Branch",
                    //     child:FormButton(label: "Select Branch", function: () {  },) ),

                    LabelWidgetContainer(label: "Leader",
                        child:FormButton(label: "Select Leader", function: () {  },) ),

                   FormTextField(controller: _controllerSubject,
                   minLines: 1,maxLines: 2,label: "Subject",),

                    FormTextField(controller: _controllerSubject,
                      minLines: 5,maxLines: 10,label: "Message",textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,),

                    LabelWidgetContainer(label: "Attachment",
                        child:FormButton(label: "Select Attachment",
                          function: () {  },iconData: Icons.attach_file,) ),
                  ],
                ),
              ),
            ),

            CustomElevatedButton(label: "Submit", function: (){}),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }


}
