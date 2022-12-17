import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:flutter/material.dart';

import '../utils/widget_utils.dart';

class WebAdminSetupPage extends StatefulWidget {
  const WebAdminSetupPage({Key? key}) : super(key: key);

  @override
  State<WebAdminSetupPage> createState() => _WebAdminSetupPageState();
}

class _WebAdminSetupPageState extends State<WebAdminSetupPage> {
  final TextEditingController _controllerEmail= TextEditingController();
  final TextEditingController _controllerPassword= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            defaultProfilePic(height: 100),

            const SizedBox(height: 24,),

            const Text("Enter Admin Credentials",style: TextStyle(
              fontWeight: FontWeight.w600,fontSize: 19
            ),textAlign: TextAlign.center,),

            const SizedBox(height: 48,),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormTextField(controller: _controllerEmail, textInputType: TextInputType.emailAddress,
                    label: "Email or Phone",
                  ),

                  FormTextField(controller: _controllerPassword, textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,label: "Password",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48,),

            CustomElevatedButton(label: "Submit", function: (){clientAccountLogin();})

          ],
        ),
      ),
    );
  }

  clientAccountLogin(){
    FocusManager.instance.primaryFocus?.unfocus();//hide keyboard
    //check inputs
    if(_formKey.currentState!.validate()){

    }
  }
}
