import 'package:akwaaba/Networks/member_api.dart';
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
                var regCode = _controller.text.trim();
                MemberAPI.searchRegCode(regCode: regCode).
                then((value){
                  if(value !=null){
                      var clientID = value['clientID'];
                      var clientLogo  = value['clientLogo'];
                      var clientName = value['clientName'];

                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Registration Code has been accepted')));
                    debugPrint('clientID = $clientID, clientLogo = $clientLogo , clientName = $clientName');
                    Navigator.push(context,MaterialPageRoute( builder: (_) => MemberRegistrationPageIndividual(clientID: clientID,clientLogo:clientLogo,clientName:clientName),));
                  }else{
                    showErrorSnackBar(context, "Please a valid Registration Code");
                  }
                });

              }else{
                var regCode = _controller.text.trim();
                MemberAPI.searchRegCode(regCode: regCode).
                then((value){
                  if(value !=null){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Registration Code has been accepted')));
                    debugPrint('clientID = $value');
                    Navigator.push(context,MaterialPageRoute( builder: (_) => MemberRegistrationPageOrganization(clientID: value,),));
                  }else{
                    showErrorSnackBar(context, "Please a valid Registration Code");
                  }
                });

              }
            },
                child: const Text('Proceed'))
          ],
        )
      ),
    );
  }
}
