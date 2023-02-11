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
import 'package:akwaaba/models/general/restricted_member.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/member_provider.dart';
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
  bool _loadingFilters = false;

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

  List<RestrictedMember?> _restrictedMembers = [];
  List<RestrictedMember?> _tempRestrictedMembers = [];
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

  final TextEditingController searchNameTEC = TextEditingController();
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

  List<RestrictedMember?> get restrictedMembers => _restrictedMembers;
  List<Member?> get individualMembers => _individualMembers;
  List<int?> get selectedMemberIds => _selectedMemberIds;
  List<Organization?> get organizationalMembers => _organizationalMembers;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get loadingFilters => _loadingFilters;

  BuildContext get currentContext => _context!;

  String? search = '';

  // pagination variables
  int _indPage = 1;
  int _orgPage = 1;
  bool hasNextPage = true;

  bool isFilter = false;

  late ScrollController restrictedMembersScrollController = ScrollController()
    ..addListener(_loadMoreRestrictedMembers);

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

  setLoadingFilters(bool loading) {
    _loadingFilters = loading;
    notifyListeners();
  }

  setLoadingMore(bool loading) {
    _loadingMore = loading;
    notifyListeners();
  }

  // get list of branches
  Future<void> getBranches() async {
    setLoadingFilters(true);
    try {
      _branches = await GroupAPI.getBranches();
      debugPrint('Branches: ${_branches.length}');
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of member categories
  Future<void> getMemberCategories() async {
    setLoadingFilters(true);
    try {
      _memberCategories = await GroupAPI.getMemberCategories();
      debugPrint('Member Categories: ${_memberCategories.length}');
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error MC: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of groups
  Future<void> getGroups() async {
    setLoadingFilters(true);
    try {
      var userBranch = await getUserBranch(currentContext);
      _groups = await GroupAPI.getGroups(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        memberCategoryId: selectedMemberCategory!.id!,
      );
      if (_groups.isNotEmpty) {
        selectedGroup = _groups[0];
      }
      setLoadingFilters(false);
      debugPrint('Groups: ${_groups.length}');
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Group: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList({
    required bool isMember,
    required String userType,
  }) async {
    clearFilters(isMember: isMember);
    if (isMember) {
      if (userType == AppConstants.member) {
        getAllRestrictedMembers();
      } else {
        getAllIndividualMembers();
      }
    } else {
      getAllOrganizations();
    }
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    setLoadingFilters(true);
    try {
      selectedSubGroup = null;
      _subGroups = await GroupAPI.getSubGroups(
        groupId: selectedGroup!.id!,
      );
      debugPrint('Sub Groups: ${_subGroups.length}');
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error SubGroup: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get organization types
  Future<void> getOrganizationTypes() async {
    setLoadingFilters(true);
    try {
      _organizationTypes = await MembersAPI.getOrganizationTypes();
      debugPrint('Org Types: ${_branches.length}');
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of coutries
  Future<void> getCoutries() async {
    setLoadingFilters(true);
    try {
      _countries = await LocationAPI.getCountries();
      getRegions();
    } catch (err) {
      setLoadingFilters(false);
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
      setLoadingFilters(false);
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
      setLoadingFilters(false);
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
      setLoadingFilters(false);
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
      setLoadingFilters(false);
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
      setLoadingFilters(false);

      debugPrint('Error Prof: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of profession
  Future<void> getEducations() async {
    try {
      _educations = await MembersAPI.getEducations();
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
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
      if (currentContext.mounted) Navigator.pop(currentContext);
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
      if (currentContext.mounted) Navigator.pop(currentContext);
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

  // get list of retricted members, a currently logged in member can view
  Future<void> getAllRestrictedMembers() async {
    try {
      setLoading(true);
      _indPage = 1;
      var memberId =
          await Provider.of<MemberProvider>(currentContext, listen: false)
              .memberProfile
              .user
              .id;
      var response = await MembersAPI.getRestrictedMembers(
        page: _indPage,
        memberId: memberId,
        search: search ?? '',
      );
      _restrictedMembers = response.results!;

      hasNextPage = response.next == null ? false : true;
      //_tempRestrictedMembers = _restrictedMembers;
      // get individual members stats
      getMembersStatistics();
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Member Stats: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of restricted members
  Future<void> _loadMoreRestrictedMembers() async {
    if (hasNextPage &&
        (restrictedMembersScrollController.position.pixels ==
            restrictedMembersScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _indPage += 1; // increase page by 1
      try {
        var memberId =
            await Provider.of<MemberProvider>(currentContext, listen: false)
                .memberProfile
                .user
                .id;
        var response = await MembersAPI.getRestrictedMembers(
            page: _indPage, memberId: memberId, search: search ?? '');
        if (response.results!.isNotEmpty) {
          hasNextPage = response.next == null ? false : true;
          _restrictedMembers.addAll(response.results!);
          //_tempRestrictedMembers.addAll(members);
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

  // initial loading of individual members
  Future<void> getAllIndividualMembers() async {
    try {
      setLoading(true);
      _indPage = 1;
      var response = await MembersAPI.getIndividualMembers(
        page: _indPage,
        branchId: selectedBranch == null ? '' : selectedBranch!.id!.toString(),
        search: search ?? '',
        groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
        startDate: selectedStartDate == null
            ? ''
            : selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate == null
            ? ''
            : selectedEndDate!.toIso8601String().substring(0, 10),
        // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
        // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
        memberCategoryId: selectedMemberCategory == null
            ? ''
            : selectedMemberCategory!.id!.toString(),
        countryId:
            selectedCountry == null ? '' : selectedCountry!.id!.toString(),
        regionId: selectedRegion == null ? '' : selectedRegion!.id!.toString(),
        districtId:
            selectedDistrict == null ? '' : selectedDistrict!.id!.toString(),
        //status: selectedStatus,
        maritalStatus: selectedMaritalStatus == null
            ? ''
            : selectedMaritalStatus!.id!.toString(),
        occupationalStatus: selectedOccupation == null
            ? ''
            : selectedOccupation!.id!.toString(),
        educationalStatus:
            selectedEducation == null ? '' : selectedEducation!.id!.toString(),
        professionStatus: selectedProfession == null
            ? ''
            : selectedProfession!.id!.toString(),
      );

      _individualMembers = response.results!;

      hasNextPage = response.next == null ? false : true;

      //_tempIndividualMembers = _individualMembers;

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
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of individual members
  Future<void> _loadMoreIndividualMembers() async {
    if (hasNextPage &&
        (indMembersScrollController.position.pixels ==
            indMembersScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _indPage += 1; // increase page by 1
      try {
        var response = await MembersAPI.getIndividualMembers(
          page: _indPage,
          branchId:
              selectedBranch == null ? '' : selectedBranch!.id!.toString(),
          search: search ?? '',
          groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
          subGroupId:
              selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
          startDate: selectedStartDate == null
              ? ''
              : selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate == null
              ? ''
              : selectedEndDate!.toIso8601String().substring(0, 10),
          // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
          // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
          memberCategoryId: selectedMemberCategory == null
              ? ''
              : selectedMemberCategory!.id!.toString(),
          countryId:
              selectedCountry == null ? '' : selectedCountry!.id!.toString(),
          regionId:
              selectedRegion == null ? '' : selectedRegion!.id!.toString(),
          districtId:
              selectedDistrict == null ? '' : selectedDistrict!.id!.toString(),
          // status: selectedStatus,
          maritalStatus: selectedMaritalStatus == null
              ? ''
              : selectedMaritalStatus!.id!.toString(),
          occupationalStatus: selectedOccupation == null
              ? ''
              : selectedOccupation!.id!.toString(),
          educationalStatus: selectedEducation == null
              ? ''
              : selectedEducation!.id!.toString(),
          professionStatus: selectedProfession == null
              ? ''
              : selectedProfession!.id!.toString(),
        );
        if (response.results!.isNotEmpty) {
          hasNextPage = response.next == null ? false : true;
          _individualMembers.addAll(response.results!);
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
    setLoading(true);
    try {
      _orgPage = 1;
      var response = await MembersAPI.getOrganizationalMembers(
        page: _orgPage,
        branchId: selectedBranch == null ? '' : selectedBranch!.id!.toString(),
        search: searchNameTEC.text.isEmpty ? '' : searchNameTEC.text,
        groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
        startDate: selectedStartDate == null
            ? ''
            : selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate == null
            ? ''
            : selectedEndDate!.toIso8601String().substring(0, 10),
        // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
        // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
        memberCategoryId: selectedMemberCategory == null
            ? ''
            : selectedMemberCategory!.id!.toString(),
        countryId:
            selectedCountry == null ? '' : selectedCountry!.id!.toString(),
        regionId: selectedRegion == null ? '' : selectedRegion!.id!.toString(),
        districtId:
            selectedDistrict == null ? '' : selectedDistrict!.id!.toString(),
        // status: selectedStatus,
        maritalStatus: selectedMaritalStatus == null
            ? ''
            : selectedMaritalStatus!.id!.toString(),
        occupationalStatus: selectedOccupation == null
            ? ''
            : selectedOccupation!.id!.toString(),
        educationalStatus:
            selectedEducation == null ? '' : selectedEducation!.id!.toString(),
        professionStatus: selectedProfession == null
            ? ''
            : selectedProfession!.id!.toString(),
        organizationType: selectOrganizationType == null
            ? ''
            : selectOrganizationType!.id!.toString(),
        businessRegistered: businessRegistered,
      );

      _organizationalMembers = response.results!;

      hasNextPage = response.next == null ? false : true;

      //_tempOrganizationalMembers = _organizationalMembers;

      // check user type ('admin', 'member')
      if (await userType() == AppConstants.admin) {
        getClientStatistics();
      } else {
        getMembersStatistics();
      }

      totalRegOrgs = _organizationalMembers;

      totalUnRegOrgs = _organizationalMembers;

      // calc total registered organizations
      totalRegOrgs = _organizationalMembers
          .where((org) => org.businessRegistered!)
          .toList();

      // calc total unregistered organizations
      totalUnRegOrgs = _organizationalMembers
          .where((org) => !org.businessRegistered!)
          .toList();

      debugPrint('Org Members: ${_organizationalMembers.length}');

      debugPrint("Total reg: ${totalRegOrgs.length}");

      debugPrint("Total unreg: ${totalUnRegOrgs.length}");

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Absentees: ${err.toString()}');
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of organizational members
  Future<void> _loadMoreOrganizationalMembers() async {
    if (hasNextPage &&
        (orgMembersScrollController.position.pixels ==
            orgMembersScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _orgPage += 1; // increase page by 1
      try {
        var response = await MembersAPI.getOrganizationalMembers(
          page: _orgPage,
          branchId:
              selectedBranch == null ? '' : selectedBranch!.id!.toString(),
          search: searchNameTEC.text.isEmpty ? '' : searchNameTEC.text,
          groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
          subGroupId:
              selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
          startDate: selectedStartDate == null
              ? ''
              : selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate == null
              ? ''
              : selectedEndDate!.toIso8601String().substring(0, 10),
          // fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
          // toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
          memberCategoryId: selectedMemberCategory == null
              ? ''
              : selectedMemberCategory!.id!.toString(),
          countryId:
              selectedCountry == null ? '' : selectedCountry!.id!.toString(),
          regionId:
              selectedRegion == null ? '' : selectedRegion!.id!.toString(),
          districtId:
              selectedDistrict == null ? '' : selectedDistrict!.id!.toString(),
          // status: selectedStatus,
          maritalStatus: selectedMaritalStatus == null
              ? ''
              : selectedMaritalStatus!.id!.toString(),
          occupationalStatus: selectedOccupation == null
              ? ''
              : selectedOccupation!.id!.toString(),
          educationalStatus: selectedEducation == null
              ? ''
              : selectedEducation!.id!.toString(),
          professionStatus: selectedProfession == null
              ? ''
              : selectedProfession!.id!.toString(),
          organizationType: selectOrganizationType == null
              ? ''
              : selectOrganizationType!.id!.toString(),
          businessRegistered: businessRegistered,
        );
        if (response.results!.isNotEmpty) {
          hasNextPage = response.next == null ? false : true;

          _organizationalMembers.addAll(response.results!);

          //_tempOrganizationalMembers.addAll(_organizationalMembers);

          totalRegOrgs.addAll(response.results!);

          totalUnRegOrgs.addAll(response.results!);

          debugPrint("Total reg: ${totalRegOrgs.length}");

          debugPrint("Total unreg: ${totalUnRegOrgs.length}");

          // calc rest of the total registered organizations
          totalRegOrgs.removeWhere((org) => !org!.businessRegistered!);

          // calc rest of the total unregistered organizations
          totalUnRegOrgs.removeWhere((org) => org!.businessRegistered!);
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
    selectedBranch = null;
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
    selectOrganizationType == null;
    minAgeTEC.clear();
    maxAgeTEC.clear();
    search = '';
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

  // search through attendees list by name
  void searchRestrictedMembers({required String searchText}) {
    List<RestrictedMember?> results = [];
    if (searchText.isEmpty) {
      results = _tempRestrictedMembers;
    } else {
      results = _tempRestrictedMembers
          .where((restrictedMember) =>
              restrictedMember!.member!.firstname
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              restrictedMember.member!.surname
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              restrictedMember.member!.identification
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _restrictedMembers = results;
    notifyListeners();
  }

  void clearData() {
    //clearFilters(isMember: true);
    _individualMembers.clear();
    _organizationalMembers.clear();
  }
}
