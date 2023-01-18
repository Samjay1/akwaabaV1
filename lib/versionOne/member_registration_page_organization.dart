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
import 'package:intl/intl.dart';

import '../Networks/member_api.dart';
import '../components/custom_cached_image_widget.dart';
import '../models/general/OrganisationType.dart';
import '../models/general/abstractGroup.dart';
import '../models/general/abstractSubGroup.dart';
import '../models/general/branch.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/district.dart';
import '../models/general/electoralArea.dart';
import '../models/general/memberType.dart';
import '../models/general/region.dart';
import '../utils/widget_utils.dart';
import 'login_page.dart';

class MemberRegistrationPageOrganization extends StatefulWidget {
  final clientID;
  final clientName;
  final clientLogo;
  const MemberRegistrationPageOrganization({required this.clientID,this.clientName,this.clientLogo, Key? key}) : super(key: key);

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

  final TextEditingController _controllerStateProvince =
  TextEditingController();
  final TextEditingController _controllerCommunity = TextEditingController();



  final formGlobalKeyStateProvince = GlobalKey < FormState > ();
  final formGlobalKeyContactPerson = GlobalKey < FormState > ();
  final formGlobalKey = GlobalKey < FormState > ();

  DateTime? orgDate;

  bool confirmPasswordVisible=true;
  bool passwordVisible=true;
  final PageController pageViewController= PageController();
  int currentIndex = 0;
  final ImagePicker picker = ImagePicker();
  File? imageFile ;
  File? imageRegCert ;

  int organizationLegalRegistration=-1;


  bool loading = false;
  bool loadingGroup = false;
  bool loadingLocation = false;
  bool ifGhanaSelected = false;


  //--------------------------------------------------------------------------
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
  late List<OrganisationType>? categoryList = [];
  void _getCategoryList ({required var token})async{
    categoryList = (await MemberAPI().getOrganisationType(token: token));
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

  //--------------------------------------------------------------------------

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
    _getToken(clientID: widget.clientID);

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
  void selectRegCert() async{
    final getImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(getImage!=null){
        imageRegCert = File(getImage.path);
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
    debugPrint('CATEGORY');
    // debugPrint('CATEGORY $categoryList');
    Size size = MediaQuery.of(context).size;
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
    Size size = MediaQuery.of(context).size;
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
                    label: orgDate != null
                        ? DateFormat("dd MMM yyyy").format(orgDate!)
                        : "Select Date",
                    function: (){
                      selectOrgDate();
                    },
                  )
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageRegCert != null
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
                                    Text('Registration Certificate selected', style: TextStyle(color:Colors.green),),
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
                          print('IMAGE NAME----- ${imageRegCert?.absolute}');
                          selectRegCert();
                        },
                        child:
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:Colors.orange,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(imageRegCert != null ? "Change Registration Certificate" : "Upload Registration Certificate", style: const TextStyle(color:Colors.black),)),
                      )
                    ],
                  ),
                ],
              ):SizedBox.shrink(),


          LabelWidgetContainer(label: "Organization Type/Description",
              setCompulsory: true,
              child: FormButton(
                label:  selectedCategory??"Select Organization Type/Description",
                function: (){
                  var newCategoryList = categoryList?.map((value)=> {'name':value.type, 'id':value.id}).toList();
                  selectCategory(newCategoryList);
                },
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
                      var newCategoryList = categoryList?.map((value)=> {'name':value.type, 'id':value.id}).toList();
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

  Widget locationInfoView(){
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
            ],
          ),
          loadingLocation? const Align(
            child: CircularProgressIndicator(),
          ): Container(),
        ]
    );
  }

  Widget contactInfoInfoView(){
    return Form(
      key: formGlobalKeyContactPerson,
      child: ListView(
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

          CustomElevatedButton(label: "Submit", function: (){

            debugPrint(''
                ' logo $imageFile'
                ' orgDate $orgDate'
                ' imageRegCert $imageRegCert'
                '_controllerOrgName ${_controllerOrgName.text}'
                ' _controllerPhone ${_controllerPhone.text}'
                ' _controllerWebsite ${_controllerWebsite.text}'
                ' _controllerPostalAddress ${_controllerPostalAddress.text}'
                ' _controllerCoreAreas ${_controllerCoreAreas.text}'
                'selectedBranch $selectedBranch,'
                ' selectedCategory $selectedCategory,'
                ' selectedGroup $selectedGroup'
                ' selectedSubGroup $selectedSubGroup'
                ''
                ' selectedCountry $selectedCountry'
                ' selectedRegion $selectedRegion'
                ' selectedDistrict $selectedDistrict'
                ' selectedConstituency $selectedConstituency'
                ' selectedCommunity $selectedCommunity'
                ' selectedStateProvince ${_controllerStateProvince.text}'
                '_controllerConfirmPassword ${_controllerConfirmPassword.text}'
                ' _controllerPassword ${_controllerPassword.text}'
                ' _controllerContactWhatsapp ${_controllerContactWhatsapp.text}'
                ' _controllerContactPhone ${_controllerContactPhone.text}'
                ' _controllerContactEmail ${_controllerContactEmail.text}'
                ' _controllerContactName ${_controllerContactName.text}'
                ' community $selectedCommunity');


                var password = _controllerPassword.text.trim();
                var repeat_password = _controllerConfirmPassword.text.trim();
                if (!formGlobalKeyContactPerson.currentState!.validate()) {
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

                //   MemberAPI.registerOrg(context,
                //       clientId: '${widget.clientID}',
                //       branchId:'${selectedBranchID}',
                //       organizationName: _controllerOrgName.text,
                //       contactPersonName: _controllerContactName.text,
                //       // contactPersonGender: selectedGender == 'Male' ? 1:0 ,
                //       organizationType: selectedCategory,
                //       // businessRegistered: businessRegistered == 0? false: true,
                //       organizationEmail: _controllerEmail.text,
                //       organizationPhone: _controllerPhone.text,
                //       contactPersonEmail:_controllerContactEmail.text ,
                //       contactPersonPhone: _controllerContactPhone.text,
                //       contactPersonWhatsapp: _controllerContactWhatsapp.text,
                //       // occupation,
                //       memberType: selectedCategoryID,
                //       // referenceId: _controllerIDNumber.text,
                //       countryOfBusiness: selectedCountryID,
                //       stateProvince: _controllerStateProvince.text.trim(),
                //       region: selectedRegionID,
                //       district: selectedDistrictID,
                //       constituency: selectedConstituencyID,
                //       electoralArea: selectedCommunityID,
                //       community: '$selectedCommunityID',
                //
                //       // digitalAddress,
                //       // password,
                //       // confirm_password,
                //       // groupIds,
                //       // subgroupIds,
                //       // website,
                //       // businessDescription,
                //       // logo,
                //       // certificates
                //   )
                // .then((value) {
                //     setState(() {
                //       loading = false;
                //     });
                //     if (value == 'non_field_errors') {
                //       showErrorToast("Please fill all required fields");
                //     } else if (value == 'successful') {
                //       // Navigator.pop(context);
                //       Navigator.push(context, MaterialPageRoute( builder: (_) =>  const LoginPage(),));
                //       }
                //       });
                    }



          })
        ],
      ),
    );
  }



  selectOrgDate() {
    displayDateSelector(
        initialDate: orgDate ?? DateTime.now(), context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          orgDate = value;
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

}