import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/Networks/location_api.dart';
import 'package:akwaaba/Networks/members_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
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
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/admin/clocked_member.dart';

class MembersProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];

  List<Country> _countries = [];
  List<Region> _regions = [];
  List<District> _districts = [];

  List<MemberStatus> _maritalStatuses = [];
  List<MemberStatus> _occupations = [];
  List<MemberStatus> _professions = [];
  List<MemberStatus> _educations = [];

  List<Member?> _individualMembers = [];
  List<Member?> _tempIndividualMembers = [];
  List<Organization> _organizationalMembers = [];
  List<Organization?> _tempOrganizationalMembers = [];

  int totalIndMembers = 0;
  List<Member?> totalMaleIndMembers = [];
  List<Member?> totalFemaleIndMembers = [];

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
  dynamic selectedCountry;
  dynamic selectedRegion;
  dynamic selectedDistrict;

  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  String? selectedStatus;

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

  List<Country> get countries => _countries;
  List<Region> get regions => _regions;
  List<District> get districts => _districts;

  List<Member?> get individualMembers => _individualMembers;
  List<Organization?> get organizationalMembers => _organizationalMembers;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;

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
      if (_memberCategories.isNotEmpty) {
        selectedMemberCategory = _memberCategories[0];
      }
      getGroups();
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
      _groups = await GroupAPI.getGroups(
          // branchId: selectedCurrentMeeting.branchId!,
          );
      debugPrint('Groups: ${_groups.length}');
      getSubGroups();
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
          // branchId: selectedCurrentMeeting.branchId!,
          // memberCategoryId: selectedMemberCategory!.id!,
          );
      getCoutries();
      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error SubGroup: ${err.toString()}');
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

      totalMaleIndMembers = _tempIndividualMembers;

      totalFemaleIndMembers = _tempIndividualMembers;

      // get total members
      totalIndMembers = _tempIndividualMembers.length;

      // calc total males
      totalMaleIndMembers = _tempIndividualMembers
          .where((member) => member!.gender == AppConstants.male)
          .toList();

      // calc total females
      totalFemaleIndMembers = _tempIndividualMembers
          .where((member) => member!.gender == AppConstants.female)
          .toList();

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
          totalIndMembers += _tempIndividualMembers.length;

          totalMaleIndMembers.addAll(_tempIndividualMembers);

          totalFemaleIndMembers.addAll(_tempIndividualMembers);

          // calc rest of the total males
          totalMaleIndMembers
              .removeWhere((member) => member!.gender == AppConstants.female);
          totalFemaleIndMembers
              .removeWhere((member) => member!.gender == AppConstants.male);

          // for (var member in _tempIndividualMembers) {
          //   if (member!.gender == AppConstants.male) {
          //     totalMaleIndMembers.add(member);
          //   }
          // }

          debugPrint("Total members: $totalIndMembers");

          debugPrint("Total males: ${totalMaleIndMembers.length}");

          // calc rest of the total females
          // for (var member in _tempIndividualMembers) {
          //   if (member!.gender == AppConstants.female) {
          //     totalFemaleIndMembers.add(member);
          //   }
          // }

          debugPrint("Total females: ${totalFemaleIndMembers.length}");
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
      );

      _tempOrganizationalMembers = _organizationalMembers;

      totalRegOrgs = _tempOrganizationalMembers;

      totalUnRegOrgs = _tempOrganizationalMembers;

      // get total organizations
      totalOrgs = _tempOrganizationalMembers.length;

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

          // calc rest of the total males
          // for (var member in _tempOrganizationalMembers) {
          //   if (member!.gender == AppConstants.male) {
          //     totalMaleOrgMembers.add(member);
          //   }
          // }

          debugPrint("Total reg: ${totalRegOrgs.length}");

          // calc rest of the total females
          // for (var member in _tempOrganizationalMembers) {
          //   if (member!.gender == AppConstants.female) {
          //     totalFemaleOrgMembers.add(member);
          //   }
          // }

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
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      isMember ? getAllIndividualMembers() : getAllOrganizations();
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  void clearData() {
    clearFilters(isMember: true);

    _individualMembers.clear();
    _organizationalMembers.clear();
  }
}
