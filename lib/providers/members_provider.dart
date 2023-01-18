import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/Networks/members_api.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/marital_status.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
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

  List<MaritalStatus> _maritalStatuses = [];
  List<MaritalStatus> _occupations = [];
  List<MaritalStatus> _professions = [];
  List<MaritalStatus> _educations = [];

  List<Member?> _individualMembers = [];

  List<Member?> _organizationalMembers = [];

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;
  MaritalStatus? selectedMaritalStatus;
  MaritalStatus? selectedOccupation;
  MaritalStatus? selectedProfession;
  MaritalStatus? selectedEducation;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  List<MaritalStatus> get maritalStatuses => _maritalStatuses;
  List<MaritalStatus> get professions => _professions;
  List<MaritalStatus> get educations => _educations;
  List<MaritalStatus> get occupations => _occupations;

  List<Member?> get individualMembers => _individualMembers;
  List<Member?> get organizationalMembers => _organizationalMembers;

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
      if (_branches.isNotEmpty) {
        selectedBranch = _branches[0];
      }
      getGenders();
    } catch (err) {
      setLoading(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of genders
  Future<void> getGenders() async {
    try {
      _genders = await GroupAPI.getGenders();
      debugPrint('Genders: ${_genders.length}');
      //selectedGender = _genders[0];
      // getMemberCategories();
    } catch (err) {
      setLoading(false);
      debugPrint('Error Gender: ${err.toString()}');
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

  Future<void> refreshList() async {
    clearFilters();
    getAllIndividualMembers();
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    try {
      _subGroups = await GroupAPI.getSubGroups(
          // branchId: selectedCurrentMeeting.branchId!,
          // memberCategoryId: selectedMemberCategory!.id!,
          );
      getMaritalStatuses();
      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error SubGroup: ${err.toString()}');
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

      debugPrint('Ind Members: ${_individualMembers.length}');

      if (!isFilter) {
        getAllOrganizationalMembers();
      }

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
  Future<void> getAllOrganizationalMembers() async {
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

      debugPrint('Org Members: ${_organizationalMembers.length}');

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
        indMembersScrollController.position.extentAfter < 300) {
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

  void clearFilters() {
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMaritalStatus = null;
    selectedOccupation = null;
    selectedProfession = null;
    selectedEducation = null;
    isFilter = false;
    getAllIndividualMembers();
    notifyListeners();
  }

  void validateFilterFields({required int selectedIndex}) {
    if (selectedGroup != null ||
        selectedSubGroup != null ||
        selectedMaritalStatus != null ||
        selectedOccupation != null ||
        selectedProfession != null ||
        selectedEducation != null) {
      selectedIndex == 0
          ? getAllIndividualMembers()
          : getAllOrganizationalMembers();
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  void clearData() {
    clearFilters();
    isFilter = false;
    _individualMembers.clear();
    _organizationalMembers.clear();
  }
}
