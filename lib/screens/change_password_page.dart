import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _controllerOldPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerNewPasswordConfirm = TextEditingController();
  bool oldPasswordConfirmed=false;
  bool showPassword=false;

  @override
  void dispose() {
    _controllerNewPassword.dispose();
    _controllerNewPasswordConfirm.dispose();
    _controllerOldPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [

            oldPasswordConfirmed?newPasswordInput():oldPasswordInputView()

          ],
        ),
      ),
    );
  }

  Widget oldPasswordInputView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 52,),

        FormTextField(controller: _controllerOldPassword,label: "Old Password",
        textInputAction: TextInputAction.done,),

        const SizedBox(height: 48,),

        CustomElevatedButton(label: "Submit", function: (){confirmOldPassword();})

      ],
    );
  }

  Widget newPasswordInput(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const Text("Let's set up your new password",
        style: TextStyle(fontSize: 28),),

        const SizedBox(height: 32,),

        FormTextField(controller: _controllerNewPassword,label: "New Password",
          textInputAction: TextInputAction.next,suffixTapFunction: (){showOrHidePassword();},
        obscureText: showPassword,),

        FormTextField(controller: _controllerNewPasswordConfirm,label: "Old Password",
          textInputAction: TextInputAction.done,
        obscureText: showPassword,suffixTapFunction: (){showOrHidePassword();},),


        const SizedBox(height: 32,),

        CustomElevatedButton(label: "Submit", function: (){
          setupNewPassword();
        })

      ],
    );
  }

  confirmOldPassword(){
    if(_controllerOldPassword.text.trim().isNotEmpty){
      ///do the checks
      setState(() {
        oldPasswordConfirmed=true;
      });
    }else{
      showErrorSnackBar(context, "Please input your old password");
    }
  }

  setupNewPassword(){

  }


  showOrHidePassword(){
    setState(() {
      showPassword=!showPassword;
    });
  }


}
