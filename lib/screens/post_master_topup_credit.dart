import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';

import '../components/form_button.dart';
import '../utils/widget_utils.dart';

class PostMasterTopupCreditPage extends StatefulWidget {
  const PostMasterTopupCreditPage({Key? key}) : super(key: key);

  @override
  State<PostMasterTopupCreditPage> createState() => _PostMasterTopupCreditPageState();
}

class _PostMasterTopupCreditPageState extends State<PostMasterTopupCreditPage> {
  String? selectedServiceType;
  String? selectedAccountType;
  bool agreeToPaymentTerms=false;
  int recurringMsgRadioId=-1;
  final TextEditingController _controllerAmount= TextEditingController();


  selectServiceType(){
    displayCustomDropDown(
        title: "Service Type ",
        options: ["SMS","Voice","Web SMS",
          "Email"], context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedServiceType=value;
      });
    });
  }

  selectAccountType(){
    displayCustomDropDown(
        title: "Account Type",
        options: ["Prepaid","Postpaid"],
        context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedAccountType=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Popup Credit"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
               
                children: [
                  
                  LabelWidgetContainer(label: "Service Type",

                      child: FormButton(label:selectedServiceType??"Select Service Type",
                      function: (){selectServiceType();},)),

                  LabelWidgetContainer(label: "Account Type",

                      child: FormButton(label:selectedAccountType??"Select Account Type",
                        function: (){selectAccountType();},)),

                  LabelWidgetContainer(label: "Amount",
                      child: FormTextField(
                        controller: _controllerAmount,
                        textInputType: TextInputType.number,
                        maxLength: 5,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                      )),


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text("Total Credits -  Expiring Date here"),
                  ),

                  LabelWidgetContainer(label: "Branches to be Credited",
                      child: FormButton(
                        label: "Select Branch",
                        function: (){},
                      )),


                  LabelWidgetContainer(label: "Agree to payment terms?",
                    child:
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 0.0,color:Colors.grey.shade400)
                      ),
                      child: Row(
                        children:
                        List.generate(2,
                                (index) {
                              return Expanded(
                                child: Row(

                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                            activeColor: primaryColor,
                                            value: index,
                                            groupValue: recurringMsgRadioId, onChanged: (int? value){
                                          setState(() {
                                            recurringMsgRadioId=index;
                                          });
                                        }
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(index==0?"Yes":"No"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),),
                  
                ],
              ),
            ),
            CustomElevatedButton(label: "Proceed Payment", function: (){})
          ],
        ),
      ),
    );
  }
}
