import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendBirthdayMessageView extends StatefulWidget {
  const SendBirthdayMessageView({Key? key}) : super(key: key);

  @override
  State<SendBirthdayMessageView> createState() => _SendBirthdayMessageViewState();
}

class _SendBirthdayMessageViewState extends State<SendBirthdayMessageView> {
  final TextEditingController _controllerMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
      Container(
        //height: MediaQuery.of(context).size.height*0.6,
        padding: const EdgeInsets.only(bottom: 24,left: 16,right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CupertinoButton(
                    child: const Text("Close"), onPressed: (){
                Navigator.pop(context);
              })],
            ),
            const Divider(height: 1,),
            const SizedBox(height: 24,),

            // SvgPicture.asset("images/illustrations/celebrate.svg",
            //   height: 130,),

            const Text("What do you have to tell Steward Peters?",
            style: TextStyle(
              fontSize: 15,fontWeight: FontWeight.w400
            ),),
            const SizedBox(height: 24,),
            Padding(
              padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: FormTextField(controller: _controllerMessage,
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
              maxLines: 8,minLines: 4,),
            ),

            CustomElevatedButton(label: "Send", function: (){}),
          ],
        ),
      );

  }
}
