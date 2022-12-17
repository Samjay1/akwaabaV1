import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/material.dart';

class DeviceActivationRequestPage extends StatefulWidget {
  const DeviceActivationRequestPage({Key? key}) : super(key: key);

  @override
  State<DeviceActivationRequestPage> createState() => _DeviceActivationRequestPageState();
}

class _DeviceActivationRequestPageState extends State<DeviceActivationRequestPage> {
  final TextEditingController _controllerEmailAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Activation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const LabelWidgetContainer(label: "Device Type",
                  child: Text("Browser PWA")),

              const SizedBox(height: 24,),


              const LabelWidgetContainer(label: "Device ID",
                  child: Text("khfhef_njb32i-fnj")),

              const SizedBox(height: 36,),


              FormTextField(controller: _controllerEmailAddress,
                label:"Email Address",iconData: Icons.email_outlined,),

              CustomElevatedButton(label: "Request Activation", function: (){})
            ],
          ),
        ),
      ),
    );
  }
}
