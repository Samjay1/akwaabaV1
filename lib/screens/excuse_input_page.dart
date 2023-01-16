import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widget_utils.dart';

class ExcuseInputPage extends StatelessWidget {
  ExcuseInputPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController _controllerExcuse = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var eventProvider = context.watch<HomeProvider>();
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
                padding: EdgeInsets.only(right: 100),
                child: Text(
                  "Send Excuse Request",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FormTextField(
                controller: eventProvider.excuseTEC,
                maxLength: 256,
                showMaxLength: true,
                minLines: 8,
                maxLines: 15,
                label: "What's your excuse?",
              ),
              const SizedBox(
                height: 26,
              ),
              CustomElevatedButton(
                label: "Submit",
                showProgress: eventProvider.submitting,
                function: () async => eventProvider.validateExcuseField(
                  context: context,
                ),
              )
            ],
          )),
    );
  }
}
