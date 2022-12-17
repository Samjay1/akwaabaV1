import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class SchoolManagerEnterMarksPage extends StatefulWidget {
  const SchoolManagerEnterMarksPage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerEnterMarksPage> createState() => _SchoolManagerEnterMarksPageState();
}

class _SchoolManagerEnterMarksPageState extends State<SchoolManagerEnterMarksPage> {
  final TextEditingController _controllerScore = TextEditingController();
  final TextEditingController _controllerRemarks = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter/Edit Scores"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  defaultProfilePic(height: 55),
                  const SizedBox(width: 10,),
                  Text("Lord Asante"),
                  

                ],
              ),
              const SizedBox(height: 36,),

              LabelWidgetContainer(label: "Raw Score",
                  child:FormTextField(
                    controller: _controllerScore,
                    maxLength: 3,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  )

              ),
              LabelWidgetContainer(label: "Remarks",
                  child:FormTextField(
                    controller: _controllerRemarks,
                    maxLength: 256,
                    textInputType: TextInputType.multiline,
                    minLines: 7,
                    maxLines: 14,
                    textInputAction: TextInputAction.newline,
                  )

              ),

              const SizedBox(height: 36,),

              CustomElevatedButton(label: "Save", function: (){})
            ],
          ),
        ),
      ),
    );
  }
}
