import 'dart:io';

import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class MemberRegistrationPageOrganization extends StatefulWidget {
  final clientID;
  const MemberRegistrationPageOrganization({required this.clientID, Key? key}) : super(key: key);

  @override
  State<MemberRegistrationPageOrganization> createState() => _MemberRegistrationPageOrganizationState();
}

class _MemberRegistrationPageOrganizationState extends State<MemberRegistrationPageOrganization> {

  final TextEditingController _controllerOrgName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerWebsite = TextEditingController();
  final TextEditingController _controllerCoreAreas = TextEditingController();
  final TextEditingController _controllerPostalAddress = TextEditingController();

  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerContactPhone= TextEditingController();
  final TextEditingController _controllerContactEmail= TextEditingController();
  final TextEditingController _controllerContactWhatsapp = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword= TextEditingController();

  bool confirmPasswordVisible=true;
  bool passwordVisible=true;
  final PageController pageViewController= PageController();
  int currentIndex = 0;
  final ImagePicker picker = ImagePicker();
  File? imageFile ;
  int organizationLegalRegistration=-1;
  final formGlobalKey = GlobalKey < FormState > ();


  @override
  void initState() {
    super.initState();


    pageViewController.addListener(() {
      if (pageViewController.page?.round() != currentIndex) {
        setState(() {
          currentIndex = pageViewController.page!.round();
        });
      }
    });
  }

