import 'package:akwaaba/Networks/api_responses/attendance_history_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/messaging_type.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<MessagingType> _messagingTypes = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];

  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  List<AttendanceHistory?> _attendanceHistory = [];

  List<AttendanceHistory?> _tempAttendanceHistory = [];

  List<MeetingEventModel> _pastMeetingEvents = [];

  List<MeetingEventModel> get pastMeetingEvents => _pastMeetingEvents;

  MeetingEventModel? selectedPastMeetingEvent;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MessagingType> get messagingTypes => _messagingTypes;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  BuildContext? _context;
  String? search = '';

  List<AttendanceHistory?> get attendanceRecords => _attendanceHistory;

  String selectedStatus = 'Active';

  List<String> statuses = ['Active', 'Inactive', 'Both'];

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;

  BuildContext get currentContext => _context!;

  // pagination variables
  int _page = 1;
  var limit = AppConstants.pageLimit;
  var isFirstLoadRunning = false;
  var hasNextPage = true;
  var isLoadMoreRunning = false;

  late ScrollController historyScrollController = ScrollController()
    ..addListener(_loadMoreAttendanceHistory);

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setLoadingMore(bool loading) {
    _loadingMore = loading;
    notifyListeners();
  }

  setCurrentContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

// get current date and format for filtering
  String getFilterDate() {
    final filterDate =
        DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
            .substring(0, 10)
            .trim();
    return filterDate;
  }

  // get list of member categories
  Future<void> getMemberCategories() async {
    try {
      _memberCategories = await GroupAPI.getMemberCategories();
      debugPrint('Member Categories: ${_memberCategories.length}');
      getSubGroups();
    } catch (err) {
      setLoading(false);
      debugPrint('Error MC: ${err.toString()}');
      showErrorToast(err.toString());
    }
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
      getGroups();
      // getGenders();
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
        branchId: selectedBranch == null
            ? selectedPastMeetingEvent!.branchId!
            : selectedBranch!.id!,
      );
      debugPrint('Groups: ${_groups.length}');
      // selectedGroup = _groups[0];

    } catch (err) {
      setLoading(false);
      debugPrint('Error Group: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList() async {
    if (selectedPastMeetingEvent == null) {
      showErrorToast('Please select a date and meeting or event to proceed');
      return;
    }
    search = '';
    await getAttendanceHistory();
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    if (selectedMemberCategory != null) {
      try {
        _subGroups = await GroupAPI.getSubGroups(
          branchId: selectedBranch == null
              ? selectedPastMeetingEvent!.branchId!
              : selectedBranch!.id!,
          memberCategoryId: selectedMemberCategory!.id!,
        );

        debugPrint('Sub Groups: ${_subGroups.length}');
      } catch (err) {
        setLoading(false);
        debugPrint('Error SubGroup: ${err.toString()}');
        showErrorToast(err.toString());
      }
    }
    notifyListeners();
  }

  // get meetins from date specified
  Future<void> getPastMeetingEvents() async {
    try {
      _pastMeetingEvents = await EventAPI.getMeetingsFromDate(
        date: selectedStartDate!.toIso8601String().substring(0, 10),
      );
      if (_pastMeetingEvents.isNotEmpty) {
        selectedPastMeetingEvent = _pastMeetingEvents[0];
        getMemberCategories();
      } else {
        showInfoDialog(
          'ok',
          context: _context!,
          title: 'Sorry!',
          content:
              'No meetings/events were held on this date. \nPlease try again with another date.',
          onTap: () => Navigator.pop(_context!),
        );
      }
      //getGenders();
      //getGroups();
    } catch (err) {
      debugPrint('Error PMs: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void validateFilterFields(context) {
    if ((selectedStartDate != null && selectedEndDate != null) ||
        selectedPastMeetingEvent != null ||
        selectedBranch != null ||
        selectedMemberCategory != null ||
        selectedGender != null ||
        selectedGroup != null ||
        selectedSubGroup != null ||
        selectedStatus.isNotEmpty ||
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      getAttendanceHistory();
    } else if (selectedPastMeetingEvent == null) {
      showErrorToast('Please select a meeting or event to contitue');
    } else {
      showErrorToast('Please select start and end date to proceed');
    }
  }

  // get attendance history for a meeting
  Future<void> getAttendanceHistory() async {
    setLoading(true);
    try {
      _page = 1;
      var response = await AttendanceAPI.getAttendanceHistory(
        page: _page,
        meetingEventModel: selectedPastMeetingEvent!,
        branchId: selectedBranch == null
            ? selectedPastMeetingEvent!.branchId!
            : selectedBranch!.id!,
        startDate: selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate!.toIso8601String().substring(0, 10),
        search: search ?? '',
        status: selectedStatus == 'Both' ? '' : selectedStatus,
        memberCategoryId: selectedMemberCategory == null
            ? null
            : selectedMemberCategory!.id!.toString(),
        groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? null : selectedSubGroup!.id!.toString(),
        genderId:
            selectedGender == null ? null : selectedGender!.id!.toString(),
        fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
        toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
      );

      if (response.results!.isNotEmpty) {
        // filter list for only members excluding
        // admin if he is also a member
        _attendanceHistory = response.results!;

        _tempAttendanceHistory = _attendanceHistory;

        debugPrint('Attendance History: ${_attendanceHistory.length}');
      }

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error AH: ${err.toString()}');
      //showErrorToast('No records found');
    }
    notifyListeners();
  }

  // get more attendance history for a meeting
  Future<void> _loadMoreAttendanceHistory() async {
    if (hasNextPage == true &&
        loading == false &&
        isLoadMoreRunning == false &&
        historyScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _page += 1;
      try {
        var response = await AttendanceAPI.getAttendanceHistory(
          page: _page,
          meetingEventModel: selectedPastMeetingEvent!,
          branchId: selectedBranch == null
              ? selectedPastMeetingEvent!.branchId!
              : selectedBranch!.id!,
          startDate: selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate!.toIso8601String().substring(0, 10),
          search: search ?? '',
          status: selectedStatus == 'Both' ? '' : selectedStatus,
          memberCategoryId: selectedMemberCategory == null
              ? null
              : selectedMemberCategory!.id!.toString(),
          groupId: selectedGroup == null ? null : selectedGroup!.id!.toString(),
          subGroupId: selectedSubGroup == null
              ? null
              : selectedSubGroup!.id!.toString(),
          genderId:
              selectedGender == null ? null : selectedGender!.id!.toString(),
          fromAge: minAgeTEC.text.isEmpty ? null : minAgeTEC.text,
          toAge: maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text,
          // fromAge: int.parse(minAgeTEC.text.isEmpty ? null : minAgeTEC.text),
          // toAge: int.parse(maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text),
        );

        if (response.results!.isNotEmpty) {
          _attendanceHistory.addAll(response.results!);

          _tempAttendanceHistory.addAll(_attendanceHistory);

          debugPrint('Attendance History: ${_attendanceHistory.length}');
        } else {
          hasNextPage = false;
        }

        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint('Error AH: ${err.toString()}');
        //showErrorToast(err.toString());
      }
    }
    notifyListeners();
  }

  void clearFilters() {
    selectedStartDate = null;
    selectedEndDate = null;
    selectedBranch = null;
    selectedGender = null;
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMemberCategory = null;
    selectedPastMeetingEvent = null;
    search = '';
    minAgeTEC.clear();
    maxAgeTEC.clear();
    notifyListeners();
  }

  Future<void> clearData() async {
    clearFilters();
    search = '';
    _attendanceHistory.clear();
    _tempAttendanceHistory.clear();
  }
}