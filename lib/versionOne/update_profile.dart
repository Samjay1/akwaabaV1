import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/download_util.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../components/custom_cached_image_widget.dart';
import '../components/custom_dropdown_multiselect.dart';
import '../components/text_shimmer_item.dart';
import '../models/general/abstractGroup.dart';
import '../models/general/abstractModel.dart';
import '../models/general/abstractSubGroup.dart';
import '../models/general/branch.dart';
import '../models/general/constiteuncy.dart';
import '../models/general/country.dart';
import '../models/general/district.dart';
import '../models/general/electoralArea.dart';
import '../models/general/memberType.dart';
import '../models/general/region.dart';
import '../models/members/previewMemberProfile.dart';
import 'login_page.dart';

class UpdateProfile extends StatefulWidget {
  final int? memberId;
  const UpdateProfile({Key? key, this.memberId}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
  final TextEditingController _controllerDigitalAddress =
      TextEditingController();
  final TextEditingController _controllerHomeTown = TextEditingController();

  //SETS AND DISPLAYS CURRENT PROFILE INFO
  void setBioDefaultValues(
      {firstname,
      surname,
      middlename,
      whatsapp,
      phone,
      email,
      idNumber,
      dateofbirth,
      var gender}) {
    _controllerFirstName.text = firstname;
    _controllerSurname.text = surname;
    _controllerMiddleName.text = middlename;
    _controllerWhatsappContact.text = whatsapp;
    _controllerPhone.text = phone;
    _controllerEmail.text = email;
    _controllerIDNumber.text = idNumber;
    birthDate = DateTime.parse(dateofbirth);
    selectedGender = gender == 1 ? 'Male' : 'Female';
  }

  void setGroupDefaultValues({branch, branchId, category, categoryId}) {
    selectedBranch = branch;
    selectedBranchID = branchId;
    selectedCategory = category;
    selectedCategoryID = categoryId;
  }

  void setLocationDefaultValues(
      {country,
      countryId,
      region,
      regionId,
      district,
      districtId,
      constituency,
      constituencyId,
      electoralArea,
      electoralAreaId,
      stateProvince,
      community}) {
    debugPrint('=-=-=-=-=-$selectedDistrict');
    setState(() {
      selectedCountry = country;
      selectedCountryID = countryId;
      selectedRegion = region;
      selectedRegionID = regionId;
      selectedDistrict = district;
      selectedDistrictID = districtId;
      selectedConstituency = constituency;
      selectedConstituencyID = constituencyId;
      selectedElectoralAreaID = electoralAreaId;
      selectedElectoralArea = electoralArea;
      _controllerCommunity.text = community;
      _controllerStateProvince.text = stateProvince;
    });
  }

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
  File? imageFile;
  File? imageCV;
  File? imageIDCard;
  final formGlobalKeyBio = GlobalKey<FormState>();
  final formGlobalKeyStatus = GlobalKey<FormState>();
  final formGlobalKeyStateProvince = GlobalKey<FormState>();
  final formGlobalKeyPassword = GlobalKey<FormState>();

  //PROFILE INFO
  PreviewMemberProfile? myProfile;
  void _getMyProfile() async {
    myProfile =
        (await MemberAPI().getFullProfileInfo(memberId: await getMemberId()));
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
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

  Future<int> getMemberId() async {
    int? memberId;
    if (widget.memberId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      memberId = prefs.getInt('memberId');
    } else {
      memberId = widget.memberId;
    }
    return memberId!;
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
  var selectedElectoralArea;
  var selectedElectoralAreaID;
  late List<ElectoralArea>? electoralAreaList = [];
  void _getElectoralAreaList({var regionID, var districtID}) async {
    electoralAreaList = (await MemberAPI()
        .getElectoralArea(regionID: regionID, districtID: districtID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loadingLocation = false;
        }));
  }

  //STATUS - MARITAL STATUS
  var selectedMarital;
  var selectedMaritalID;
  late List<AbstractModel>? maritalList = [];
  void _getMaritalList() async {
    maritalList = (await MemberAPI().getMaritalStatus());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //STATUS - EDUCATION STATUS
  var selectedEducation;
  var selectedEducationID;
  late List<AbstractModel>? educationList = [];
  void _getEducationList() async {
    educationList = (await MemberAPI().getEducation());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //STATUS - OCCUPATION STATUS
  var selectedOccupation;
  var selectedOccupationID;
  late List<AbstractModel>? occupationList = [];
  void _getOccupationList() async {
    occupationList = (await MemberAPI().getOccupation());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //STATUS - PROFESSION STATUS
  var selectedProfession;
  var selectedProfessionID;
  late List<AbstractModel>? professionList = [];
  void _getProfessionList() async {
    professionList = (await MemberAPI().getProfession());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //GROUPING - BRANCH
  var selectedBranch;
  var selectedBranchID;
  late List<Branch>? branchList = [];
  void _getBranchList({required var token}) async {
    branchList = (await MemberAPI().getBranches(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //GROUPING - CATEGORY
  var selectedCategory;
  var selectedCategoryID;
  late List<MemberType>? categoryList = [];
  void _getCategoryList({required var token}) async {
    categoryList = (await MemberAPI().getMemberType(token: token));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    loadingGroup = false;
  }

  // //GROUPING - GROUP
  // var selectedGroup;
  // var selectedGroupID;
  // late List<AbstractGroup>? groupList = [];
  // void _getGroupList({required var branchID, var token}) async {
  //   groupList = (await MemberAPI().getGroup(branchID: branchID, token: token));
  //   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  //   loadingGroup = false;
  // }

  // //GROUPING - SUB GROUP
  // var selectedSubGroup;
  // var selectedSubGroupID;
  // late List<SubGroup>? subGroupList = [];
  // void _getSubGroupList({required var branchID, var token}) async {
  //   subGroupList =
  //       (await MemberAPI().getSubGroup(branchID: branchID, token: token));
  //   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  // }

  // GROUP - MEMBER GROUPS
  List<Group> groups = [];
  void _getMemberGroups() async {
    groups = await MemberAPI().getMemberGroups(memberId: await getMemberId());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          selectedGroupList = groups.map((e) => e.group!).toList();
        }));
  }

  // GROUP - MEMBER SUBGROUPS
  List<SubGroup> subGroups = [];
  void _getMemberSubGroups() async {
    subGroups =
        await MemberAPI().getMemberSubGroups(memberId: await getMemberId());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          selectedSubGroupList = subGroups
              .map((e) => '${e.groupId!.group!} => ${e.subgroup!}')
              .toList();
        }));
  }

  //GROUPING - GROUP
  var selectedGroup;
  var selectedGroupID;

  late List<String>? selectedGroupList = [];
  late String selectedGroupOption;
  late List<Group>? groupList = [];
  void _getGroupList({required var branchID, var token}) async {
    groupList = (await MemberAPI().getGroup(branchID: branchID, token: token));
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
    subGroupList =
        (await MemberAPI().getSubGroup(branchID: branchID, token: token));
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

  final ReceivePort _port = ReceivePort();

  _registerDownloadTask() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  var token;
  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    token = prefs.getString('token');
    _getBranchList(token: token);
    _getCategoryList(token: token);
    _getMemberGroups();
    _getMemberSubGroups();
    if (myProfile != null) {
      _getGroupList(branchID: myProfile!.branchId, token: token);
      _getSubGroupList(branchID: myProfile!.branchId, token: token);
    }
  }

  //LOCATION - REGION
  Region? singleRegion;
  void _getSingleRegion({required regionId}) async {
    Region? singleRegionVal =
        await MemberAPI().getSingleRegion(regionId: regionId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          singleRegion = singleRegionVal;
        }));
    print('2. singleRegion?.location ${singleRegion?.location}');
  }

  //LOCATION - DISTRICT
  District? singleDistrict;
  void _getSingleDistrict({required districtId}) async {
    print('1. singleDistrict?.location');
    singleDistrict =
        await MemberAPI().getSingleDistrict(districtId: districtId);
    print('2. singleDistrict?.location ${singleDistrict?.location}');
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          print('2. singleDistrict?.location ${singleDistrict?.location}');
        }));
  }

  //LOCATION - CONSTITUENCY
  Constituency? singleConstituency;
  void _getsingleConstituency({required ConstId}) async {
    singleConstituency =
        await MemberAPI().getSingleConstituency(ConstId: ConstId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  //LOCATION - ELECTORAL AREA
  ElectoralArea? singleElectoral;
  void _getsingleElectoralArea({required electoralId}) async {
    singleElectoral =
        await MemberAPI().getSingleElectoralArea(electoralId: electoralId);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  String? userType;

  bool delayLoading = true;
  @override
  void initState() {
    _registerDownloadTask();
    _getMyProfile();
    _getCountryList();
    _getRegionList();
    _getMaritalList();
    _getEducationList();
    _getOccupationList();
    _getProfessionList();
    getToken();

    Future.delayed(const Duration(seconds: 8)).then((value) => setState(() {
          print('kjRegion ID ${myProfile?.region} ${singleRegion?.location}');

          SharedPrefs().getUserType().then((value) => setState(() {
                userType = value;
              }));

          setState(() {
            _getSingleRegion(regionId: myProfile?.region);
            _getSingleDistrict(districtId: myProfile?.district);
            _getsingleConstituency(
              ConstId: myProfile?.constituency,
            );
            _getsingleElectoralArea(
              electoralId: myProfile?.electoralArea,
            );
            ifGhanaSelected =
                myProfile?.countryOfResidence == "Ghana" ? true : false;
          });
        }));

    //SET ALL DEFAULTS VALUES HERE
    Future.delayed(const Duration(seconds: 20)).then((value) => setState(() {
          setBioDefaultValues(
              firstname: myProfile?.firstname,
              surname: myProfile?.surname,
              middlename: myProfile?.middlename,
              whatsapp: '',
              phone: myProfile?.phone,
              email: myProfile?.email,
              idNumber: myProfile?.referenceId,
              dateofbirth: myProfile?.dateOfBirth,
              gender: myProfile?.gender);

          setGroupDefaultValues(
              branch: myProfile?.branchInfo['name'],
              branchId: myProfile?.branchId,
              category: '${myProfile?.categoryInfo['category']}',
              categoryId: myProfile?.memberType);

          print('singleton-----${singleDistrict?.location}');
          setLocationDefaultValues(
              country: myProfile?.countryOfResidence,
              countryId: myProfile?.nationality,
              region: '${singleRegion?.location}',
              regionId: myProfile?.region,
              district: '${singleDistrict?.location}',
              districtId: myProfile?.district,
              constituency: '${singleConstituency?.location}',
              constituencyId: myProfile?.constituency,
              electoralArea: '${singleElectoral?.location}',
              electoralAreaId: myProfile?.electoralArea,
              stateProvince: myProfile?.stateProvince,
              community: myProfile?.community);

          //GETS THE LOCATION LIST FOR DISTRICT,CONSTITUENCY AND ELECTORAL AREA
          _getDistrictList(regionID: selectedRegionID);
          _getConstituencyList(
              regionID: selectedRegionID, districtID: selectedDistrictID);
          _getElectoralAreaList(
              regionID: selectedRegionID, districtID: selectedDistrictID);
          delayLoading = false;
        }));

    pageViewController.addListener(() {
      if (pageViewController.page?.round() != currentIndex) {
        setState(() {
          currentIndex = pageViewController.page!.round();
        });
      }
    });

    super.initState();
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['doc', 'docx', 'pdf'],
      type: FileType.custom,
    );
    if (result != null) {
      setState(() {
        imageCV = File(result.files.single.path!);
      });
    }
  }

  void selectProfileIDCard() async {
    final getImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (getImage != null) {
        imageIDCard = File(getImage.path);
      }
    });
  }

  nextButtonTapped({required double pageId}) {
    switch (pageId.toInt()) {
      case 0:
        //currently on bio data page,
        //check these inputs -> gender and dob
        if (!formGlobalKeyBio.currentState!.validate()) {
          return;
        }
        if (birthDate == null) {
          showErrorSnackBar(context, "select date of birth");
          return;
        }
        if (selectedGender == null) {
          showErrorSnackBar(context, "select your gender");
          return;
        }
        userType == AppConstants.member
            ? pageViewController.jumpToPage(2)
            : pageViewController.animateToPage(
                1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn,
              );
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
        // if (!formGlobalKeyStateProvince.currentState!.validate()) {
        //   return;
        // }
        if (selectedCountryID == null) {
          showErrorSnackBar(context, "select your Country");
          return;
        }
        if (ifGhanaSelected) {
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
          if (_controllerCommunity.text.isEmpty) {
            showErrorSnackBar(context, "Enter your Community");
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

        if (!formGlobalKeyStatus.currentState!.validate()) {
          return;
        }

        if (imageIDCard == null) {
          showErrorSnackBar(context, "Upload your ID Card");
          return;
        }
        if (imageCV == null) {
          showErrorSnackBar(context, "Upload your CV");
          return;
        }
        // pageViewController.animateToPage(4,
        //     duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('singleton-----${singleDistrict?.location}');

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: currentIndex == 0 ? true : false,
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentIndex == 0
                  ? "Bio Data"
                  : currentIndex == 1
                      ? "Grouping"
                      : currentIndex == 2
                          ? "Location"
                          : currentIndex == 3
                              ? "Documents"
                              : "",
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageViewController,
                children: [
                  bioDataView(),
                  groupingView(),
                  locationView(),
                  statusView(),
                  // passwordsView(),
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
                            userType == AppConstants.member && currentIndex == 2
                                ? pageViewController.jumpToPage(0)
                                : pageViewController.animateToPage(
                                    currentIndex - 1,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                            // nextButtonTapped(pageId: pageViewController.page);
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

  bool bioLoading = false;
  bool whatsappLoading = false;
  bool profilePicLoading = false;
  Widget bioDataView() {
    return Form(
      key: formGlobalKeyBio,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.file(
                        imageFile!,
                        height: 120,
                        width: 120,
                      ),
                    )
                  : myProfile?.profilePicture != null
                      ? CustomCachedImageWidget(
                          url: '${myProfile?.profilePicture}',
                          height: 125,
                        )
                      : defaultProfilePic(height: 120),
              profilePicLoading
                  ? const Align(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              !profilePicLoading
                  ? CupertinoButton(
                      onPressed: () {
                        print('PROFILE IMAGE FILE----- ${imageFile?.path}');
                        selectProfilePhoto();
                      },
                      child: loading
                          ? const CustomProgressIndicator()
                          : Text(imageFile != null
                              ? "Change Photo"
                              : "Select Photo"))
                  : Container(),
              imageFile != null
                  ? CupertinoButton(
                      color: primaryColor,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        MemberAPI.updateProfilePic(
                          memberId: await getMemberId(),
                          profilePic: imageFile?.path,
                        ).then((value) {
                          setState(() {
                            loading = false;
                          });
                          if (value == 'failed') {
                            showErrorToast("Profile photo Update failed");
                          } else if (value == 'successful') {
                            showNormalToast(
                              "Profile photo uploaded successfully",
                            );
                          }
                        });
                      },
                      child: const Text("Upload Photo"))
                  : Container(),
              const SizedBox(height: 5),
            ],
          ),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "First Name",
                  child: FormTextField(
                    controller: _controllerFirstName,
                  )),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Middle Name",
                  child: FormTextField(
                    controller: _controllerMiddleName,
                    label: "",
                    applyValidation: false,
                  )),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Surname",
                  child: FormTextField(
                    controller: _controllerSurname,
                    label: "",
                  ),
                ),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Gender",
                  child: FormButton(
                    label: selectedGender ?? "Select Gender",
                    function: () {
                      selectGender();
                    },
                  )),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Date of Birth",
                  child: FormButton(
                    label: birthDate != null
                        ? DateFormat("dd MMM yyyy").format(birthDate!)
                        : "Select Date",
                    function: () {
                      selectDateOfBirth();
                    },
                  )),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Phone",
                  child: FormTextField(
                    controller: _controllerPhone,
                    label: "",
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.phone,
                    maxLength: 10,
                  ),
                ),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Email Address",
                  child: FormTextField(
                    controller: _controllerEmail,
                    label: "",
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : Form(
                  key: formGlobalKeyStatus,
                  child: LabelWidgetContainer(
                      label: "Reference ID",
                      child: FormTextField(
                        controller: _controllerIDNumber,
                      )),
                ),
          10.ph,
          CustomElevatedButton(
            label: 'Update Bio',
            showProgress: bioLoading,
            function: () async {
              setState(() {
                bioLoading = true;
              });

              final DateTime? now = birthDate;
              final DateFormat formatter = DateFormat('yyyy-MM-dd');
              String? formatted;
              if (birthDate != null) {
                setState(() {
                  formatted = formatter.format(now!);
                });
              }
              debugPrint('firstname ${_controllerFirstName.text},'
                  'formatter $formatter '
                  'surname ${_controllerSurname.text},'
                  '');

              MemberAPI.updateBio(
                      memberId: await getMemberId(),
                      firstname: _controllerFirstName.text,
                      surname: _controllerSurname.text,
                      middlename: _controllerMiddleName.text,
                      gender: selectedGender == 'Male' ? 1 : 2,
                      dateOfBirth: formatted,
                      email: _controllerEmail.text,
                      phone: _controllerPhone.text,
                      referenceId: _controllerIDNumber.text)
                  .then((value) {
                setState(() {
                  bioLoading = false;
                });
                if (value == 'failed') {
                  showErrorToast("Bio Update failed");
                  return;
                }
                if (value == 'successful') {
                  showNormalToast("Bio information Update Successful");
                }
              });
              //Navigator.pop(context);
            },
          ),
          26.ph,
          delayLoading
              ? Shimmer.fromColors(
                  baseColor: greyColorShade300,
                  highlightColor: greyColorShade100,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const TextShimmerItem(),
                  ))
              : LabelWidgetContainer(
                  label: "Whatsapp Contact",
                  child: FormTextField(
                    controller: _controllerWhatsappContact,
                    textInputType: TextInputType.phone,
                    maxLength: 10,
                    applyValidation: false,
                  )),
          10.ph,
          CustomElevatedButton(
            label: 'Update Whatsapp Number',
            showProgress: whatsappLoading,
            function: () async {
              debugPrint('Whatsapp ${_controllerWhatsappContact.text}');

              if (_controllerWhatsappContact.text.isEmpty) {
                showErrorSnackBar(context, "Enter your whatsapp contact");
                return;
              }

              setState(() {
                whatsappLoading = true;
              });

              MemberAPI.updateWhatsappContact(
                memberId: await getMemberId(),
                phone: _controllerWhatsappContact.text,
              ).then((value) {
                setState(() {
                  whatsappLoading = false;
                });
                if (value == 'failed') {
                  showErrorToast("Whatsapp contact update failed");
                  return;
                }
                if (value == 'successful') {
                  showNormalToast("Whatsapp contact update successful");
                }
              });
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  bool loadingBranch = false;
  bool loadingGroup = false;
  Widget groupingView() {
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

          loadingBranch
              ? const Align(
                  child: CircularProgressIndicator(),
                )
              : Container(),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          CustomElevatedButton(
            label: 'Update ',
            function: () async {
              setState(() {
                loadingBranch = true;
              });
              final DateTime? now = birthDate;
              final DateFormat formatter = DateFormat('yyyy-MM-dd');
              String? formatted;
              if (birthDate != null) {
                setState(() {
                  formatted = formatter.format(now!);
                });
              }
              debugPrint('firstname ${_controllerFirstName.text},'
                  'formatter $formatter '
                  'surname ${_controllerSurname.text},'
                  '');

              MemberAPI.updateGroup(
                branchId: selectedBranchID,
                category: selectedCategoryID,
                memberId: await getMemberId(),
              ).then((value) async {
                setState(() {
                  loadingBranch = false;
                });
                if (value == 'failed') {
                  showErrorToast("Group update failed");
                  return;
                }
                if (value == 'successful') {
                  showNormalToast("Update successfully");
                }
              });
            },
          ),

          SizedBox(
            height: displayHeight(context) * 0.03,
          ),

          // UPDATE GROUP AND SUBGROUP
          userType == AppConstants.admin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            .map(
                                (e) => '${e.groupId!.group!} => ${e.subgroup!}')
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubGroupList = value;
                          });
                          debugPrint('Selected Options: $selectedSubGroupList');
                        },
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.020,
                    ),
                    loadingGroup
                        ? const Align(
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                      label: 'Update Group',
                      function: () async {
                        setState(() {
                          loadingGroup = true;
                        });
                        final DateTime? now = birthDate;
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        String? formatted;
                        if (birthDate != null) {
                          setState(() {
                            formatted = formatter.format(now!);
                          });
                        }
                        debugPrint('firstname ${_controllerFirstName.text},'
                            'formatter $formatter '
                            'surname ${_controllerSurname.text},'
                            '');

                        MemberAPI.updateMemberGroups(
                                memberId: await getMemberId(),
                                groupIds: selectedGroupIds(),
                                subgroupIds: selectedSubGroupIds())
                            .then((value) async {
                          setState(() {
                            loadingGroup = false;
                          });
                          if (value == 'failed') {
                            showErrorToast("Group Update failed");
                            return;
                          }
                          if (value == 'successful') {
                            showNormalToast(
                                "Group information updated successfully");
                          }
                        });
                      },
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    ]);
  }

  bool loadingLocation = false;
  bool ifGhanaSelected = false;
  Widget locationView() {
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
                    label: selectedElectoralArea ?? "Select Electoral Area",
                    function: () {
                      var newCommunityList = electoralAreaList
                          ?.map((value) =>
                              {'name': value.location, 'id': value.id})
                          .toList();
                      selectCommunity(newCommunityList);
                    },
                  ))
              : Container(),
          ifGhanaSelected
              ? Form(
                  child: LabelWidgetContainer(
                      label: "Community",
                      setCompulsory: true,
                      child: FormTextField(
                        controller: _controllerCommunity,
                      )),
                )
              : Container(),
          ifGhanaSelected
              ? Form(
                  child: LabelWidgetContainer(
                      label: "Home Town",
                      child: FormTextField(
                        controller: _controllerHomeTown,
                      )),
                )
              : Container(),
          ifGhanaSelected
              ? Form(
                  child: LabelWidgetContainer(
                      label: "Digital Address",
                      child: FormTextField(
                        controller: _controllerDigitalAddress,
                      )),
                )
              : Container(),
          loadingLocation
              ? const Align(
                  child: CircularProgressIndicator(),
                )
              : Container(),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          CustomElevatedButton(
            label: 'Update Location',
            function: () async {
              setState(() {
                loadingLocation = true;
              });

              MemberAPI.updateLocation(
                context,
                memberId: await getMemberId(),
                nationality: selectedCountryID,
                countryOfResidence: selectedCountry,
                stateProvince: _controllerStateProvince.text.trim(),
                region: selectedRegionID,
                district: selectedDistrictID,
                constituency: selectedConstituencyID,
                electoralArea: selectedElectoralAreaID,
                community: _controllerCommunity.text.trim(),
                digitalAddress: _controllerDigitalAddress.text.trim(),
                hometown: _controllerHomeTown.text.trim(),
              ).then((value) {
                setState(() {
                  loadingLocation = false;
                });
                if (value == 'failed') {
                  showErrorToast("Location Update failed");
                } else if (value == 'successful') {
                  showNormalToast(
                      'Location data has been updated successfully');
                  // Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute( builder: (_) =>  const LoginPage(),));
                }
              });
            },
          )
        ],
      ),
    ]);
  }

  bool loadingStatus = false;
  Widget statusView() {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageIDCard != null
                ? Container(
                    width: size.width * 0.93,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: IconButton(
                          onPressed: () {},
                          icon: Row(children: const [
                            Text(
                              'National ID Card selected',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.check_circle_outlined,
                              color: Colors.green,
                            )
                          ])),
                    ),
                  )
                : myProfile?.profileIdentification != null
                    ? const Text('No File Uploaded')
                    : const Text('Update submitted File'),
            CupertinoButton(
              onPressed: () {
                print('IMAGE NAME----- ${imageIDCard?.absolute}');
                selectProfileIDCard();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: primaryColor,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        imageIDCard != null
                            ? "Change National ID"
                            : "Select National ID",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.04,
                  ),
                  (myProfile != null &&
                          myProfile?.profileIdentification != null)
                      ? InkWell(
                          onTap: () => DownloadUtil.downloadFile(
                            url: myProfile!.profileIdentification!,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor.withOpacity(0.2),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              CupertinoIcons.cloud_download,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Center(
              child: CustomElevatedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  label: 'Upload National ID Card',
                  function: () async {
                    if (imageIDCard != null) {
                      setState(() {
                        loadingStatus = true;
                      });
                      MemberAPI.updateIDCard(
                              memberId: await getMemberId(),
                              profileIdentification: imageIDCard?.path)
                          .then((value) {
                        if (value == 'failed') {
                          setState(() {
                            loadingStatus = false;
                          });
                          showErrorToast("ID Card Update failed");
                          return;
                        }
                        if (value == 'successful') {
                          setState(() {
                            loadingStatus = false;
                          });
                          showNormalToast(
                              "ID card  has been uploaded successfully");
                        }
                      });
                    } else {
                      showErrorToast(
                          'Please select a national ID card to upload');
                    }
                  }),
            ),
            const SizedBox(height: 16),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageCV != null
                ? Container(
                    width: size.width * 0.93,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: IconButton(
                          onPressed: () {},
                          icon: Row(children: const [
                            Text(
                              'CV selected',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.check_circle_outlined,
                              color: Colors.green,
                            )
                          ])),
                    ),
                  )
                : myProfile?.profileResume != null
                    ? const Text('No File Uploaded')
                    : const Text('Update submitted File'),
            CupertinoButton(
              onPressed: () {
                print('IMAGE NAME----- ${imageCV?.absolute}');
                selectProfileCV();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryColor,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          imageCV != null ? "Change CV" : "Select CV",
                          style: const TextStyle(color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.04,
                  ),
                  (myProfile != null && myProfile!.profileResume != null)
                      ? InkWell(
                          onTap: () => DownloadUtil.downloadFile(
                              url: myProfile!.profileResume!),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor.withOpacity(0.2),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              CupertinoIcons.cloud_download,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Center(
              child: CustomElevatedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  label: 'Upload CV',
                  function: () async {
                    if (imageCV != null) {
                      setState(() {
                        loadingStatus = true;
                      });
                      MemberAPI.updateCV(
                              memberId: await getMemberId(),
                              profileResume: imageCV?.path)
                          .then((value) {
                        if (value == 'failed') {
                          setState(() {
                            loadingStatus = false;
                          });
                          showErrorToast("CV Update failed");
                          return;
                        }
                        if (value == 'successful') {
                          setState(() {
                            loadingStatus = false;
                          });
                          showNormalToast("CV has been uploaded successfully");
                        }
                      });
                    } else {
                      showErrorToast('Please select your CV to upload');
                    }
                  }),
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        loadingStatus
            ? const Align(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }

  Widget passwordsView() {
    return Form(
        key: formGlobalKeyPassword,
        child: ListView(
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
            const SizedBox(
              height: 26,
            ),
            CustomElevatedButton(
                label: "Submit",
                function: () {
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
                      'selectedCommunity ${_controllerCommunity.text}'
                      ''
                      'selectedMarital $selectedMarital'
                      'selectedEducation $selectedEducation '
                      'selectedOccupation $selectedOccupation '
                      'selectedProfession $selectedProfession,'
                      'branch $selectedBranchID'
                      '');
                  final DateTime? now = birthDate;
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  // final DateFormat formattedr = formatter.format(new DateTime. )
                  String? formatted;
                  if (birthDate != null) {
                    setState(() {
                      formatted = formatter.format(now!);
                    });
                  }
                  if (kDebugMode) {
                    print(formatted);
                  }
                  var password = _controllerPassword.text.trim();
                  var repeat_password = _controllerConfirmPassword.text.trim();
                  if (!formGlobalKeyPassword.currentState!.validate()) {
                    return;
                  } else if (password != repeat_password) {
                    showErrorSnackBar(context, 'Passwords must be the same');
                  } else if (password.length < 7) {
                    showErrorSnackBar(context,
                        'Passwords must contain at least 8 characters');
                  } else if (!password.contains(RegExp(r'[0-9]'))) {
                    showErrorSnackBar(context,
                        'This password is too common, add special symbols eg.!@#');
                  } else {
                    setState(() {
                      loading = true;
                    });
                    debugPrint(' value');
                    debugPrint('ProfileImage => ${imageFile?.path}'
                        ' profileResume:> ${imageCV?.path}'
                        ' profileIdentification:> ${imageIDCard?.path};');

                    showLoadingDialog(
                      context,
                      'Please wait, we are processing...',
                    );

                    MemberAPI.registerMemberWithImage(context,
                            profilePicture: imageFile?.path,
                            profileResume: imageCV?.path,
                            profileIdentification: imageIDCard?.path,
                            clientId: '',
                            branchId: '$selectedBranchID',
                            firstname: _controllerFirstName.text.trim(),
                            middlename: _controllerMiddleName.text.trim(),
                            surname: _controllerSurname.text,
                            gender: selectedGender == 'Male' ? 1 : 2,
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
                            electoralArea: selectedElectoralAreaID,
                            community: _controllerCommunity.text.trim(),
                            digitalAddress: '-',
                            hometown: '-',
                            occupation: selectedOccupationID,
                            disability: disabilityOption == 0 ? false : true,
                            maritalStatus: selectedMaritalID,
                            occupationalStatus: selectedOccupationID,
                            professionStatus: selectedProfessionID,
                            educationalStatus: selectedEducationID,
                            groupIds: selectedGroupIds(),
                            subgroupIds: selectedSubGroupIds(),
                            password: _controllerPassword.text.trim(),
                            confirm_password:
                                _controllerConfirmPassword.text.trim())
                        .then((value) {
                      // setState(() {
                      //   loading = false;
                      // });

                      Navigator.of(context).pop();
                      if (value == 'successful') {
                        showNormalToast("Update Successful");
                        Navigator.pop(context);
                      }
                    });
                  }
                }),
            const SizedBox(
              height: 26,
            ),
            loading
                ? const Align(
                    child: CircularProgressIndicator(),
                  )
                : Container()
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
          _getElectoralAreaList(
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

  selectCommunity(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedElectoralArea = value['name'];
          selectedElectoralAreaID = value['id'];
          debugPrint(
              'selectedCommunity $selectedElectoralArea, $selectedElectoralAreaID');
        });
      }
    });
  }

//  STATUSES
  selectMarital(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedMarital = value['name'];
          selectedMaritalID = value['id'];
          // debugPrint('selectedMaritalID $selectedMaritalID, $selectedMarital');
        });
      }
    });
  }

  selectEducation(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedEducation = value['name'];
          selectedEducationID = value['id'];
          debugPrint(
              'selectedEducationID $selectedEducationID, $selectedEducation');
        });
      }
    });
  }

  selectOccupation(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedOccupation = value['name'];
          selectedOccupationID = value['id'];
          debugPrint(
              'selectedOccupationID $selectedOccupationID, $selectedOccupation');
        });
      }
    });
  }

  selectProfession(options) {
    displayCustomDropDown(
            options: options, context: context, listItemsIsMap: true)
        .then((value) {
      if (value != null) {
        setState(() {
          selectedProfession = value['name'];
          selectedProfessionID = value['id'];
          debugPrint(
              'selectedProfessionID $selectedProfessionID, $selectedProfession');
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
          _getMemberGroups();
          _getMemberSubGroups();
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
}
