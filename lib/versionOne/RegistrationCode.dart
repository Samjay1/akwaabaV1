import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_textfield.dart';
import 'member_registration_page_organization.dart';
import '../utils/widget_utils.dart';
import 'member_registration_page_individual.dart';

class RegistrationCode extends StatefulWidget {
  var regType;
  RegistrationCode({required this.regType, Key? key}) : super(key: key);

  @override
  State<RegistrationCode> createState() => _RegistrationCodeState();
}

class _RegistrationCodeState extends State<RegistrationCode> {
  final TextEditingController _controller = TextEditingController();

  bool loading = false;

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
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Enter Registration Code',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              FormTextField(
                controller: _controller,
                label: "Registration code",
              ),
              loading
                  ? const CustomProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) {
                          showErrorSnackBar(
                              context, "Please input your registration code");
                          return;
                        }
                        if (widget.regType == 'member') {
                          setState(() => loading = true);
                          var regCode = _controller.text.trim();
                          MemberAPI.searchRegCode(regCode: regCode)
                              .then((value) {
                            setState(() => loading = false);
                            if (value != null) {
                              var clientID = value['clientID'];
                              var clientLogo = value['clientLogo'];
                              var clientName = value['clientName'];

                              showNormalSnackBar(
                                context,
                                'Registration code has been accepted',
                              );
                              debugPrint(
                                  'clientID = $clientID, clientLogo = $clientLogo , clientName = $clientName');
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MemberRegistrationPageIndividual(
                                            clientID: clientID,
                                            clientLogo: clientLogo,
                                            clientName: clientName),
                                  ));
                            } else {
                              showErrorSnackBar(context,
                                  "Please enter a valid Registration Code");
                            }
                          });
                        } else {
                          setState(() => loading = true);
                          var regCode = _controller.text.trim();
                          MemberAPI.searchRegCode(regCode: regCode)
                              .then((value) {
                            setState(() => loading = false);
                            if (value != null) {
                              var clientID = value['clientID'];
                              var clientLogo = value['clientLogo'];
                              var clientName = value['clientName'];

                              showNormalSnackBar(
                                context,
                                'Registration code has been accepted',
                              );
                              debugPrint('clientID = $value');
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MemberRegistrationPageOrganization(
                                            clientID: clientID,
                                            clientLogo: clientLogo,
                                            clientName: clientName),
                                  ));
                            } else {
                              showErrorSnackBar(context,
                                  "Please enter a valid Registration Code");
                            }
                          });
                        }
                      },
                      child: const Text('Proceed'),
                    ),
            ],
          )),
    );
  }
}
