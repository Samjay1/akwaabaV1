import 'dart:io';

import 'package:akwaaba/components/custom_dropdown_multiselect.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/email_form_textfield.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Networks/member_api.dart';
import '../components/custom_cached_image_widget.dart';
import '../components/phone_form_textfield.dart';
import '../models/general/OrganisationType.dart';
import '../models/general/branch.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/district.dart';
import '../models/general/electoralArea.dart';
import '../models/general/memberType.dart';
import '../models/general/region.dart';
import '../utils/widget_utils.dart';
import 'login_page.dart';
import 'package:validators/validators.dart';

class MemberRegistrationPageOrganization extends StatefulWidget {
  final clientID;
  final clientName;
  final clientLogo;
  const MemberRegistrationPageOrganization(
      {required this.clientID, this.clientName, this.clientLogo, Key? key})
      : super(key: key);

  @override
  State<MemberRegistrationPageOrganization> createState() =>
      _MemberRegistrationPageOrganizationState();
}

class _MemberRegistrationPageOrganizationState
    extends State<MemberRegistrationPageOrganization> {
  final TextEditingController _controllerOrgName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerWebsite = TextEditingController();
  final TextEditingController _controllerCoreAreas = TextEditingController();
  final TextEditingController _controllerPostalAddress =
      TextEditingController();

  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerContactPhone = TextEditingController();
  final TextEditingController _controllerContactEmail = TextEditingController();
  final TextEditingController _controllerContactWhatsapp =
      TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  final TextEditingController _controllerStateProvince =
      TextEditingController();
  final TextEditingController _controllerCommunity = TextEditingController();

  final formGlobalKeyStateProvince = GlobalKey<FormState>();
  final formGlobalKeyContactPerson = GlobalKey<FormState>();
  final formGlobalKey = GlobalKey<FormState>();

  DateTime? orgDate;

  bool confirmPasswordVisible = true;
  bool passwordVisible = true;
  final PageController pageViewController = PageController();
  int currentIndex = 0;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  List<File> imageRegCert = [];

  int organizationLegalRegistration = -1;

  bool loading = false;
  bool loadingGroup = false;
  bool loadingLocation = false;
  bool ifGhanaSelected = false;

  String? selectedGender;

  //--------------------------------------------------------------------------
  // GROUPING - BRANCH
  var selectedBranch;
  var selectedBranchID;
  late List<Branch>? branchList = [];
  void _getBranchList({required var token}) async {
    branchList = (await MemberAPI().getBranches(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  // GROUPING - CATEGORY
  var selectedCategory;
  var selectedCategoryID;
  late List<MemberType>? categoryList = [];
  void _getCategoryList({required var token}) async {
    categoryList = (await MemberAPI().getMemberType(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  // GROUPING - ORGANIZATION TYPE
  var selectedOrgType;
  var selectedOrgTypeID;
  late List<OrganisationType>? orgTypeList = [];
  void _getOrganisationTypeList({required var token}) async {
    orgTypeList = (await MemberAPI().getOrganisationType(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  //GROUPING - GROUP
  var selectedGroup;
  var selectedGroupID;

  late List<String>? selectedGroupList = [];
  late String selectedGroupOption;
  late List<Group>? groupList = [];
  void _getGroupList({required var branchID, var token}) async {
    groupList = await MemberAPI().getGroup(branchID: branchID);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  // get IDs of selected groups
  List<int> selectedGroupIds() {
    List<int> ids = [];
    for (var group in groupList!) {
      if (selectedGroupList!.contains(group.group)) {
        ids.add(group.id!);
      }
    }
    debugPrint("SelectedGroupIds ${ids.toString()}");
    return ids;
  }

  //GROUPING - SUB GROUP
  var selectedSubGroup;
  var selectedSubGroupID;
  late List<String>? selectedSubGroupList = [];
  late String selectedSubGroupOption = '';
  late List<SubGroup>? subGroupList = [];
  void _getSubGroupList({required var branchID, var token}) async {
    subGroupList = (await MemberAPI().getSubGroup(branchID: branchID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  // get IDs of selected subgroups
  List<int> selectedSubGroupIds() {
    List<int> ids = [];
    for (var subGroup in subGroupList!) {
      if (selectedSubGroupList!
          .contains('${subGroup.groupId!.group} => ${subGroup.subgroup}')) {
        ids.add(subGroup.id!);
      }
    }
    debugPrint("SelectedSubGroupIds ${ids.toString()}");
    return ids;
  }

  //LOCATION - COUNTRY
  var selectedCountry;
  var selectedCountryID;
  late List<Country>? countryList = [];
  void _getCountryList() async {
    countryList = (await MemberAPI().getCountry());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //LOCATION - REGION
  var selectedRegion;
  var selectedRegionID;
  late List<Region>? regionList = [];
  void _getRegionList() async {
    regionList = (await MemberAPI().getRegion());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //LOCATION - DISTRICT
  var selectedDistrict;
  var selectedDistrictID;
  late List<District>? districtList = [];
  void _getDistrictList({var regionID}) async {
    districtList = (await MemberAPI().getDistrict(regionID: regionID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //LOCATION - CONSTITUENCY
  var selectedConstituency;
  var selectedConstituencyID;
  late List<Constituency>? constituencyList = [];
  void _getConstituencyList({var regionID, var districtID}) async {
    constituencyList = (await MemberAPI()
        .getConstituency(regionID: regionID, districtID: districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //LOCATION - COMMUNITY
  var selectedElectoral;
  var selectedElectoralID;
  late List<ElectoralArea>? communityList = [];
  void _getElectoralArea({var regionID, var districtID}) async {
    communityList = (await MemberAPI()
        .getElectoralArea(regionID: regionID, districtID: districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //--------------------------------------------------------------------------

  var token;
  void _getToken({required var clientID}) async {
    token = (await MemberAPI().getToken(clientID: clientID));
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    _getBranchList(token: token);
    _getOrganisationTypeList(token: token);
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

  void selectLogo() async {
    final getImage = await picker.pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      setState(() {
        imageFile = File(getImage.path);
      });
    }
  }

  void selectRegCert() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['png', 'jpg', 'doc', 'docx', 'pdf'],
      type: FileType.custom,
    );
    if (result != null) {
      setState(() {
        imageRegCert = result.paths.map((path) => File(path!)).toList();
        //imageRegCert = File(result.files.single.path!);
      });
    }
  }

  nextButtonTapped({required double pageId}) {
    switch (pageId.toInt()) {
      case 0:
        if (!formGlobalKey.currentState!.validate()) {
          return;
        }
        if (organizationLegalRegistration == 0) {
          if (orgDate == null) {
            showErrorSnackBar(context, "Select Date");
            return;
          }
          if (imageRegCert.isEmpty) {
            showErrorSnackBar(context, "Upload Registration certificate");
            return;
          }
        }
        // if (!isURL(_controllerWebsite.text)) {
        //   showErrorSnackBar(context, "Enter a valid website url");
        //   return;
        // }
        //currently on bio data page,
        //check these inputs -> first name, last name, DOB, gender, email, phone
        pageViewController.animateToPage(
          1,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
        break;
      case 1:
        //currenty on
        if (selectedBranchID == null) {
          showErrorSnackBar(context, "Select your Branch");
          return;
        }
        if (selectedCategoryID == null) {
          showErrorSnackBar(context, "Select your Category");
          return;
        }
        pageViewController.animateToPage(2,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
      case 2:
        if (selectedCountryID == null) {
          showErrorSnackBar(context, "Select your Country");
          return;
        }
        if (!formGlobalKeyStateProvince.currentState!.validate()) {
          return;
        }
        if (ifGhanaSelected) {
          if (selectedRegionID == null) {
            showErrorSnackBar(context, "Select your Region");
            return;
          }
          if (selectedDistrictID == null) {
            showErrorSnackBar(context, "Select your District");
            return;
          }
          if (selectedConstituencyID == null) {
            showErrorSnackBar(context, "Select your Constituency");
            return;
          }

          if (_controllerCommunity.text.isEmpty) {
            showErrorSnackBar(context, "Enter your community name");
            return;
          }
        } else {
          if (!formGlobalKeyStateProvince.currentState!.validate()) {
            return;
          }
        }
        pageViewController.animateToPage(3,
            duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
      case 3:
        if (!formGlobalKeyContactPerson.currentState!.validate()) {
          return;
        }
        if (selectedGender == null) {
          showErrorSnackBar(context, "select your Gender");
          return;
        }

        // pageViewController.animateToPage(4,
        //     duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
    }

    // pageViewController.nextPage(
    //   duration: const Duration(milliseconds: 100),
    //   curve: Curves.easeIn,
    // );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('CATEGORY');
    // debugPrint('CATEGORY $categoryList');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: currentIndex == 0 ? true : false,
        title: const Text("Organization Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Column(
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
              ),
            ),
            Text(
              currentIndex == 0
                  ? "Organizational Info "
                  : currentIndex == 1
                      ? "Grouping"
                      : currentIndex == 2
                          ? "Location"
                          : currentIndex == 3
                              ? "Contact Person"
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
                  organizationalInfoView(),
                  groupingInfoView(),
                  locationInfoView(),
                  contactInfoInfoView(),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 0, color: Colors.grey))),
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
                              SizedBox(
                                width: 8,
                              ),
                              Text("Previous"),
                            ],
                          ),
                          onPressed: () {
                            pageViewController.animateToPage(
                              currentIndex - 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          }),
                  const SizedBox(
                    width: 12,
                  ),
                  currentIndex == 3
                      ? Container()
                      : CupertinoButton(
                          child: Row(
                            children: const [
                              Text("Next"),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(CupertinoIcons.arrow_right),
                            ],
                          ),
                          onPressed: () {
                            nextButtonTapped(pageId: pageViewController.page!);
                          })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget organizationalInfoView() {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: formGlobalKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            LabelWidgetContainer(
                setCompulsory: true,
                label: "Name of Organization",
                child: FormTextField(
                  controller: _controllerOrgName,
                  label: "",
                  applyValidation: true,
                )),
            Container(
              decoration: BoxDecoration(
                  // border: Border.all(color: textColorLight),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 220,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: imageFile != null
                            ? Image.file(imageFile!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover)
                            : Image.asset(
                                "images/img.png",
                                height: 90,
                                width: 100,
                                fit: BoxFit.cover,
                              )),
                  ),
                  CupertinoButton(
                      child: Text(
                          imageFile != null ? "Change Logo" : "Upload Logo"),
                      onPressed: () {
                        selectLogo();
                      })
                ],
              ),
            ),
            LabelWidgetContainer(
                label: "Is the organization legally registered?",
                setCompulsory: true,
                child: Row(
                  children: List.generate(2, (index) {
                    return Row(
                      children: [
                        Radio(
                            activeColor: primaryColor,
                            value: index,
                            groupValue: organizationLegalRegistration,
                            onChanged: (int? value) {
                              setState(() {
                                organizationLegalRegistration = value!;
                              });
                            }),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(index == 0 ? "Yes" : "No")
                      ],
                    );
                  }),
                )),
            const SizedBox(
              height: 8,
            ),
            organizationLegalRegistration == 0
                ? Column(
                    children: [
                      LabelWidgetContainer(
                          label: "Date of Registration",
                          child: FormButton(
                            label: orgDate != null
                                ? DateFormat("dd MMM yyyy").format(orgDate!)
                                : "Select Date",
                            function: () {
                              selectOrgDate();
                            },
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageRegCert.isNotEmpty
                              ? Container(
                                  width: size.width * 0.93,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                      onPressed: () => selectRegCert(),
                                      icon: Row(children: const [
                                        Text(
                                          'Registration Certificate selected',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.check_circle_outlined,
                                          color: Colors.green,
                                        )
                                      ])),
                                )
                              : const Text('No File selected'),
                          CupertinoButton(
                            onPressed: () {
                              debugPrint(
                                  'IMAGE NAME----- ${imageRegCert.map((e) => e.path).toList()}');
                              selectRegCert();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  imageRegCert.isNotEmpty
                                      ? "Change Registration Certificate"
                                      : "Upload Registration Certificate",
                                  style: const TextStyle(color: Colors.black),
                                )),
                          )
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            LabelWidgetContainer(
                label: "Organization Type/Description",
                setCompulsory: true,
                child: FormButton(
                  label:
                      selectedOrgType ?? "Select Organization Type/Description",
                  function: () {
                    var newOrgTypeList = orgTypeList
                        ?.map((value) => {'type': value.type, 'id': value.id})
                        .toList();
                    selectOrgType(newOrgTypeList);
                  },
                )),
            LabelWidgetContainer(
                setCompulsory: true,
                label: "Email",
                child: EmailFormTextField(
                  controller: _controllerEmail,
                  textInputType: TextInputType.emailAddress,
                  applyValidation: true,
                )),
            LabelWidgetContainer(
                label: "Phone",
                setCompulsory: true,
                child: PhoneFormTextField(
                  controller: _controllerPhone,
                  textInputType: TextInputType.phone,
                  maxLength: 10,
                )),
            LabelWidgetContainer(
                label: "Website",
                setCompulsory: false,
                child: FormTextField(
                  controller: _controllerWebsite,
                  textInputType: TextInputType.url,
                  applyValidation: false,
                  hint: "https://mywebsiteurl.com",
                )),
            LabelWidgetContainer(
                label: "Postal Address",
                child: FormTextField(
                  controller: _controllerPostalAddress,
                  applyValidation: false,
                  maxLength: 200,
                )),
            LabelWidgetContainer(
                label: "Core Areas of Operation",
                setCompulsory: true,
                child: FormTextField(
                  controller: _controllerCoreAreas,
                  maxLength: 500,
                  minLines: 6,
                  maxLines: 12,
                  showMaxLength: true,
                  applyValidation: true,
                ))
          ],
        ),
      ),
    );
  }

  Widget groupingInfoView() {
    return Stack(children: [
      ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(
              label: "Branch",
              setCompulsory: true,
              child: FormButton(
                label: selectedBranch ?? "Select Branch",
                function: () {
                  var newBranchList = branchList
                      ?.map((value) => {'name': value.name, 'id': value.id})
                      .toList();
                  selectBranch(newBranchList);
                },
              )),
          LabelWidgetContainer(
              label: "Category",
              setCompulsory: true,
              child: FormButton(
                label: selectedCategory ?? "Select Category",
                function: () {
                  var newCategoryList = categoryList
                      ?.map((value) => {'name': value.category, 'id': value.id})
                      .toList();
                  selectCategory(newCategoryList);
                },
              )),
          LabelWidgetContainer(
            label: "Group",
            child: CustomMultiselectDropDown(
              hinText: 'Select Group(s)',
              selectedItems: selectedGroupList!,
              itemList: groupList!.map((e) => e.group!).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGroupList = value;
                });
                // selectedGroupOption = '';
                // for (var element in selectedGroupList!) {
                //   selectedGroupOption += '$element,';
                //   // '$selectedGroupOption, $element';
                // }
                debugPrint('Selected Options: $selectedGroupList');
              },
            ),
          ),
          (selectedGroupList == null || selectedGroupList!.isEmpty)
              ? const SizedBox()
              : SizedBox(
                  height: displayHeight(context) * 0.010,
                ),
          (selectedGroupList == null || selectedGroupList!.isEmpty)
              ? const SizedBox()
              : const TagWidget(
                  text:
                      'Please make sure to select subgroup(s) related to the group(s) you have selected.',
                  color: Colors.green,
                  textAlign: TextAlign.start,
                ),
          SizedBox(
            height: displayHeight(context) * 0.020,
          ),
          LabelWidgetContainer(
            label: "SubGroup",
            child: CustomMultiselectDropDown(
              hinText: 'Select Subgroup(s)',
              selectedItems: selectedSubGroupList!,
              itemList: subGroupList!
                  .map((e) => '${e.groupId!.group!} => ${e.subgroup!}')
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubGroupList = value;
                });
                // selectedSubGroupOption = '';
                // for (var element in selectedSubGroupList!) {
                //   setState(() {
                //     selectedSubGroupOption += '$element,';
                //   });
                // }
                debugPrint('Selected Options: $selectedSubGroupList');
              },
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.020,
          ),
        ],
      ),
      loadingGroup
          ? const Align(
              child: CircularProgressIndicator(),
            )
          : Container(),
    ]);
  }

  Widget locationInfoView() {
    return Stack(children: [
      ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(
              setCompulsory: true,
              label: "Country",
              child: FormButton(
                label: selectedCountry ?? "Select Country",
                function: () {
                  var newCountryList = countryList
                      ?.map((value) => {'name': value.name, 'id': value.id})
                      .toList();
                  selectCountry(newCountryList);
                },
              )),
          !ifGhanaSelected
              ? Form(
                  key: formGlobalKeyStateProvince,
                  child: Column(
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
                )
              : Container(),
          ifGhanaSelected
              ? LabelWidgetContainer(
                  setCompulsory: true,
                  label: "Region",
                  child: FormButton(
                    label: selectedRegion ?? "Select Region",
                    function: () {
                      var newRegionList = regionList
                          ?.map((value) =>
                              {'name': value.location, 'id': value.id})
                          .toList();
                      selectRegion(newRegionList);
                    },
                  ))
              : Container(),
          ifGhanaSelected
              ? LabelWidgetContainer(
                  // setCompulsory: true,
                  label: "District",
                  child: FormButton(
                    label: selectedDistrict ?? "Select District",
                    function: () {
                      var newDistrictList = districtList
                          ?.map((value) =>
                              {'name': value.location, 'id': value.id})
                          .toList();
                      selectDistrict(newDistrictList);
                    },
                  ))
              : Container(),
          ifGhanaSelected
              ? LabelWidgetContainer(
                  //setCompulsory: true,
                  label: "Constituency",
                  child: FormButton(
                    label: selectedConstituency ?? "Select Constituency",
                    function: () {
                      var newConstituencyList = constituencyList
                          ?.map((value) =>
                              {'name': value.location, 'id': value.id})
                          .toList();
                      selectConstituency(newConstituencyList);
                    },
                  ))
              : Container(),
          ifGhanaSelected
              ? LabelWidgetContainer(
                  label: "Electoral Area",
                  child: FormButton(
                    label: selectedElectoral ?? "Select Electoral Area",
                    function: () {
                      var newCommunityList = communityList
                          ?.map((value) =>
                              {'name': value.location, 'id': value.id})
                          .toList();
                      selectElectoralArea(newCommunityList);
                    },
                  ))
              : Container(),
          ifGhanaSelected
              ? Form(
                  key: formGlobalKeyStateProvince,
                  child: LabelWidgetContainer(
                      label: "Community",
                      setCompulsory: true,
                      child: FormTextField(
                        controller: _controllerCommunity,
                        label: "Enter Community",
                      )),
                )
              : Container(),
        ],
      ),
      loadingLocation
          ? const Align(
              child: CircularProgressIndicator(),
            )
          : Container(),
    ]);
  }

  Widget contactInfoInfoView() {
    return Form(
      key: formGlobalKeyContactPerson,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LabelWidgetContainer(
              label: "Name",
              setCompulsory: true,
              child: FormTextField(
                controller: _controllerContactName,
              )),
          LabelWidgetContainer(
              label: "Email Address",
              setCompulsory: true,
              child: EmailFormTextField(
                controller: _controllerContactEmail,
                textInputType: TextInputType.emailAddress,
              )),
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
              label: "Phone",
              setCompulsory: true,
              child: PhoneFormTextField(
                controller: _controllerContactPhone,
                textInputType: TextInputType.number,
                maxLength: 10,
              )),
          LabelWidgetContainer(
              label: "Whatsapp Contact",
              setCompulsory: false,
              child: PhoneFormTextField(
                controller: _controllerContactWhatsapp,
                textInputType: TextInputType.number,
                applyValidation: false,
                maxLength: 10,
              )),
          const Divider(
            color: Colors.black38,
          ),
          const SizedBox(
            height: 18,
          ),
          LabelWidgetContainer(
            label: "Password",
            setCompulsory: true,
            child: FormTextField(
              controller: _controllerPassword,
              obscureText: passwordVisible,
              suffixTapFunction: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
          LabelWidgetContainer(
              label: "Confirm Password",
              setCompulsory: true,
              child: FormTextField(
                controller: _controllerConfirmPassword,
                obscureText: confirmPasswordVisible,
                suffixTapFunction: () {
                  setState(() {
                    confirmPasswordVisible = !confirmPasswordVisible;
                  });
                },
              )),
          const SizedBox(
            height: 36,
          ),
          CustomElevatedButton(
              label: "Submit",
              function: () {
                debugPrint(''
                    ' logo $imageFile'
                    ' orgDate $orgDate'
                    ' imageRegCert $imageRegCert'
                    ' _controllerOrgName ${_controllerOrgName.text}'
                    '_controllerEmail ${_controllerEmail.text}'
                    ' _controllerPhone ${_controllerPhone.text}'
                    ' _controllerWebsite ${_controllerWebsite.text}'
                    ' _controllerPostalAddress ${_controllerPostalAddress.text}'
                    ' _controllerCoreAreas ${_controllerCoreAreas.text}'
                    'selectedBranch $selectedBranch,'
                    ' selectedCategory $selectedCategory $selectedCategoryID,'
                    'contactPersonGender $selectedGender'
                    ' selectedGroup $selectedGroup'
                    ' selectedSubGroup $selectedSubGroup'
                    '=== organizationLegalRegistration $organizationLegalRegistration'
                    ' selectedCountry $selectedCountry $selectedCountryID'
                    ' selectedRegion $selectedRegion'
                    ' selectedDistrict $selectedDistrict'
                    ' selectedConstituency $selectedConstituency'
                    ' selectedElectoralArea $selectedElectoral'
                    ' selectedCommunity ${_controllerCommunity.text}'
                    ' selectedStateProvince ${_controllerStateProvince.text}'
                    '_controllerConfirmPassword ${_controllerConfirmPassword.text}'
                    ' _controllerPassword ${_controllerPassword.text}'
                    ' _controllerContactWhatsapp ${_controllerContactWhatsapp.text}'
                    ' _controllerContactPhone ${_controllerContactPhone.text}'
                    ' _controllerContactEmail ${_controllerContactEmail.text}'
                    ' _controllerContactName ${_controllerContactName.text}'
                    '  clientId: ${widget.clientID}'
                    ' branchId:$selectedBranchID');

                var password = _controllerPassword.text.trim();
                var repeat_password = _controllerConfirmPassword.text.trim();
                if (!formGlobalKeyContactPerson.currentState!.validate()) {
                  return;
                }
                if (_controllerContactName.text.isEmpty) {
                  showErrorSnackBar(
                      context, "Enter your contact person's name");
                  return;
                }
                if (_controllerContactEmail.text.isEmpty) {
                  showErrorSnackBar(
                      context, "Enter your contact person's email");
                  return;
                }
                if (_controllerContactPhone.text.isEmpty) {
                  showErrorSnackBar(
                      context, "Enter your contact person's phone");
                  return;
                }
                if (password != repeat_password) {
                  showErrorSnackBar(context, 'Passwords must be the same');
                  return;
                }
                if (password.length < 7) {
                  showErrorSnackBar(
                      context, 'Passwords must contain at least 8 characters');
                  return;
                }
                if (!password.contains(RegExp(r'[0-9]'))) {
                  showErrorSnackBar(context,
                      'This password is too common, add special symbols eg.!@#');
                  return;
                }

                showLoadingDialog(
                  context,
                  'Please wait, we are processing...',
                );

                MemberAPI.registerOrg(
                  context,
                  clientId: '${widget.clientID}',
                  branchId: '$selectedBranchID',
                  organizationName: _controllerOrgName.text.trim(),
                  contactPersonName: _controllerContactName.text.trim(),
                  contactPersonGender: selectedGender == 'Male' ? 1 : 2,
                  organizationType: selectedOrgTypeID,
                  organizationEmail: _controllerEmail.text.trim(),
                  organizationPhone: _controllerPhone.text.trim(),
                  contactPersonEmail: _controllerContactEmail.text.trim(),
                  contactPersonPhone: _controllerContactPhone.text.trim(),
                  contactPersonWhatsapp: _controllerContactWhatsapp.text.trim(),
                  // occupation,
                  memberType: selectedCategoryID,
                  // referenceId: _controllerIDNumber.text,
                  countryOfBusiness: selectedCountryID,
                  stateProvince: _controllerStateProvince.text.trim(),
                  region: selectedRegionID,
                  district: selectedDistrictID,
                  constituency: selectedConstituencyID,
                  electoralArea: selectedElectoralID,
                  community: _controllerCommunity.text.trim(),
                  digitalAddress: '-',
                  businessRegistered:
                      organizationLegalRegistration == 0 ? true : false,
                  businessDescription: _controllerCoreAreas.text.trim(),
                  website: _controllerWebsite.text.trim(),
                  groupIds: selectedGroupIds(),
                  subgroupIds: selectedSubGroupIds(),
                  password: _controllerPassword.text.trim(),
                  confirm_password: _controllerConfirmPassword.text.trim(),
                  logo: imageFile?.path,
                  certificates: imageRegCert,
                ).then((value) {
                  Navigator.of(context).pop();
                  if (value == 'successful') {
                    showInfoDialog(
                      'ok',
                      context: context,
                      dismissible: false,
                      title: 'Welcome ${_controllerOrgName.text},',
                      content:
                          'Successfully submitted, check email/spam and contact admin for verification.',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ));
                      },
                    );
                    return;
                  }
                  //showErrorToast(value);
                });
              })
        ],
      ),
    );
  }

  List<String> genders = ["Male", "Female"];
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
  selectBranch(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedBranch = value['name'];
          selectedBranchID = value['id'];
          debugPrint('selectedBranchdf $selectedBranchID, $selectedBranch');
          _getSubGroupList(token: token, branchID: selectedBranchID);
          _getGroupList(token: token, branchID: selectedBranchID);
          loadingGroup = true;
        });
      }
    });
  }

  selectCategory(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedCategory = value['name'];
          selectedCategoryID = value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectOrgType(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedOrgType = value['type'];
          selectedOrgTypeID = value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectGroup(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedGroup = value['name'];
          selectedGroupID = value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectSubGroup(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedSubGroup = value['name'];
          selectedSubGroupID = value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  //  LOCATION
  selectCountry(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedCountry = value['name'];
          selectedCountryID = value['id'];
          debugPrint('selectedCountryID $selectedCountryID, $selectedCountry');
          ifGhanaSelected =
              selectedCountry.toString() == 'Ghana' ? true : false;
          debugPrint('ifGhanaSelected $ifGhanaSelected;');
        });
      }
    });
  }

  selectRegion(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedRegion = value['name'];
          selectedRegionID = value['id'];
          debugPrint('selectedRegion $selectedRegion, $selectedRegionID');
          _getDistrictList(regionID: selectedRegionID);
          loadingLocation = true;
        });
      }
    });
  }

  selectDistrict(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedDistrict = value['name'];
          selectedDistrictID = value['id'];
          debugPrint(
              'selectedDistrictID $selectedDistrict, $selectedDistrictID');
          _getConstituencyList(
              regionID: selectedRegionID, districtID: selectedDistrictID);
          _getElectoralArea(
              regionID: selectedRegionID, districtID: selectedDistrictID);
          loadingLocation = false;
        });
      }
    });
  }

  selectConstituency(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedConstituency = value['name'];
          selectedConstituencyID = value['id'];
          debugPrint(
              'Constituency $selectedConstituency, $selectedConstituencyID');
        });
      }
    });
  }

  selectElectoralArea(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedElectoral = value['name'];
          selectedElectoralID = value['id'];
          debugPrint(
              'selectedElectoralArea $selectedElectoral, $selectedElectoralID');
        });
      }
    });
  }
}
