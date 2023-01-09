import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_textfield.dart';
import '../screens/member_registration_page_organization.dart';
import '../utils/widget_utils.dart';
import 'member_registration_page_individual.dart';

class RegistrationCode extends StatelessWidget {
  var regType;
  RegistrationCode({required this.regType, Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Code'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text('Enter Registration Code', style: TextStyle(fontSize: 20),),
            const SizedBox(height: 20,),
            FormTextField(controller: _controller,label: "Registration code",),
            ElevatedButton(onPressed: (){
              if (_controller.text.trim().isEmpty) {
                showErrorSnackBar(context, "Please input your registration code");
                return;
              }
              if(regType == 'member'){
                Navigator.push(context,MaterialPageRoute( builder: (_) => const MemberRegistrationPageIndividual(),));
              }else{
                Navigator.push(context,MaterialPageRoute( builder: (_) => const MemberRegistrationPageOrganization(),));
              }
            },
                child: const Text('Proceed'))
          ],
        )
      ),
    );
  }
}
