import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/dialogs_modals/input_text_modal_view.dart';
import 'package:akwaaba/screens/change_password_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final TextEditingController _controllerProfession = TextEditingController();
  final TextEditingController _controllerPlaceWork = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerWhatsappContact = TextEditingController();
  final TextEditingController _controllerCommunity = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerOccupation = TextEditingController();

  final TextEditingController _controllerOrgWebsite = TextEditingController();
  final TextEditingController _controllerOrgPostalAddress = TextEditingController();
  final TextEditingController _controllerOrgContactPersonName = TextEditingController();
  final TextEditingController _controllerOrgContactPersonEmail = TextEditingController();
  final TextEditingController _controllerOrgContactPersonPhone = TextEditingController();

  String? selectedGroup;
  DateTime? _dateJoined;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  bool showProgressIndicator=false;
  String? twitterHandle;
  String? facebookHandle;
  String? instagramHandle;
  File? cvFile;
  File? idcardFile;
  File? orgBusRegistrationFile;

  @override
  void initState() {
    super.initState();
  }

  openImageSelector()async{
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(getImage!=null){
        imageFile = File(getImage.path);
      }
    });
  }

  getAccountInfo(){
    //get account info and populate to views

  }

  openTextInputModalSheet(int socialMediaId, {required String title,
    required String data}){
    //socialMediaId twitter = 1, facebook=2, instagram=3
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_){
          return Wrap(
            children:   [
              InputTextModalView(title: title, existingData:data ),
            ],
          );
        }).then((value) {
      if(value!=null){
        setState(() {
          switch(socialMediaId){
            case 1:
              twitterHandle = value;
              break;
            case 2:
              facebookHandle = value;
              break;
            case 3:
              instagramHandle = value;
              break;
          }

        });

      }
    });

  }



  selectGroupOrDepartment(){
    displayCustomDropDown(options: ["Senior Staff","Casual Worker"], context: context,listItemsIsMap: false).then((value) {
      if(value!=null){
        setState(() {
          selectedGroup = value;
        });
      }
    });
  }

  selectDateJoined(){
    displayDateSelector(initialDate: _dateJoined??DateTime.now(),
        context: context).then((value) {
      if(value!=null){
        setState(() {
          _dateJoined=value;
        });
      }
    });
  }


  selectCVFile()async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx','docx','pdf'],
    );

    // setState(() {
    //   showProgressIndicator=false;
    // });
    if (result != null) {
      setState(() {

        cvFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }

  }

  selectIDCardFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx','docx','pdf'],
    );

    // setState(() {
    //   showProgressIndicator=false;
    // });
    if (result != null) {
      setState(() {

        idcardFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }


  selectOrgRegistrationFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx','docx','pdf'],
    );

    // setState(() {
    //   showProgressIndicator=false;
    // });
    if (result != null) {
      setState(() {

        orgBusRegistrationFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [

                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          imageFile!=null?
                             ClipRRect(
                               borderRadius: BorderRadius.circular(360),
                               child:  Image.file(imageFile!,height: 120,width: 120,fit: BoxFit.cover,),
                             ):
                           defaultProfilePic(height: 120),
                          Positioned(
                            right: 0,
                              bottom: 30,
                              child: CircleAvatar(
                                child: IconButton(
                                  onPressed: (){
                                    openImageSelector();
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ))
                        ],
                      ),
                    ),


                    userIndividualView(),

                    LabelWidgetContainer(label: "Twitter Handle",
                        child: FormButton(label: twitterHandle??"Input Handle", function: (){
                          openTextInputModalSheet(1, title: "Twitter Handle", data: twitterHandle??"");
                        })
                    ),

                    LabelWidgetContainer(label: "Facebook Handle",
                        child: FormButton(label: facebookHandle??"Input Handle", function: (){
                          openTextInputModalSheet(2, title: "Facebook Handle", data: facebookHandle??"");
                        })
                    ),

                    LabelWidgetContainer(label: "Instagram Handle",
                        child: FormButton(label: instagramHandle??"Input Handle", function: (){
                          openTextInputModalSheet(3, title: "Instagram Handle", data: instagramHandle??"");
                        })
                    ),

                    LabelWidgetContainer(label: "Community",
                        child: FormTextField(controller: _controllerCommunity,label: "",)),

                    LabelWidgetContainer(label: "Brief Description",
                        child: FormTextField(controller: _controllerDescription,
                          minLines: 3,maxLength: 256,maxLines: 6,)),

                    LabelWidgetContainer(label: "Group / Department",
                        child: FormButton(label: selectedGroup??"Select a group",
                        function: (){selectGroupOrDepartment();},)),

                    LabelWidgetContainer(label: "Sub Group ",
                        child: FormButton(label: selectedGroup??"Select a sub group",
                          function: (){selectGroupOrDepartment();},)),

                    LabelWidgetContainer(label: "Date of joining organization",
                        child: FormButton(label: _dateJoined!=null?
                          DateFormat("dd MMMM yyy").format(_dateJoined!):"Select Date",
                          function: () {selectDateJoined();  },)),




                    FormButton(label: "Change Password",
                        function: (){
                          FocusManager.instance.primaryFocus?.unfocus();//hide keyboard
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>
                      const ChangePasswordPage()));
                        },suffixIconData: Icons.arrow_forward_ios_sharp,)


                  ],
                ),
              ),
            ),
            const SizedBox(height: 12,),
            CustomElevatedButton(label: "Save", function: (){}),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }


  Widget userIndividualView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelWidgetContainer(label: "Profession", child:  FormTextField(controller: _controllerProfession,label: "",)
          ,),

        LabelWidgetContainer(label: "Occupation", child:
        FormTextField(controller: _controllerOccupation,label: "",)
          ,),

        LabelWidgetContainer(label: "Place of work",
            child: FormTextField(controller: _controllerPlaceWork,)),

        LabelWidgetContainer(label: "Education",
            child: FormButton(
              label: "Select Education",
              function: (){},

            )),


        LabelWidgetContainer(label: "Marital Status",
            child: FormButton(
              label: "Select Marital Status",
              function: (){},

            )),


        LabelWidgetContainer(label: "Phone", child:
        FormTextField(controller: _controllerPhone,label: "",)),

        LabelWidgetContainer(label: "Email Address",
          child:  FormTextField(controller: _controllerEmail,),),

        LabelWidgetContainer(label: "Whatsapp Contact",
            child:   FormTextField(controller: _controllerWhatsappContact,)),



        LabelWidgetContainer(label: "ID Card", child: FormButton(
          label: "Upload ID Card",
          function: (){
            selectIDCardFile();
          },
        )),

        LabelWidgetContainer(label: "CV", child: FormButton(
          label:
          cvFile!=null?
          Path.basename(cvFile!.path):
          "Upload CV",
          function: (){
            selectCVFile();
          },
        )),

      ],
    );
  }

  Widget userOrganizationView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelWidgetContainer(label: "Registration Certificate",
            child: FormButton(
              label: "Select Registration Certificate File",
              ///if file already exists then show file name or change registration cert
              function: (){},
            )),

        LabelWidgetContainer(label: "Website",
            child: FormTextField(
             controller: _controllerOrgWebsite,
            )),

        LabelWidgetContainer(label: "Postal Address",
            child: FormTextField(
              controller: _controllerOrgPostalAddress,
            )),


        Text("Contact Person",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17
        ),),

        LabelWidgetContainer(label: "Contact Person Name",
            child: FormTextField(
              controller: _controllerOrgContactPersonName,
            )),

        LabelWidgetContainer(label: "Contact Person Email Address",
            child: FormTextField(
              controller: _controllerOrgContactPersonEmail,
              textInputType: TextInputType.emailAddress,
            )),


        LabelWidgetContainer(label: "Contact Person Phone",
            child: FormTextField(
              controller: _controllerOrgContactPersonPhone,
              textInputType: TextInputType.phone,
              maxLength: 10,
            )),

      ],
    );
  }





}


