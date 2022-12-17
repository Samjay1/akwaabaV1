import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTextModalView extends StatefulWidget {
  final String title;
  final String existingData;
  const InputTextModalView({required this.title,
  required this.existingData,Key? key}) : super(key: key);

  @override
  State<InputTextModalView> createState() => _InputTextModalViewState();
}

class _InputTextModalViewState extends State<InputTextModalView> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16),
      color: backgroundColor,
      child: Form(
        key:_formKey ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CupertinoButton(child: const Text("Close",
                style: TextStyle(color: Colors.red),), onPressed: (){Navigator.pop(context);}),
              ],
            ),
            const Divider(height: 1,color: Colors.black,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 36,),
                  Text(widget.title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                  const SizedBox(height: 12,),

                  Padding(
                    padding:  EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: FormTextField(controller: _controller,
                      textInputAction: TextInputAction.done,),
                  ),

                  const SizedBox(height: 24,),

                  Padding(
                    padding: EdgeInsets.only(
                        bottom:  MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: CustomElevatedButton(label: "Done", function: (){

                      if(_formKey.currentState!.validate()){


                        Navigator.pop(context,_controller.text.trim());
                      }


                    }),
                  ),

                  const SizedBox(height: 36,),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
