import 'dart:io';

import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../components/custom_cached_image_widget.dart';
import '../models/general/abstractGroup.dart';
import '../models/general/abstractModel.dart';
import '../models/general/abstractSubGroup.dart';
import '../models/general/branch.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/country.dart';
import '../models/general/district.dart';
import '../models/general/electoralArea.dart';
import '../models/general/memberType.dart';
import '../models/general/region.dart';
import 'login_page.dart';

class MemberRegistrationPageIndividual extends StatefulWidget {
  final clientID;
  final clientName;
  final clientLogo;
  const MemberRegistrationPageIndividual({required this.clientID,this.clientName,this.clientLogo, Key? key}) : super(key: key);

  @override
  State<MemberRegistrationPageIndividual> createState() =>
      _MemberRegistrationPageIndividualState();
}

class _MemberRegistrationPageIndividualState
    extends State<MemberRegistrationPageIndividual> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerMiddleName = TextEditingController();
  final TextEditingController _controllerWhatsappContact =
      TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerIDNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final TextEditingController _controllerStateProvince =
  TextEditingController();
  final TextEditingController _controllerCommunity = TextEditingController();

  bool loading = false;

  List<String> departments = ["Senior Staff", "Casual Worker"];
  List<String> genders = ["Male", "Female"];
  DateTime? dateJoined;
  DateTime? birthDate;
  String? selectedGender;
  String? selectedDepartment;

  int disabilityOption = -1;
  final PageController pageViewController = PageController();
  int currentIndex = 0;
  final ImagePicker picker = ImagePicker();
  File? imageFile ;
  File? imageCV ;
  File? imageIDCard ;
  final formGlobalKeyBio = GlobalKey < FormState > ();
  final formGlobalKeyStatus = GlobalKey < FormState > ();
  final formGlobalKeyStateProvince = GlobalKey < FormState > ();
  final formGlobalKeyPassword = GlobalKey < FormState > ();



  //LOCATION - COUNTRY
  var selectedCountry;
  var selectedCountryID;
   late List<Country>? countryList = [];
   void _getCountryList ()async{
     countryList = (await MemberAPI().getCountry());
     Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {loadingLocation = false;}));

   }

  //LOCATION - REGION
  var selectedRegion;
  var selectedRegionID;
  late List<Region>? regionList = [];
  void _getRegionList ()async{
    regionList = (await MemberAPI().getRegion());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {loadingLocation = false;}));

  }


  //LOCATION - DISTRICT
  var selectedDistrict;
  var selectedDistrictID;
  late List<District>? districtList = [];
  void _getDistrictList ({var regionID})async{
    districtList = (await MemberAPI().getDistrict(regionID: regionID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {loadingLocation = false;}));

  }

  //LOCATION - CONSTITUENCY
  var selectedConstituency;
  var selectedConstituencyID ;
  late List<Constituency>? constituencyList = [];
  void _getConstituencyList ({var regionID, var districtID})async{
    constituencyList = (await MemberAPI().getConstituency(regionID: regionID,districtID:districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {loadingLocation = false;}));

  }

  //LOCATION - COMMUNITY
  var selectedCommunity;
  var selectedCommunityID;
  late List<ElectoralArea>? communityList = [];
  void _getCommunityList ({var regionID, var districtID})async{
    communityList = (await MemberAPI().getElectoralArea(regionID: regionID, districtID:districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {loadingLocation = false;}));

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

  //GROUPING - BRANCH
  var selectedBranch;
  var selectedBranchID;
  late List<Branch>? branchList = [];
  void _getBranchList ({required var token})async{
    branchList = (await MemberAPI().getBranches(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //GROUPING - CATEGORY
  var selectedCategory;
  var selectedCategoryID;
  late List<MemberType>? categoryList = [];
  void _getCategoryList ({required var token})async{
    categoryList = (await MemberAPI().getMemberType(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  //GROUPING - GROUP
  var selectedGroup;
  var selectedGroupID;
  late List<AbstractGroup>? groupList = [];
  void _getGroupList ({required var branchID,var token})async{
    groupList = (await MemberAPI().getGroup(branchID: branchID, token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  //GROUPING - SUB GROUP
  var selectedSubGroup;
  var selectedSubGroupID;
  late List<AbstractSubGroup>? subGroupList = [];
  void _getSubGroupList ({required var branchID, var token})async{
    subGroupList = (await MemberAPI().getSubGroup(branchID: branchID, token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  var token;
  void _getToken ({required var clientID})async{
    token = (await MemberAPI().getToken(clientID: clientID));
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    _getBranchList(token: token);
    _getCategoryList(token: token);
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
    _getToken(clientID: widget.clientID);

    pageViewController.addListener(() {
      if (pageViewController.page?.round() != currentIndex) {
        setState(() {
          currentIndex = pageViewController.page!.round();
        });
      }
    });
  }

  void selectProfilePhoto() async {
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (getImage != null) {
        imageFile = File(getImage.path);
      }
    });
  }

  void selectProfileCV() async {
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (getImage != null) {
        imageCV = File(getImage.path);
      }
    });
  }

  void selectProfileIDCard() async {
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (getImage != null) {
        imageIDCard = File(getImage.path);
      }
    });
  }

  nextButtonTapped({required pageId}) {

    switch (pageId) {
      case 0:
        //currently on bio data page,
        //check these inputs -> gender and dob
        if (!formGlobalKeyBio.currentState!.validate()) {
          return;
        }
        if (selectedGender == null) {
          showErrorSnackBar(context, "select your gender");
          return;
        }
        if (birthDate == null) {
          showErrorSnackBar(context, "select date of birth");
          return;
        }

        pageViewController.animateToPage(1,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
      case 1:
        //currenty on grouping page
        if (selectedBranchID == null) {
          showErrorSnackBar(context, "select date of Branch");
          return;
        }
        if (selectedCategoryID == null) {
          showErrorSnackBar(context, "select your Category");
          return;
        }
        pageViewController.animateToPage(2,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
      case 2:
        if (selectedCountryID == null) {
            showErrorSnackBar(context, "select your Country");
            return;
        }
        if (!formGlobalKeyStateProvince.currentState!.validate()) {
          return;
        }
        if(ifGhanaSelected){
          if (selectedRegionID == null) {
            showErrorSnackBar(context, "select your Region");
            return;
          }
          if (selectedDistrictID == null) {
            showErrorSnackBar(context, "select your District");
            return;
          }
          if (selectedConstituencyID == null) {
            showErrorSnackBar(context, "select your Constituency");
            return;
          }

          if (selectedCommunityID == null) {
            showErrorSnackBar(context, "select your Community");
            return;
          }
        }else{
          if (!formGlobalKeyStateProvince.currentState!.validate()) {
            return;
          }
        }
        pageViewController.animateToPage(3,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
      case 3:
        if (selectedMaritalID == null) {
          showErrorSnackBar(context, "select your Marital Status");
          return;
        }

        if (selectedEducationID == null) {
          showErrorSnackBar(context, "select your Education");
          return;
        }
        if (selectedOccupationID == null) {
          showErrorSnackBar(context, "select your Occupation");
          return;
        }

        if (selectedProfessionID == null) {
          showErrorSnackBar(context, "select your Profession");
          return;
        }

        // if (!formGlobalKeyStatus.currentState!.validate()) {
        //   return;
        // }
        //
        // if(imageIDCard == null){
        //   showErrorSnackBar(context, "Upload your ID Card");
        //   return;
        // }
        // if(imageCV == null){
        //   showErrorSnackBar(context, "Upload your CV");
        //   return;
        // }
        pageViewController.animateToPage(4,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: currentIndex == 0 ? true : false,
        title: const Text("Individual Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            size.height >= 800? Container(
              child:Column(
                children: [
                  Container(
                    child: widget.clientLogo != null
                        ? Align(
                      child: CustomCachedImageWidget(
                        url: widget.clientLogo,
                        height: 100,
                      ),
                    )
                        : defaultProfilePic(height: 100),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.clientName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                ],
              )
            ): Container(),
            Text(
              currentIndex == 0
                  ? "Bio Data"
                  : currentIndex == 1
                      ? "Grouping"
                      : currentIndex == 2
                          ? "Location"
                          : currentIndex == 3
                              ? "Statuses"
                              : "",
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 12,
            ),
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
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentIndex == 0
                      ? Container()
                      : CupertinoButton(
                          child: Row(
                            children: const [
                              Icon(CupertinoIcons.arrow_left),
                              Text("Previous"),
                            ],
                          ),
                          onPressed: () {
                            pageViewController.animateToPage(currentIndex - 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                            // nextButtonTapped(pageId: pageViewController.page);
                          }),
                  const SizedBox(
                    width: 12,
                  ),
                  currentIndex == 4
                      ? Container()
                      : CupertinoButton(
                          child: Row(
                            children: const [
                              Text("Next"),
                              Icon(CupertinoIcons.arrow_right),
                            ],
                          ),
                          onPressed: () {
                            nextButtonTapped(pageId: pageViewController.page);
                          })
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WebViewPage(
                              url:
                              'https://akwaabasolutions.com/terms-and-conditions-2/',
                              title: 'Terms & Conditions'),
                        ),
                      );
                    },
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(color: Colors.black,),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bioDataView() {
    // _controllerWhatsappContact.text = '';
    return Form(
      key: formGlobalKeyBio,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(
              label: "First Name",
              setCompulsory: true,
              child: FormTextField(
                controller: _controllerFirstName,
                label: "",
              )),
          LabelWidgetContainer(
              label: "Middle Name",
              child: FormTextField(
                controller: _controllerMiddleName,
                label: "",
                applyValidation: false,
              )),
          LabelWidgetContainer(
            label: "Surname",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerSurname,
              label: "",
            ),
          ),
          LabelWidgetContainer(
              label: "Gender",
              setCompulsory: true,
              child: FormButton(
                label: selectedGender ?? "Select Gender",
                function: () {
                  selectGender();
                },
              )),
          LabelWidgetContainer(
              label: "Date of Birth",
              setCompulsory: true,
              child: FormButton(
                label: birthDate != null
                    ? DateFormat("dd MMM yyyy").format(birthDate!)
                    : "Select Date",
                function: () {
                  selectDateOfBirth();
                },
              )),
          LabelWidgetContainer(
            label: "Phone",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerPhone,
              label: "",
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.phone,
              maxLength: 10,
            ),
          ),
          LabelWidgetContainer(
            label: "Email Address",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerEmail,
              label: "",
              textInputType: TextInputType.emailAddress,
            ),
          ),
          LabelWidgetContainer(
              label: "Whatsapp Contact",
              setCompulsory: false,
              child: FormTextField(
                controller: _controllerWhatsappContact,
                textInputType: TextInputType.phone,
                maxLength: 10,
              )),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  imageFile!,
                  height: 120,
                  width: 120,
                ),
              )
                  : defaultProfilePic(height: 120),
              CupertinoButton(
                  onPressed: () {
                    print('IMAGE FILE----- ${imageFile?.path}');
                    selectProfilePhoto();
                  },
                  child:
                  Text(imageFile != null ? "Change Photo" : "Select Photo"))
            ],
          ),
        ],
      ),
    );
  }

  bool loadingGroup = false;
  Widget groupingView() {
    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            LabelWidgetContainer(
                label: "Branch",
                setCompulsory: true,
                child: FormButton(
                  label: selectedBranch??"Select Branch",
                  function: (){
                    var newBranchList = branchList?.map((value)=> {'name':value.name, 'id':value.id}).toList();
                    selectBranch(newBranchList);
                  },
                )
            ),

            LabelWidgetContainer(label: "Category",
                setCompulsory: true,
                child: FormButton(
                  label:  selectedCategory??"Select Category",
                  function: (){
                    var newCategoryList = categoryList?.map((value)=> {'name':value.category, 'id':value.id}).toList();
                    selectCategory(newCategoryList);
                  },
                )
            ),

            LabelWidgetContainer(label: "Group",
                child: FormButton(
                  label: selectedGroup??"Select Group",
                  function: (){
                    var newGroupList = groupList?.map((value)=> {'name':value.group, 'id':value.id}).toList();
                    selectGroup(newGroupList);
                  },
                )
            ),

            LabelWidgetContainer(label: "Sub Group",
                child: FormButton(
                  label: selectedSubGroup??"Select Sub Group",
                  function: (){
                    var newSubgroupList = subGroupList?.map((value)=> {'name':value.subgroup, 'id':value.id}).toList();
                    selectSubGroup(newSubgroupList);
                  },
                )
            )
          ],
        ),
        loadingGroup? const Align(
          child: CircularProgressIndicator(),
        ): Container(),
      ]
    );
  }


  bool loadingLocation = false;
  bool ifGhanaSelected = false;
  Widget locationView() {
    return Stack(
      children: [
        ListView(
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

            !ifGhanaSelected?Form(
            key: formGlobalKeyStateProvince,
            child:  Column(
              children: [
                LabelWidgetContainer(
                    label: "Province/State",
                    setCompulsory: true,
                    child: FormTextField(
                      controller: _controllerStateProvince,
                      label: "Enter Province/State",
                    )),
                LabelWidgetContainer(
                    label: "Community",
                    setCompulsory: true,
                    child: FormTextField(
                      controller: _controllerCommunity,
                      label: "Enter Community",
                    )),
              ],
            ),
          ):Container(),

            ifGhanaSelected?LabelWidgetContainer(
              setCompulsory: true,
                label: "Region",
                child: FormButton(
                  label: selectedRegion??"Select Region",
                  function: (){
                    var newRegionList = regionList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                    selectRegion(newRegionList);
                  },
                )
            ):Container(),

            ifGhanaSelected?LabelWidgetContainer(
              // setCompulsory: true,
                label: "District",
                child: FormButton(
                  label: selectedDistrict??"Select District",
                  function: (){
                    var newDistrictList = districtList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                    selectDistrict(newDistrictList);
                  },
                )
            ):Container(),

            ifGhanaSelected?LabelWidgetContainer(
              //setCompulsory: true,
                label: "Constituency",
                child: FormButton(
                  label: selectedConstituency??"Select Constituency",
                  function: (){
                    var newConstituencyList = constituencyList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                    selectConstituency(newConstituencyList);
                  },
                )
            ):Container(),

            ifGhanaSelected?LabelWidgetContainer(
                label: "Electoral Area",
                child: FormButton(
                  label: selectedCommunity??"Select Electoral Area",
                  function: (){
                    var newCommunityList = communityList?.map((value)=> {'name':value.location, 'id':value.id}).toList();
                    selectCommunity(newCommunityList);
                  },
                )
            ):Container(),
            ifGhanaSelected?Form(
              key: formGlobalKeyStateProvince,
              child:  LabelWidgetContainer(
                  label: "Community",
                  setCompulsory: true,
                  child: FormTextField(
                    controller: _controllerCommunity,
                    label: "Enter Community",
                  )),
            ):Container(),
          ],
        ),
        loadingLocation? const Align(
          child: CircularProgressIndicator(),
        ): Container(),
      ]
    );
  }

  Widget statusView() {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            const Expanded(child: Text("Do you have a disability?")),
            Row(
              children: List.generate(2, (index) {
                return Row(
                  children: [
                    Radio(
                        activeColor: primaryColor,
                        value: index,
                        groupValue: disabilityOption,
                        onChanged: (int? value) {
                          setState(() {
                            disabilityOption = value!;
                          });
                        }),
                    Text(index == 0 ? "Yes" : "No")
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

        Form(
          key: formGlobalKeyStatus,
          child:  LabelWidgetContainer(label: "Reference Number",
              setCompulsory: false,
              child:FormTextField(
                controller: _controllerIDNumber,
              )
          ),
        ),



        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageIDCard != null
                ? Container(
              width: size.width*0.93,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Expanded(
                child: IconButton(
                    onPressed: (){},
                    icon: Row(
                        children:const[
                          Text('National ID Card selected', style: TextStyle(color:Colors.green),),
                          SizedBox(width:10),
                          Icon(Icons.check_circle_outlined, color: Colors.green,)
                        ]
                    )
                ),
              ),
            )
                : const Text('No File selected'),
            CupertinoButton(
              onPressed: () {
                print('IMAGE NAME----- ${imageIDCard?.absolute}');
                selectProfileIDCard();
              },
              child:
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:Colors.orange,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(imageIDCard != null ? "Change ID Card" : "Attach Your National ID Card", style: const TextStyle(color:Colors.black),)),
            )
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageCV != null
                ? Container(
              width: size.width*0.93,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
              ),
              child: Expanded(
                child: IconButton(
                  onPressed: (){},
                  icon: Row(
                    children:const[
                       Text('CV selected', style: TextStyle(color:Colors.green),),
                      SizedBox(width:10),
                      Icon(Icons.check_circle_outlined, color: Colors.green,)
                    ]
                  )
                ),
              ),
            )
                : const Text('No File selected'),
            CupertinoButton(
                onPressed: () {
                  print('IMAGE NAME----- ${imageCV?.absolute}');
                  selectProfileCV();
                },
                child:
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:Colors.orange,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                  child: Text(imageCV != null ? "Change CV" : "Attach Your CV", style: const TextStyle(color:Colors.black),)),
                  )
          ],
        ),

        const SizedBox(
          height: 12,
        ),

      ],
    );
  }

  Widget passwordsView() {
    return Form(
        key: formGlobalKeyPassword,
        child:ListView(
        physics: const BouncingScrollPhysics(),
      children: [
        LabelWidgetContainer(
            label: "Password",
            child: FormTextField(
              controller: _controllerPassword,
            )),
        LabelWidgetContainer(
            label: "Confirm Password",
            child: FormTextField(
              controller: _controllerConfirmPassword,
            )),
        const SizedBox(
          height: 26,
        ),

        const SizedBox(height: 26,),

        CustomElevatedButton(label: "Submit",
            function: (){
    debugPrint('firstname ${_controllerFirstName.text}, '

    'selectedBranch $selectedBranch,'
    'selectedCategory $selectedCategory,'
    'selectedGroup $selectedGroup'
    'selectedSubGroup $selectedSubGroup'
    ''
    'selectedCountry $selectedCountry'
    'selectedRegion $selectedRegion'
    'selectedDistrict $selectedDistrict'
    'selectedConstituency $selectedConstituency'
    'selectedCommunity $selectedCommunity'
    ''
    'selectedMarital $selectedMarital'
    'selectedEducation $selectedEducation '
    'selectedOccupation $selectedOccupation '
    'selectedProfession $selectedProfession,'
    'branch $selectedBranchID'
    'widget.clientID ${widget.clientID}'

    '');
    final DateTime? now = birthDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final DateFormat formattedr = formatter.format(new DateTime. )
    String? formatted;
    if(birthDate!=null){
      setState((){
        formatted = formatter.format(now!);
      });

    }
    print(formatted);
      var password = _controllerPassword.text.trim();
      var repeat_password = _controllerConfirmPassword.text.trim();
        if (!formGlobalKeyPassword.currentState!.validate()) {
          return;
        }else if(password != repeat_password){
          showErrorSnackBar(context, 'Passwords must be the same');
        }else if(password.length < 7){
          showErrorSnackBar(context, 'Passwords must contain at least 8 characters');
        }else if(!password.contains(new RegExp(r'[0-9]'))){
          showErrorSnackBar(context, 'This password is too common, add special symbols eg.!@#');
        }else{
          setState(() {
            loading = true;
          });
          print(' value');
          debugPrint('ProfileImage => ${imageFile?.path}'
              ' profileResume:> ${imageCV?.path}'
              ' profileIdentification:> ${imageIDCard?.path};');

            MemberAPI.registerMemberWithImage(
                context,
                profilePicture:imageFile?.path,
                profileResume:imageCV?.path,
                profileIdentification:imageIDCard?.path,
                clientId: '${widget.clientID}',
                branchId:'${selectedBranchID}',
                firstname:_controllerFirstName.text.trim(),
                middlename: _controllerMiddleName.text.trim(),
                surname:_controllerSurname.text,
                gender: selectedGender == 'Male' ? 1:0 ,
                dateOfBirth: formatted,
                email: _controllerEmail.text,
                phone: _controllerPhone.text,
                memberType: selectedCategoryID,
                referenceId: _controllerIDNumber.text,
                nationality: selectedCountryID,
                countryOfResidence: selectedCountryID,
                stateProvince: _controllerStateProvince.text.trim(),
                region: selectedRegionID,
                district: selectedDistrictID,
                constituency: selectedConstituencyID,
                electoralArea: selectedCommunityID,
                community: '$selectedCommunityID',
                digitalAddress: '-',
                hometown: '-',
                occupation: selectedOccupationID,
                disability: disabilityOption == 0? false: true,
                maritalStatus: selectedMaritalID,
                occupationalStatus: selectedOccupationID,
                professionStatus: selectedProfessionID,
                educationalStatus: selectedEducationID,
                groupIds: [selectedGroupID],
                subgroupIds: [selectedSubGroupID],
                password: _controllerPassword.text.trim(),
                confirm_password: _controllerConfirmPassword.text.trim()
            ).then((value){
              setState(() {
                loading = false;
              });
              if(value == 'non_field_errors'){
                showErrorToast("Please fill all required fields");

              }else if(value == 'successful'){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute( builder: (_) =>  const LoginPage(),));
              }
            });

        }
        }),

        const SizedBox(height: 26,),
        loading?const Align(
          child: CircularProgressIndicator(),
        ): Container()
      ],
        ));
  }

  registerUser() {
    FocusManager.instance.primaryFocus?.unfocus(); //hide keyboard
    //check inputs
  }

  selectGender() {
    displayCustomDropDown(
            options: genders, context: context, listItemsIsMap: false)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedGender = value;
        });
      }
    });
  }

  selectDepartment() {
    displayCustomDropDown(
            options: departments, context: context, listItemsIsMap: false)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedDepartment = value;
        });
      }
    });
  }

  selectDateJoined() {
    displayDateSelector(
            initialDate: dateJoined ?? DateTime.now(), context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          dateJoined = value;
        });
      }
    });
  }

  selectDateOfBirth() {
    displayDateSelector(
            initialDate: birthDate ?? DateTime.now(), context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          birthDate = value;
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
          ifGhanaSelected = selectedCountry.toString() =='Ghana'? true: false;
          debugPrint('ifGhanaSelected $ifGhanaSelected;');
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
          loadingLocation = true;
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
          debugPrint('selectedDistrictID $selectedDistrict, $selectedDistrictID');
          _getConstituencyList(regionID:selectedRegionID, districtID:selectedDistrictID );
          _getCommunityList(regionID:selectedRegionID, districtID:selectedDistrictID );
          loadingLocation = false;
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
          selectedMarital = value['name'];
          selectedMaritalID =  value['id'];
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

//  GROUPINGS
  selectBranch(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedBranch = value['name'];
          selectedBranchID =  value['id'];
          debugPrint('selectedBranchdf $selectedBranchID, $selectedBranch');
          _getSubGroupList(token:token, branchID: selectedBranchID);
          _getGroupList(token:token, branchID: selectedBranchID);
          loadingGroup = true;
        });
      }
    });
  }

  selectCategory(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedCategory = value['name'];
          selectedCategoryID =  value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectGroup(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedGroup = value['name'];
          selectedGroupID =  value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectSubGroup(options){
    displayCustomDropDown(options: options, context: context,listItemsIsMap: true).then((value) {
      if(value!=null){
        setState(() {
          selectedSubGroup = value['name'];
          selectedSubGroupID =  value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

}
