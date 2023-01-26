import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/Networks/location_api.dart';
import 'package:akwaaba/Networks/members_api.dart';
import 'package:akwaaba/Networks/profile_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/models/general/OrganisationType.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/country.dart';
import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/member_status.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/organization.dart';
import 'package:akwaaba/models/general/region.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admin/clocked_member.dart';

class MembersProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];
  List<OrganizationType> _organizationTypes = [];

  List<Country> _countries = [];
  List<Region> _regions = [];
  List<District> _districts = [];

  List<MemberStatus> _maritalStatuses = [];
  List<MemberStatus> _occupations = [];
  List<MemberStatus> _professions = [];
  List<MemberStatus> _educations = [];

  List<Member?> _individualMembers = [];
  List<int?> _selectedMemberIds = [];
  List<Member?> _tempIndividualMembers = [];
  List<Organization> _organizationalMembers = [];
  List<Organization?> _tempOrganizationalMembers = [];

  int totalIndMembers = 0;
  int totalMaleIndMembers = 0;
  int totalFemaleIndMembers = 0;

  int totalOrgs = 0;
  List<Organization?> totalRegOrgs = [];
  List<Organization?> totalUnRegOrgs = [];

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;
  MemberStatus? selectedMaritalStatus;
  MemberStatus? selectedOccupation;
  MemberStatus? selectedProfession;
  MemberStatus? selectedEducation;
  Country? selectedCountry;
  Region? selectedRegion;
  District? selectedDistrict;

  OrganizationType? selectOrganizationType;

  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  String? selectedStatus;

  bool? businessRegistered;

  BuildContext? _context;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  List<MemberStatus> get maritalStatuses => _maritalStatuses;
  List<MemberStatus> get professions => _professions;
  List<MemberStatus> get educations => _educations;
  List<MemberStatus> get occupations => _occupations;

  List<OrganizationType> get organizationTypes => _organizationTypes;
  List<Country> get countries => _countries;
  List<Region> get regions => _regions;
  List<District> get districts => _districts;

  List<Member?> get individualMembers => _individualMembers;
  List<int?> get selectedMemberIds => _selectedMemberIds;
  List<Organization?> get organizationalMembers => _organizationalMembers;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;

  BuildContext get currentContext => _context!;

  String? search = '';

  // pagination variables
  int _indPage = 1;
  int _orgPage = 1;
  bool hasNextPage = true;
  bool isFilter = false;

  late ScrollController indMembersScrollController = ScrollController()
    ..addListener(_loadMoreIndividualMembers);

  late ScrollController orgMembersScrollController = ScrollController()
    ..addListener(_loadMoreOrganizationalMembers);

  // late ScrollController attendeesScrollController = ScrollController()
  //   ..addListener(_loadMoreAttendees);

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setCurrentContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  setLoadingMore(bool loading) {
    _loadingMore = loading;
    notifyListeners();
  }

  // get list of branches
  Future<void> getBranches() async {
    try {
      _branches = await GroupAPI.getBranches();
      debugPrint('Branches: ${_branches.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of member categories
  Future<void> getMemberCategories() async {
    try {
      _memberCategories = await GroupAPI.getMemberCategories();
      debugPrint('Member Categories: ${_memberCategories.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error MC: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of groups
  Future<void> getGroups() async {
    try {
      var userBranch = await getUserBranch(currentContext);
      _groups = await GroupAPI.getGroups(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        memberCategoryId: selectedMemberCategory!.id!,
      );
      if (_groups.isNotEmpty) {
        selectedGroup = _groups[0];
      }
      debugPrint('Groups: ${_groups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error Group: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList({required bool isMember}) async {
    clearFilters(isMember: isMember);
    isMember ? getAllIndividualMembers() : getAllOrganizations();
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    try {
      _subGroups = await GroupAPI.getSubGroups(
        groupId: selectedGroup!.id!,
      );
      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error SubGroup: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get organization types
  Future<void> getOrganizationTypes() async {
    try {
      _organizationTypes = await MembersAPI.getOrganizationTypes();
      debugPrint('Org Types: ${_branches.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of coutries
  Future<void> getCoutries() async {
    try {
      _countries = await LocationAPI.getCountries();
      getRegions();
    } catch (err) {
      debugPrint('Error C: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of regions
  Future<void> getRegions() async {
    try {
      _regions = await LocationAPI.getRegions();
      getDistricts();
    } catch (err) {
      debugPrint('Error R: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of districts
  Future<void> getDistricts() async {
    try {
      _districts = await LocationAPI.getDistricts();
      getMaritalStatuses();
    } catch (err) {
      debugPrint('Error D: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of marital statuses
  Future<void> getMaritalStatuses() async {
    try {
      _maritalStatuses = await MembersAPI.getMaritalStatuses();
      getOccupations();
    } catch (err) {
      debugPrint('Error MS: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of occupations
  Future<void> getOccupations() async {
    try {
      _occupations = await MembersAPI.getOccupations();
      getProfessions();
    } catch (err) {
      debugPrint('Error Occupation: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of profession
  Future<void> getProfessions() async {
    try {
      _professions = await MembersAPI.getProfessions();
      getEducations();
    } catch (err) {
      setLoading(false);
      debugPrint('Error Prof: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of profession
  Future<void> getEducations() async {
    try {
      _educations = await MembersAPI.getEducations();
    } catch (err) {
      setLoading(false);
      debugPrint('Error Edu: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<String?> userType() async {
    return await SharedPrefs().getUserType();
  }

  // enable single profile editing
  Future<void> enableSingleProfileEditing({required int memberId}) async {
    try {
      var message = await ProfileAPI.enableProfileEditing(memberId: memberId);
      debugPrint('Message: $message');
      showNormalToast('Profile editing enabled');
      debugPrint('Message: $message');
    } catch (err) {
      debugPrint('Error ESPE: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // disable single profile editing
  Future<void> disableSingleProfileEditing({required int memberId}) async {
    try {
      var message = await ProfileAPI.disableProfileEditing(memberId: memberId);
      debugPrint('Message: $message');
      showNormalToast('Profile editing disabled');
    } catch (err) {
      debugPrint('Error DSPE: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // enable bulk profile editing
  Future<void> enableBulkProfileEditing() async {
    try {
      showLoadingDialog(currentContext);
      var message = await ProfileAPI.enableBulkProfileEditing(
        memberIds: _selectedMemberIds,
      );
      _selectedMemberIds.clear();
      Navigator.pop(currentContext);
      showNormalToast('Profile editing enabled');
      getAllIndividualMembers();
    } catch (err) {
      Navigator.pop(currentContext);
      debugPrint('Error DBPE: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // disable bulk profile editing
  Future<void> disableBulkProfileEditing() async {
    try {
      showLoadingDialog(currentContext);
      var message = await ProfileAPI.disableBulkProfileEditing(
        memberIds: _selectedMemberIds,
      );
      _selectedMemberIds.clear();
      Navigator.pop(currentContext);
      showNormalToast('Profile editing disabled');
      getAllIndividualMembers();
    } catch (err) {
      Navigator.pop(currentContext);
      debugPrint('Error DBPE: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of profession
  Future<void> getClientStatistics() async {
    try {
      var userBranch = await getUserBranch(currentContext);
      var response = await MembersAPI.getClientStatistics(
        currentBranchId:
            selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
      );
      // get individual members stats
      totalIndMembers = response.statistics!.allMembers!;
      totalMaleIndMembers = response.statistics!.allMales!;
      totalFemaleIndMembers = response.statistics!.allFemales!;
      // get organization members stats
      totalOrgs = response.statistics!.allOrganizations!;
    } catch (err) {
      debugPrint('Error Client Stats: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of profession
  Future<void> getMembersStatistics() async {
    try {
      var userBranch = await getUserBranch(currentContext);
      var response = await MembersAPI.getMemberStatistics(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
      );
      // get individual members stats
      totalIndMembers = response.totalIndividualMembers!;
      totalMaleIndMembers = response.totalIndividualMale!;
      totalFemaleIndMembers = response.totalIndividualFemale!;
      // get organization members stats
      totalOrgs = response.totalOrganizationMembers!;
    } catch (err) {
      debugPrint('Error Member Stats: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // initial loading of individual members
  Future<void> getAllIndividualMembers() async {
    _individualMembers.clear();
    try {
      setLoading(true);
      _indPage = 1;
      _individualMembers = await MembersAPI.getIndividualMembers(
        page: _indPage,
        branchId:
            selectedBranch == null ? null : selectedBranch!.id!.toString(),
        search: search!,
        groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? null : selectedSubGroup!.id!.toString(),
        startDate: selectedStartDate == null
            ? null
            : selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate == null
            ? null
            : selectedEndDate!.toIso8601String().substring(0, 10),
        // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
        // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
        memberCategoryId: selectedMemberCategory == null
            ? null
            : selectedMemberCategory!.id!.toString(),
        countryId:
            selectedCountry == null ? null : selectedCountry!.id!.toString(),
        regionId:
            selectedRegion == null ? null : selectedRegion!.id!.toString(),
        districtId:
            selectedDistrict == null ? null : selectedDistrict!.id!.toString(),
        //status: selectedStatus,
        maritalStatus: selectedMaritalStatus == null
            ? null
            : selectedMaritalStatus!.id!.toString(),
        occupationalStatus: selectedOccupation == null
            ? null
            : selectedOccupation!.id!.toString(),
        educationalStatus: selectedEducation == null
            ? null
            : selectedEducation!.id!.toString(),
        professionStatus: selectedProfession == null
            ? null
            : selectedProfession!.id!.toString(),
      );

      _tempIndividualMembers = _individualMembers;

      // totalMaleIndMembers = _tempIndividualMembers;

      // totalFemaleIndMembers = _tempIndividualMembers;

      // // get total members
      // totalIndMembers = _tempIndividualMembers.length;

      // // calc total males
      // totalMaleIndMembers = _tempIndividualMembers
      //     .where((member) => member!.gender == AppConstants.male)
      //     .toList();

      // // calc total females
      // totalFemaleIndMembers = _tempIndividualMembers
      //     .where((member) => member!.gender == AppConstants.female)
      //     .toList();

      // check user type ('admin', 'member')
      if (await userType() == AppConstants.admin) {
        getClientStatistics();
      } else {
        getMembersStatistics();
      }

      debugPrint('Ind Members: ${_individualMembers.length}');

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Absentees: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of individual members
  Future<void> _loadMoreIndividualMembers() async {
    if (hasNextPage == true &&
        loading == false &&
        _loadingMore == false &&
        indMembersScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _indPage += 1; // increase page by 1
      try {
        var members = await MembersAPI.getIndividualMembers(
          page: _indPage,
          branchId:
              selectedBranch == null ? null : selectedBranch!.id!.toString(),
          search: search!,
          groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
          subGroupId: selectedSubGroup == null
              ? null
              : selectedSubGroup!.id!.toString(),
          startDate: selectedStartDate == null
              ? null
              : selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate == null
              ? null
              : selectedEndDate!.toIso8601String().substring(0, 10),
          // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
          // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
          memberCategoryId: selectedMemberCategory == null
              ? null
              : selectedMemberCategory!.id!.toString(),
          countryId:
              selectedCountry == null ? null : selectedCountry!.id!.toString(),
          regionId:
              selectedRegion == null ? null : selectedRegion!.id!.toString(),
          districtId: selectedDistrict == null
              ? null
              : selectedDistrict!.id!.toString(),
          // status: selectedStatus,
          maritalStatus: selectedMaritalStatus == null
              ? null
              : selectedMaritalStatus!.id!.toString(),
          occupationalStatus: selectedOccupation == null
              ? null
              : selectedOccupation!.id!.toString(),
          educationalStatus: selectedEducation == null
              ? null
              : selectedEducation!.id!.toString(),
          professionStatus: selectedProfession == null
              ? null
              : selectedProfession!.id!.toString(),
        );
        if (members.isNotEmpty) {
          _individualMembers.addAll(members);

          _tempIndividualMembers.addAll(_individualMembers);

          // get total members
          //totalIndMembers += _tempIndividualMembers.length;

          // totalMaleIndMembers.addAll(_tempIndividualMembers);

          // totalFemaleIndMembers.addAll(_tempIndividualMembers);

          // // calc rest of the total males
          // totalMaleIndMembers
          //     .removeWhere((member) => member!.gender == AppConstants.female);
          // totalFemaleIndMembers
          //     .removeWhere((member) => member!.gender == AppConstants.male);

          // for (var member in _tempIndividualMembers) {
          //   if (member!.gender == AppConstants.male) {
          //     totalMaleIndMembers.add(member);
          //   }
          // }

          // debugPrint("Total members: $totalIndMembers");

          // debugPrint("Total males: $totalMaleIndMembers");

          // debugPrint("Total females: $totalFemaleIndMembers");
        } else {
          hasNextPage = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("error --> $err");
      }
    }
    notifyListeners();
  }

  // initial loading of organizational members
  Future<void> getAllOrganizations() async {
    _organizationalMembers.clear();
    try {
      setLoading(true);
      _orgPage = 1;
      _organizationalMembers = await MembersAPI.getOrganizationalMembers(
        page: _orgPage,
        branchId:
            selectedBranch == null ? null : selectedBranch!.id!.toString(),
        search: search!,
        groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? null : selectedSubGroup!.id!.toString(),
        startDate: selectedStartDate == null
            ? null
            : selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate == null
            ? null
            : selectedEndDate!.toIso8601String().substring(0, 10),
        // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
        // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
        memberCategoryId: selectedMemberCategory == null
            ? null
            : selectedMemberCategory!.id!.toString(),
        countryId:
            selectedCountry == null ? null : selectedCountry!.id!.toString(),
        regionId:
            selectedRegion == null ? null : selectedRegion!.id!.toString(),
        districtId:
            selectedDistrict == null ? null : selectedDistrict!.id!.toString(),
        // status: selectedStatus,
        maritalStatus: selectedMaritalStatus == null
            ? null
            : selectedMaritalStatus!.id!.toString(),
        occupationalStatus: selectedOccupation == null
            ? null
            : selectedOccupation!.id!.toString(),
        educationalStatus: selectedEducation == null
            ? null
            : selectedEducation!.id!.toString(),
        professionStatus: selectedProfession == null
            ? null
            : selectedProfession!.id!.toString(),
        organizationType: selectOrganizationType == null
            ? null
            : selectOrganizationType!.id!.toString(),
        businessRegistered: businessRegistered,
      );

      _tempOrganizationalMembers = _organizationalMembers;

      // check user type ('admin', 'member')
      if (await userType() == AppConstants.admin) {
        getClientStatistics();
      } else {
        getMembersStatistics();
      }

      totalRegOrgs = _tempOrganizationalMembers;

      totalUnRegOrgs = _tempOrganizationalMembers;

      // calc total registered organizations
      totalRegOrgs = _tempOrganizationalMembers
          .where((org) => org!.businessRegistered!)
          .toList();

      // calc total unregistered organizations
      totalUnRegOrgs = _tempOrganizationalMembers
          .where((org) => !org!.businessRegistered!)
          .toList();

      debugPrint('Org Members: ${_organizationalMembers.length}');

      debugPrint("Total reg: ${totalRegOrgs.length}");

      debugPrint("Total unreg: ${totalUnRegOrgs.length}");

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Absentees: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of organizational members
  Future<void> _loadMoreOrganizationalMembers() async {
    if (hasNextPage == true &&
        loading == false &&
        _loadingMore == false &&
        orgMembersScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _orgPage += 1; // increase page by 1
      try {
        var members = await MembersAPI.getOrganizationalMembers(
          page: _orgPage,
          branchId:
              selectedBranch == null ? null : selectedBranch!.id!.toString(),
          search: search!,
          groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
          subGroupId: selectedSubGroup == null
              ? null
              : selectedSubGroup!.id!.toString(),
          startDate: selectedStartDate == null
              ? null
              : selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate == null
              ? null
              : selectedEndDate!.toIso8601String().substring(0, 10),
          // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
          // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
          memberCategoryId: selectedMemberCategory == null
              ? null
              : selectedMemberCategory!.id!.toString(),
          countryId:
              selectedCountry == null ? null : selectedCountry!.id!.toString(),
          regionId:
              selectedRegion == null ? null : selectedRegion!.id!.toString(),
          districtId: selectedDistrict == null
              ? null
              : selectedDistrict!.id!.toString(),
          // status: selectedStatus,
          maritalStatus: selectedMaritalStatus == null
              ? null
              : selectedMaritalStatus!.id!.toString(),
          occupationalStatus: selectedOccupation == null
              ? null
              : selectedOccupation!.id!.toString(),
          educationalStatus: selectedEducation == null
              ? null
              : selectedEducation!.id!.toString(),
          professionStatus: selectedProfession == null
              ? null
              : selectedProfession!.id!.toString(),
          organizationType: selectOrganizationType == null
              ? null
              : selectOrganizationType!.id!.toString(),
          businessRegistered: businessRegistered,
        );
        if (members.isNotEmpty) {
          _organizationalMembers.addAll(members);

          _tempOrganizationalMembers.addAll(_organizationalMembers);

          // get total organizations
          totalOrgs += _tempOrganizationalMembers.length;

          totalRegOrgs.addAll(_tempOrganizationalMembers);

          totalUnRegOrgs.addAll(_tempOrganizationalMembers);

          // calc rest of the total registered organizations
          totalRegOrgs.removeWhere((org) => org!.businessRegistered!);

          // calc rest of the total unregistered organizations
          totalUnRegOrgs.removeWhere((org) => !org!.businessRegistered!);

          debugPrint("Total reg: ${totalRegOrgs.length}");

          debugPrint("Total unreg: ${totalUnRegOrgs.length}");
        } else {
          hasNextPage = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("error --> $err");
      }
    }
    notifyListeners();
  }

  void clearFilters({required bool isMember}) {
    selectedGroup = null;
    selectedSubGroup = null;
    selectedStartDate = null;
    selectedEndDate = null;
    selectedMaritalStatus = null;
    selectedOccupation = null;
    selectedProfession = null;
    selectedEducation = null;
    selectedMemberCategory = null;
    selectedCountry = null;
    selectedRegion = null;
    selectedDistrict = null;
    selectedStatus = null;
    minAgeTEC.clear();
    maxAgeTEC.clear();
    isFilter = false;
    businessRegistered = null;
    selectOrganizationType = null;
    isMember ? getAllIndividualMembers() : getAllOrganizations();
    notifyListeners();
  }

  void validateFilterFields({required bool isMember}) {
    if (selectedGroup != null ||
        selectedSubGroup != null ||
        selectedStartDate != null ||
        selectedEndDate != null ||
        selectedMemberCategory != null ||
        selectedCountry != null ||
        selectedRegion != null ||
        selectedDistrict != null ||
        selectedStatus != null ||
        selectedMaritalStatus != null ||
        selectedOccupation != null ||
        selectedProfession != null ||
        selectedEducation != null ||
        selectedStatus != null ||
        businessRegistered != null ||
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      isMember ? getAllIndividualMembers() : getAllOrganizations();
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  void clearData() {
    //clearFilters(isMember: true);
    _individualMembers.clear();
    _organizationalMembers.clear();
  }
}