  void selectLogo() async{
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(getImage!=null){
        imageFile = File(getImage.path);
      }
    });
  }

  nextButtonTapped({required  pageId}){
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }

    switch(pageId){
      case 0:
      //currently on bio data page,
      //check these inputs -> first name, last name, DOB, gender, email, phone
        pageViewController.animateToPage(1, duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
        break;
      case 1:
      //currenty on
        pageViewController.animateToPage(2, duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
        break;
      case 2:
        pageViewController.animateToPage(3, duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
        break;
      case 3:
        pageViewController.animateToPage(4, duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
        break;



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: currentIndex==0?true:false,
        title: const Text("Organization Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentIndex==0?
              "Organizational Info ":
              currentIndex==1?"Grouping":
              currentIndex==2?"Location":currentIndex==3?"Contact Person":"",
              style: const TextStyle(
                  fontSize: 23,fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 12,),
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: pageViewController,
                children: [
                  organizationalInfoView(),
                  groupingInfoView(),
                  locationInfoView(),
                  contactInfoInfoView(),
                ],
              ),
            ),




            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0,
                    color: Colors.grey
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentIndex==0?
                  Container():CupertinoButton(child: Row(
                    children: const [
                      Icon(CupertinoIcons.arrow_left),
                      SizedBox(width: 8,),
                      Text("Previous"),
                    ],
                  ),
                      onPressed: (){
                        pageViewController.animateToPage(
                            currentIndex-1,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      }),

                  const SizedBox(width: 12,),

                  currentIndex==3?
                  Container():CupertinoButton(child: Row(
                    children: const [
                      Text("Next"),
                      SizedBox(width: 8,),
                      Icon(CupertinoIcons.arrow_right),
                    ],
                  ),
                      onPressed: (){
                        nextButtonTapped(pageId: pageViewController.page);
                      })

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget organizationalInfoView(){
    return Form(
      key: formGlobalKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(
              setCompulsory: true,
              label: "Name of Organization",
              child:  FormTextField(controller: _controllerOrgName,
                label: "",applyValidation: true,)
          ),


          Container(
            decoration:  BoxDecoration(
             // border: Border.all(color: textColorLight),
              borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [

                 Container(
                   height: 150,
                   width: 220,
                   child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:  imageFile!=null?
                      Image.file(imageFile!,height:120,width: double.infinity,
                          fit: BoxFit.cover)
                            :Image.asset("images/img.png",
                          height:90,width:100,fit: BoxFit.cover, )
                      ),
                 ),
                CupertinoButton(child: Text(
                    imageFile!=null?"Change Logo":
                    "Upload Logo"),
                    onPressed: (){
                  selectLogo();
                    })
              ],
            ),
          ),

          LabelWidgetContainer(label: "Is the organization legally registered?",
              setCompulsory: true,
              child: Row(
                children: List.generate(2, (index) {
                  return Row(
                    children: [
                      Radio(
                          activeColor: primaryColor,
                          value: index,
                          groupValue: organizationLegalRegistration,
                          onChanged: (int? value){
                        setState(() {
                          organizationLegalRegistration=value!;
                        });
                          }),
                      const SizedBox(width: 6,),
                      Text(index==0?"Yes":"No")

                    ],
                  );
                }),
              )),
          const SizedBox(height: 8,),

          organizationLegalRegistration==0?
              Column(
                children: [
                  LabelWidgetContainer(label: "Date of Registration",
                      child:
                  FormButton(
                    label: "Select date of Registration",
                    function: (){},
                  )
                  ),

                  LabelWidgetContainer(label: "Upload Registration Certificate",
                      child:
                  FormButton(label: "Select File",
                  function: (){},)
                  )
                ],
              ):SizedBox.shrink(),

          LabelWidgetContainer(label: "Organization Type/Description",
              child:
          FormButton(
            label: "",
            function: (){},
          )
          ),

          LabelWidgetContainer(
              setCompulsory: true,
              label: "Email",
              child:
              FormTextField(controller: _controllerEmail,
              textInputType: TextInputType.emailAddress,applyValidation: true,)
          ),

          LabelWidgetContainer(label: "Phone",
              setCompulsory: true,
              child:
              FormTextField(controller: _controllerPhone,
              textInputType: TextInputType.phone,
              maxLength: 10,)
          ),
          LabelWidgetContainer(label: "Website",
              child:
              FormTextField(controller: _controllerWebsite,
              textInputType: TextInputType.url,applyValidation: false,
              hint: "https://mywebsiteurl.com",)
          ),
          LabelWidgetContainer(label: "Postal Address",
              child:
              FormTextField(controller: _controllerPostalAddress,
                applyValidation: false,maxLength: 200,)
          ),

          LabelWidgetContainer(label: "Core Areas of Operation",
              child: FormTextField(
                controller: _controllerCoreAreas,
                maxLength: 500,
                minLines: 6,maxLines: 12,
                showMaxLength: true,
                applyValidation: false,
              ))



        ],
      ),
    );
  }

  Widget groupingInfoView(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        LabelWidgetContainer(label: "Branch",
            setCompulsory: true,
            child: FormButton(
              label: "Select Branch",
              function: (){

              },
            )
        ),

        LabelWidgetContainer(label: "Category",
            setCompulsory: true,
            child: FormButton(
              label: "Select Category",
              function: (){

              },
            )
        ),

        LabelWidgetContainer(label: "Group",
            child: FormButton(
              label: "Select Group",
              function: (){

              },
            )
        ),

        LabelWidgetContainer(label: "Sub Group",
            child: FormButton(
              label: "Select Sub Group",
              function: (){

              },
            )
        )
      ],
    );

  }

  Widget locationInfoView(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        LabelWidgetContainer(
            setCompulsory: true,
            label: "Country",
            child: FormButton(
              label: "Select Country",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            setCompulsory: true,
            label: "Province/State",
            child: FormButton(
              label: "Select Province/State",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            setCompulsory: true,
            label: "Region",
            child: FormButton(
              label: "Select Region",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            setCompulsory: true,
            label: "District",
            child: FormButton(
              label: "Select District",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            setCompulsory: true,
            label: "Constituency",
            child: FormButton(
              label: "Select Constituency",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            setCompulsory: true,
            label: "Community",
            child: FormButton(
              label: "Select Community",
              function: (){},
            )
        ),


      ],
    );
  }

  Widget contactInfoInfoView(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [

        LabelWidgetContainer(label: "Name",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerContactName,
            )),

        LabelWidgetContainer(label: "Email Address",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerContactEmail,
            )),

        LabelWidgetContainer(label: "Phone",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerContactPhone,
              textInputType: TextInputType.number,
              maxLength: 10,
            )),

        LabelWidgetContainer(label: "Whatsapp Contact",
            setCompulsory: false,
            child: FormTextField(
              controller: _controllerContactWhatsapp,
              textInputType: TextInputType.number,
              maxLength: 10,
            )),

        const Divider(
          color: Colors.black38,
        ),

        const SizedBox(height: 36,),


        LabelWidgetContainer(label: "Password",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerPassword,
              obscureText: passwordVisible,
              suffixTapFunction: (){
                setState(() {
                  passwordVisible=!passwordVisible;
                });
              },
            ),
            ),

        LabelWidgetContainer(label: "Confirm Password",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerConfirmPassword,
              obscureText: confirmPasswordVisible,
              suffixTapFunction: (){
                setState(() {
                  confirmPasswordVisible=!confirmPasswordVisible;
                });
              },
            )),

        const SizedBox(height: 36,),

        CustomElevatedButton(label: "Submit", function: (){})
      ],
    );
  }
}
