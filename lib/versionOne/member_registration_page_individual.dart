import 'dart:convert';
import 'dart:io';

import 'package:akwaaba/Networks/member_api.dart';
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

import '../models/general/abstractModel.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/country.dart';
import '../models/general/district.dart';
import '../models/general/electoralArea.dart';
import '../models/general/region.dart';

class MemberRegistrationPageIndividual extends StatefulWidget {
  final clientID;
  const MemberRegistrationPageIndividual({required this.clientID, Key? key}) : super(key: key);

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


  //LOCATION - COUNTRY
  var selectedCountry;
  var selectedCountryID;
   late List<Country>? countryList = [];
   void _getCountryList ()async{
     countryList = (await MemberAPI().getCountry());
     Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
   }

  //LOCATION - REGION
  var selectedRegion;
  var selectedRegionID;
  late List<Region>? regionList = [];
  void _getRegionList ()async{
    regionList = (await MemberAPI().getRegion());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }


  //LOCATION - DISTRICT
  var selectedDistrict;
  var selectedDistrictID;
  late List<District>? districtList = [];
  void _getDistrictList ({var regionID})async{
    districtList = (await MemberAPI().getDistrict(regionID: regionID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //LOCATION - CONSTITUENCY
  var selectedConstituency;
  var selectedConstituencyID;
  late List<Constituency>? constituencyList = [];
  void _getConstituencyList ({var regionID, var districtID})async{
    constituencyList = (await MemberAPI().getConstituency(regionID: regionID,districtID:districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //LOCATION - COMMUNITY
  var selectedCommunity;
  var selectedCommunityID;
  late List<ElectoralArea>? communityList = [];
  void _getCommunityList ({var regionID, var districtID})async{
    communityList = (await MemberAPI().getElectoralArea(regionID: regionID, districtID:districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }


  //STATUS - MARITAL STATUS
  var selectedMarital;
  var selectedMaritalID;
  late List<AbstractModel>? maritalList = [];
  void _getMaritalList ()async{
    maritalList = (await MemberAPI().getMaritalStatus());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //STATUS - EDUCATION STATUS
  var selectedEducation;
  var selectedEducationID;
  late List<AbstractModel>? educationList = [];
  void _getEducationList ()async{
    educationList = (await MemberAPI().getEducation());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //STATUS - OCCUPATION STATUS
  var selectedOccupation;
  var selectedOccupationID;
  late List<AbstractModel>? occupationList = [];
  void _getOccupationList ()async{
    occupationList = (await MemberAPI().getOccupation());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }


  //STATUS - PROFESSION STATUS
  var selectedProfession;
  var selectedProfessionID;
  late List<AbstractModel>? professionList = [];
  void _getProfessionList ()async{
    professionList = (await MemberAPI().getProfession());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }


  @override
  void initState() {
    super.initState();
    _getCountryList();
    _getRegionList();
    _getMaritalList();
    _getEducationList();
    _getOccupationList();
    _getProfessionList();

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
    debugPrint('maritalList ${maritalList}');
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
            label: selectedCountry??"Select Country",
            function: (){
              var newCountryList = countryList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
              selectCountry(newCountryList);
            },
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
              label: selectedRegion??"Select Region",
              function: (){
                var newRegionList = regionList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                selectRegion(newRegionList);
              },
            )
        ),

        LabelWidgetContainer(
           // setCompulsory: true,
            label: "District",
            child: FormButton(
              label: selectedDistrict??"Select District",
              function: (){
                var newDistrictList = districtList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                selectDistrict(newDistrictList);
              },
            )
        ),

        LabelWidgetContainer(
            //setCompulsory: true,
            label: "Constituency",
            child: FormButton(
              label: selectedConstituency??"Select Constituency",
              function: (){
                var newConstituencyList = constituencyList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                selectConstituency(newConstituencyList);
              },
            )
        ),

        LabelWidgetContainer(

            label: "Community",
            child: FormButton(
              label: selectedCommunity??"Select Community",
              function: (){
                var newCommunityList = communityList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                selectCommunity(newCommunityList);
              },
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
              label: selectedMarital??"Select Status",
              function: (){
                var newMaritalList = maritalList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
                debugPrint('newMaritalList $newMaritalList');
                selectMarital(newMaritalList);
              },
            )
        ),

        LabelWidgetContainer(label: "Education",
            child:FormButton(
              label: selectedEducation??"Select Education",
              function: (){
                var newEducationList = educationList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
                selectEducation(newEducationList);
              },
            )
        ),

        LabelWidgetContainer(label: "Occupation",
            child:FormButton(
              label: selectedOccupation??"Select Occupation",
              function: (){
                var newOccupationList = occupationList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
                selectOccupation(newOccupationList);
              },
            )
        ),

        LabelWidgetContainer(label: "Profession",
            child:FormButton(
              label: selectedProfession??"Select Profession",
              function: (){
                var newProfessionList = professionList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
                selectProfession(newProfessionList);
              },
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
            function: (){
          debugPrint('firstname ${_controllerFirstName.text}, '
              'lastname ${_controllerSurname.text},'
              'middlename ${_controllerMiddleName.text},'
              'whatsapp ${_controllerWhatsappContact.text}'
              'phone ${_controllerPhone.text},'
              'email ${_controllerEmail.text}'
              'IDnumber ${_controllerIDNumber.text}'
              'password ${_controllerPassword.text}'
              'cpassword ${_controllerConfirmPassword.text}'
              'selectedGender ${selectedGender}'
              'selectedDepartment ${selectedDepartment}'
              'dateJoined ${dateJoined}'
              'birthDate ${birthDate}'
              'disabilityOption ${disabilityOption}');
            })


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


//  LOCATION
  selectCountry(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedCountry = value['name'];
          selectedCountryID =  value['id'];
          debugPrint('selectedCountryID $selectedCountryID, $selectedCountry');
        });
      }
    });
  }

  selectRegion(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedRegion = value['name'];
          selectedRegionID =  value['id'];
          debugPrint('selectedRegion $selectedRegion, $selectedRegionID');
          _getDistrictList(regionID:selectedRegionID);
        });
      }
    });
  }

  selectDistrict(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedDistrict = value['name'];
          selectedDistrictID =  value['id'];
          debugPrint('selectedRegion $selectedDistrict, $selectedDistrictID');
          _getConstituencyList(regionID:selectedRegionID, districtID:selectedDistrictID );
          _getCommunityList(regionID:selectedRegionID, districtID:selectedDistrictID );
        });
      }
    });
  }

  selectConstituency(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedConstituency = value['name'];
          selectedConstituencyID =  value['id'];
          debugPrint('Constituency $selectedConstituency, $selectedConstituencyID');
        });
      }
    });
  }

  selectCommunity(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedCommunity = value['name'];
          selectedCommunityID =  value['id'];
          debugPrint('selectedCommunity $selectedCommunity, $selectedCommunityID');
        });
      }
    });
  }


//  STATUSES
  selectMarital(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          // selectedMarital = value['name'];
          // selectedMaritalID =  value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectEducation(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedEducation = value['name'];
          selectedEducationID =  value['id'];
          debugPrint('selectedEducationID $selectedEducationID, $selectedEducation');
        });
      }
    });
  }

  selectOccupation(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedOccupation = value['name'];
          selectedOccupationID =  value['id'];
          debugPrint('selectedOccupationID $selectedOccupationID, $selectedOccupation');
        });
      }
    });
  }

  selectProfession(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedProfession = value['name'];
          selectedProfessionID =  value['id'];
          debugPrint('selectedProfessionID $selectedProfessionID, $selectedProfession');
        });
      }
    });
  }


}
