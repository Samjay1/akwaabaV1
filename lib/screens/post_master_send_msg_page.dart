import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/screens/post_master_filters_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class PostMasterSendMsgPage extends StatefulWidget {
  const PostMasterSendMsgPage({Key? key}) : super(key: key);

  @override
  State<PostMasterSendMsgPage> createState() => _PostMasterSendMsgPageState();
}

class _PostMasterSendMsgPageState extends State<PostMasterSendMsgPage> {
  List messageType=["SMS","Voice","Web SMS", "Email"];
  int radioGroupValue=-1;
  int selectedMsgTypeIndex=10;
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerMSg = TextEditingController();
  int recurringMsgRadioId=-1;
  String? selectedRecurrence;


  selectRecurrence(){
    displayCustomDropDown(options: ["Daily","Weekly","Monthly","Quarterly","Annually"],
        context: context,listItemsIsMap: false).then((value) {
          if(value!=null){
            setState(() {
              selectedRecurrence=value;
            });
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Message Type",
                    style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600),),
                    messageTypeView(),
                     const SizedBox(height: 12,),

                     Align(
                         alignment: Alignment.center,
                         child:


                         OutlinedButton(
                           onPressed: (){},
                           child: Text("14$selectedMsgTypeIndex Credits",
                           style: const TextStyle(fontWeight: FontWeight.w600,
                           color: textColorPrimary),),
                         )),

                    const SizedBox(height: 24,),

                    CupertinoButton(

                      padding: EdgeInsets.zero,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                      children: const [
                          Icon(Icons.filter_alt_outlined,color: primaryColor,),
                          SizedBox(width: 8,),
                          Text("Message Filters",style: TextStyle(color: textColorPrimary),)
                      ],
                    ),
                        ), onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        PostMasterFiltersPage()));
                    }),

                    const SizedBox(height: 24,),


                    LabelWidgetContainer(label: "Is this a recurring message?",
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

                    recurringMsgRadioId==0?
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: LabelWidgetContainer(label: "Recurrence",
                              child: FormButton(
                                label:selectedRecurrence?? "",
                                function: (){
                                  selectRecurrence();
                                },
                              )),
                        ):const SizedBox.shrink(),

                    const SizedBox(height: 18,),


                    LabelWidgetContainer(
                        label: "Subject",
                        child: FormTextField(controller: _controllerSubject,
                        minLines: 2,textInputAction: TextInputAction.newline,
                            textInputType: TextInputType.multiline,maxLength: 100,maxLines: 2,)),

                    LabelWidgetContainer(label: "Message",

                        child:  FormTextField(controller: _controllerMSg,
                          minLines: 7,textInputAction: TextInputAction.newline,
                          textInputType: TextInputType.multiline,
                          maxLength:selectedMsgTypeIndex==0?500:selectedMsgTypeIndex==2?4000:1000,
                          maxLines: 12,showMaxLength: true,
                        hint: " ${selectedMsgTypeIndex==0?"SMS 500 Characters Max":
                        selectedMsgTypeIndex==2?"Compose Web message 4000 characters Max":"Compose Message "} ",
                        )),

                    LabelWidgetContainer(label: "Attachment",
                        child: FormButton(label: "Select File",
                        function: (){},
                          iconData: Icons.attach_file,
                        ))



                  ],
                ),
              ),
            ),

            
            CustomElevatedButton(label: "Send", function: (){}),
          ],
        ),
      ),
    );
  }

  Widget messageTypeView(){
    return   GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      childAspectRatio: 5,
      crossAxisCount: 2,
      children: [
        for(int i=0;i<messageType.length;i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(" ${messageType[i]}",style:
            const TextStyle(color: textColorPrimary),),
            leading: Radio(
              value: i,
              groupValue: radioGroupValue,
              activeColor: primaryColor,
              onChanged: i==messageType.length?null:(int? value){
                setState(() {
                  radioGroupValue = value!;
                  selectedMsgTypeIndex=value;
                  //selectedMainCategory = getMainCategories[value];
                });
              },
            ),
          )
      ],
    );
  }
}
