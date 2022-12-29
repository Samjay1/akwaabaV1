import 'dart:convert';
import 'dart:io';

import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MemberRegistrationPageIndividual extends StatefulWidget {
  const MemberRegistrationPageIndividual({Key? key}) : super(key: key);

  @override
  State<MemberRegistrationPageIndividual> createState() => _MemberRegistrationPageIndividualState();
}

class _MemberRegistrationPageIndividualState extends State<MemberRegistrationPageIndividual> {

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerWhatsappContact = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerIDNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  List <String> departments =["Senior Staff","Casual Worker"];
  List <String> genders =["Male","Female"];
  DateTime? dateJoined;
  DateTime? birthDate;
  String? selectedGender;
  String? selectedDepartment;

  int disabilityOption=-1;
   final PageController pageViewController= PageController();
  int currentIndex = 0;
  final ImagePicker picker = ImagePicker();
  File? imageFile ;
  final formGlobalKey = GlobalKey < FormState > ();
  var selectedBranch;
  var selectedCategory;


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

  void selectProfilePhoto() async{
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
        //check these inputs -> gender and dob
      if(birthDate==null){
        showErrorSnackBar(context, "select date of birth");
        return;
      }
      if(selectedGender==null){
        showErrorSnackBar(context, "select your gender");
        return;
      }
        pageViewController.animateToPage(1, duration: const Duration(milliseconds: 100),
             curve: Curves.easeIn);
        break;
      case 1:
        //currenty on grouping page
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
        title: const Text("Individual Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentIndex==0?
                  "Bio Data":
                  currentIndex==1?"Grouping":
                      currentIndex==2?"Location":currentIndex==3?"Statuses":"",
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
                  bioDataView(),
                  groupingView(),
                  locationView(),
                  statusView(),
                  passwordsView(),
                ],
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey,width: 0))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentIndex==0?
                  Container():CupertinoButton(child: Row(
                    children: const [
                      Icon(CupertinoIcons.arrow_left),
                      Text("Previous"),
                    ],
                  ),
                      onPressed: (){
                        pageViewController.animateToPage(
                        currentIndex-1,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                       // nextButtonTapped(pageId: pageViewController.page);
                      }),

                  const SizedBox(width: 12,),

                  currentIndex==4?
                  Container():CupertinoButton(child: Row(
                    children: const [
                      Text("Next"),
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

  Widget bioDataView(){
    return Form(
      key: formGlobalKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(label: "First Name",
              setCompulsory: true,
              child:  FormTextField(controller: _controllerFirstName,
                label: "",)
          ),

          LabelWidgetContainer(label: "Middle Name",
              child:  FormTextField(controller: _controllerMiddleName,
                label: "",applyValidation: false,)
          ),

          LabelWidgetContainer(label: "Surname",
            setCompulsory: true,
            child:
            FormTextField(controller: _controllerSurname,
              label: "",),
          ),

          LabelWidgetContainer(label: "Gender",
              setCompulsory: true,
              child: FormButton(
                label:selectedGender??"Select Gender",
                function: (){selectGender();},
              )),

          LabelWidgetContainer(label: "Date of Birth",
              setCompulsory: true,
              child: FormButton(
                label: birthDate!=null?DateFormat("dd MMM yyyy").format(birthDate!):
                "Select Date",
                function: (){selectDateOfBirth();},
              )),


          LabelWidgetContainer(label:"Phone" ,
            setCompulsory: true,
            child:    FormTextField(controller: _controllerPhone,label: "",
              textInputAction: TextInputAction.next,textInputType: TextInputType.phone,
              maxLength: 10,),),

          LabelWidgetContainer(label: "Email Address",
            setCompulsory: true,
            child: FormTextField(controller: _controllerEmail,
            label: "",
            textInputType: TextInputType.emailAddress,),),

          LabelWidgetContainer(label: "Whatsapp Contact",
              child: FormTextField(controller: _controllerWhatsappContact,
                textInputType: TextInputType.phone,maxLength: 10,applyValidation: false,)),



          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

             imageFile!=null?
             ClipRRect(
               borderRadius: BorderRadius.circular(360),
               child: Image.file(imageFile!,height: 120,width: 120,),
             ):
             defaultProfilePic(height: 120),
              CupertinoButton(
                  onPressed: (){
                    selectProfilePhoto();
                  },
                  child: Text(imageFile!=null?"Change Photo":"Select Photo"))
            ],
          ),


        ],
      ),
    );
  }

  Widget groupingView(){
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

  Widget locationView(){
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
           // setCompulsory: true,
            label: "Province/State",
            child: FormButton(
              label: "Select Province/State",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            //setCompulsory: true,
            label: "Region",
            child: FormButton(
              label: "Select Region",
              function: (){},
            )
        ),

        LabelWidgetContainer(
           // setCompulsory: true,
            label: "District",
            child: FormButton(
              label: "Select District",
              function: (){},
            )
        ),

        LabelWidgetContainer(
            //setCompulsory: true,
            label: "Constituency",
            child: FormButton(
              label: "Select Constituency",
              function: (){},
            )
        ),

        LabelWidgetContainer(

            label: "Community",
            child: FormButton(
              label: "Select Community",
              function: (){},
            )
        ),


      ],
    );
  }

  Widget statusView(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            const Expanded(child: Text("Do you have a disability?")),
            Row(
              children:  List.generate(2, (index) {
                return Row(
                  children: [
                    Radio(
                        activeColor: primaryColor,
                        value: index, groupValue: disabilityOption,
                        onChanged: (int? value){
                      setState(() {
                        disabilityOption=value!;
                      });
                        }),
                    Text(index==0?"Yes":"No")
                  ],
                );
              }),
            )
          ],
        ),

        const SizedBox(height: 12,),


        LabelWidgetContainer(label: "Marital Status",
            child:FormButton(
              label: "Select Status",
              function: (){},
            )
        ),

        LabelWidgetContainer(label: "Education",
            child:FormButton(
              label: "Select Education",
              function: (){},
            )
        ),

        LabelWidgetContainer(label: "Occupation",
            child:FormButton(
              label: "Select Occupation",
              function: (){},
            )
        ),

        LabelWidgetContainer(label: "Profession",
            child:FormButton(
              label: "Select Profession",
              function: (){},
            )
        ),



        LabelWidgetContainer(label: "ID Upload", child:
        FormButton(label: "Upload  ID",
        function: (){},)
        ),
        
        
        LabelWidgetContainer(label: "ID Number", child:
        FormTextField(
          controller: _controllerIDNumber,
        )
        ),

        LabelWidgetContainer(label: "CV Upload", child:
        FormButton(label: "Upload  CV",
          function: (){},)
        )

      ],
    );
  }

  Widget passwordsView(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        LabelWidgetContainer(label: "Password",
            child:
        FormTextField(
          controller: _controllerPassword,
        )
        ),


        LabelWidgetContainer(label: "Confirm Password",
            child:
            FormTextField(
              controller: _controllerConfirmPassword,
            )
        ),

        const SizedBox(height: 26,),

        CustomElevatedButton(label: "Submit",
            function: (){})


      ],
    );
  }

  registerUser(){
    FocusManager.instance.primaryFocus?.unfocus();//hide keyboard
    //check inputs

  }


  selectGender(){
    displayCustomDropDown(options: genders, context: context,listItemsIsMap: false).then((value) {
      if(value!=null){
        setState(() {
          selectedGender = value;
        });
      }
    });
  }

  selectDepartment(){
    displayCustomDropDown(options: departments, context: context,listItemsIsMap: false).then((value) {
      if(value!=null){
        setState(() {
          selectedDepartment = value;
        });
      }
    });
  }

  selectDateJoined(){
    displayDateSelector(initialDate: dateJoined??DateTime.now(),
        context: context).then((value) {
       if(value!=null){
         setState(() {
           dateJoined=value;
         });
       }
    });
  }

  selectDateOfBirth(){
    displayDateSelector(initialDate: birthDate??DateTime.now(),
        context: context).then((value) {
      if(value!=null){
        setState(() {
          birthDate=value;
        });
      }
    });
  }


}
