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
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;
  bool _loadingFilters = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<MessagingType> _messagingTypes = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];
  List<int> _selectedMeetingEventIndexes = [];

  List<Map<String, dynamic>> _tempMeetingEventMap =
      []; // store key -value pair with the index of meeting and meeting id

  final TextEditingController searchNameTEC = TextEditingController();
  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  List<AttendanceHistory?> _attendanceHistory = [];

  List<AttendanceHistory?> _tempAttendanceHistory = [];

  List<MeetingEventModel> _pastMeetingEvents = [];

  List<MeetingEventModel> get pastMeetingEvents => _pastMeetingEvents;

  List<int> get selectedMeetingEventIndexes => _selectedMeetingEventIndexes;

  List<Map<String, dynamic>> get tempMeetingEventMap => _tempMeetingEventMap;

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
  String? memberId = '';

  List<AttendanceHistory?> get attendanceRecords => _attendanceHistory;

  String selectedStatus = 'Both';

  List<String> statuses = [
    'Both',
    'Active',
    'Inactive',
  ];

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get loadingFilters => _loadingFilters;

  BuildContext get currentContext => _context!;

  // pagination variables
  int _page = 1;
  var limit = AppConstants.pageLimit;
  var isFirstLoadRunning = false;
  var hasNext = false;
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

  setLoadingFilters(bool loading) {
    _loadingFilters = loading;
    notifyListeners();
  }

  setCurrentContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  setSelectedMeetingEventIndexes(List<int> indexes) {
    _selectedMeetingEventIndexes = indexes;
    debugPrint(indexes.toString());
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
      getGenders();
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error MC: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of branches
  Future<void> getBranches() async {
    setLoadingFilters(true);
    try {
      _branches = await GroupAPI.getBranches();
      debugPrint('Branches: ${_branches.length}');
      if (_branches.isNotEmpty) {
        selectedBranch = _branches[0];
      }
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of genders
  Future<void> getGenders() async {
    try {
      _genders = await GroupAPI.getGenders();
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Gender: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of groups
  Future<void> getGroups() async {
    setLoadingFilters(true);
    try {
      selectedGroup = null;
      var userBranch = await getUserBranch(currentContext);
      _groups = await GroupAPI.getGroups(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        memberCategoryId: selectedMemberCategory!.id!,
      );
      setLoadingFilters(false);
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Group: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList() async {
    if (selectedMeetingEventIndexes.isEmpty ||
        selectedStartDate == null ||
        selectedEndDate == null) {
      showErrorToast('Please select a date and meeting or event to proceed');
      return;
    }
    search = '';
    await getAttendanceHistory();
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    if (selectedMemberCategory != null) {
      setLoadingFilters(true);
      try {
        selectedSubGroup = null;
        _subGroups = await GroupAPI.getSubGroups(groupId: selectedGroup!.id!);
        debugPrint('Sub Groups: ${_subGroups.length}');
        setLoadingFilters(false);
      } catch (err) {
        setLoadingFilters(false);
        debugPrint('Error SubGroup: ${err.toString()}');
        showErrorToast(err.toString());
      }
    }
    notifyListeners();
  }

  // get meetins from date specified
  Future<void> getAllMeetingEvents() async {
    setLoadingFilters(true);
    try {
      var userBranch = await getUserBranch(currentContext);
      var userType = await SharedPrefs().getUserType();
      debugPrint("BID: ${userBranch.name}");
      _pastMeetingEvents = await EventAPI.getAllMeetings(
        page: 1,
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
      );
      if (_pastMeetingEvents.isNotEmpty) {
        _tempMeetingEventMap.clear();
        for (int i = 0; i < _pastMeetingEvents.length; i++) {
          // create a new map with meeting index and id
          final Map<String, int> map = {
            'index': i,
            'meetingId': _pastMeetingEvents[i].id!,
          };
          _tempMeetingEventMap.add(map);
        }
      }
      if (userType == AppConstants.member) {
        setLoadingFilters(false);
      } else {
        getMemberCategories();
      }
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error PMs: ${err.toString()}');
      // showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void validateFilterFields(context) {
    if (selectedStartDate == null || selectedEndDate == null) {
      showErrorToast('Please select start and end date to proceed');
      return;
    }
    if (selectedMeetingIds().isEmpty) {
      showErrorToast('Please select a meeting or event to continue');
      return;
    }
    getAttendanceHistory();
  }

// get meeting ids from meeting map
  List<int> selectedMeetingIds() {
    List<int> ids = [];
    if (_tempMeetingEventMap.isNotEmpty) {
      for (var map in _tempMeetingEventMap) {
        if (selectedMeetingEventIndexes.contains(map['index'])) {
          ids.add(map['meetingId']);
        }
      }
    }
    return ids;
  }

  // get attendance history for a meeting
  Future<void> getAttendanceHistory() async {
    setLoading(true);
    var userBranch =
        await getUserBranch(currentContext); // get current user branch
    String? userType = await SharedPrefs().getUserType();

    // search with member name if account type is member else
    search = search!.isNotEmpty ? search! : '';

    memberId = userType == AppConstants.member
        ? Provider.of<MemberProvider>(_context!, listen: false)
            .memberProfile
            .user
            .id
            .toString()
        : '';

    try {
      _page = 1;
      var response = await AttendanceAPI.getAttendanceHistory(
        page: _page,
        meetingIds: selectedMeetingIds(),
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        startDate: selectedStartDate == null
            ? ''
            : selectedStartDate!.toIso8601String().substring(0, 10),
        endDate: selectedEndDate == null
            ? ''
            : selectedEndDate!.toIso8601String().substring(0, 10),
        search: search!,
        memberId: memberId,
        status: selectedStatus == 'Both'
            ? ''
            : selectedStatus == 'Active'
                ? 1.toString()
                : 0.toString(),
        memberCategoryId: selectedMemberCategory == null
            ? ''
            : selectedMemberCategory!.id!.toString(),
        groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
        subGroupId:
            selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
        genderId: selectedGender == null ? '' : selectedGender!.id!.toString(),
        fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
        toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
      );

      hasNext = response.next == null ? false : true;

      // filter list for only members excluding
      // admin if he is also a member
      _attendanceHistory = response.results!;

      _tempAttendanceHistory = _attendanceHistory;

      // debugPrint('Attendance History: ${_attendanceHistory.length}');

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
    if (hasNext &&
        (historyScrollController.position.pixels ==
            historyScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _page += 1;
      try {
        var userBranch =
            await getUserBranch(currentContext); // get current user branch
        var response = await AttendanceAPI.getAttendanceHistory(
          page: _page,
          meetingIds: selectedMeetingIds(),
          branchId:
              selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
          startDate: selectedStartDate == null
              ? ''
              : selectedStartDate!.toIso8601String().substring(0, 10),
          endDate: selectedEndDate == null
              ? ''
              : selectedEndDate!.toIso8601String().substring(0, 10),
          search: search!,
          memberId: memberId,
          status: selectedStatus == 'Both'
              ? ''
              : selectedStatus == 'Active'
                  ? 1.toString()
                  : 0.toString(),
          memberCategoryId: selectedMemberCategory == null
              ? ''
              : selectedMemberCategory!.id!.toString(),
          groupId: selectedGroup == null ? '' : selectedGroup!.id!.toString(),
          subGroupId:
              selectedSubGroup == null ? '' : selectedSubGroup!.id!.toString(),
          genderId:
              selectedGender == null ? '' : selectedGender!.id!.toString(),
          fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
          toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
          // fromAge: int.parse(minAgeTEC.text.isEmpty ? null : minAgeTEC.text),
          // toAge: int.parse(maxAgeTEC.text.isEmpty ? null : maxAgeTEC.text),
        );

        if (response.results!.isNotEmpty) {
          hasNext = response.next == null ? false : true;
          _attendanceHistory.addAll(response.results!);

          _tempAttendanceHistory.addAll(_attendanceHistory);

          //debugPrint('Attendance History: ${_attendanceHistory.length}');
        } else {
          hasNext = false;
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
    selectedStatus = 'Both';
    search = '';
    minAgeTEC.clear();
    maxAgeTEC.clear();
    _attendanceHistory.clear();
    _selectedMeetingEventIndexes.clear();
    notifyListeners();
  }

  Future<void> clearData() async {
    clearFilters();
    searchNameTEC.clear();
    _tempMeetingEventMap.clear();
    _pastMeetingEvents.clear();
    _attendanceHistory.clear();
    _tempAttendanceHistory.clear();
  }
}
