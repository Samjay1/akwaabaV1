import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:flutter/material.dart';

import '../utils/widget_utils.dart';

class ExcuseInputPage extends StatefulWidget {
  const ExcuseInputPage({Key? key}) : super(key: key);

  @override
  State<ExcuseInputPage> createState() => _ExcuseInputPageState();
}

class _ExcuseInputPageState extends State<ExcuseInputPage> {
  final TextEditingController _controllerExcuse = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Excuse"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Padding(
              padding: EdgeInsets.only(
                right: 100
              ),
              child: Text("Excuse Request for Event/ Meeting Name",
              style: TextStyle(fontSize: 22),),
            ),
            const SizedBox(height: 36,),
            FormTextField(controller: _controllerExcuse,
            maxLength: 256,showMaxLength: true,minLines: 5,maxLines: 10,
            label: "What's your excuse?",),

              const SizedBox(height: 36,),

              CustomElevatedButton(label: "Submit", function: (){
                showNormalSnackBar(context,"Work in Progress");
              })
          ],)),
    );
  }
}
