import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/Networks/clocking_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/messaging_type.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;
  bool _clocking = false;
  bool _submitting = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<MessagingType> _messagingTypes = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];

  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();
  final TextEditingController followUpTEC = TextEditingController();

  List<Attendee?> _absentees = [];

  List<Attendee?> _tempAbsentees = [];

  final List<Attendee?> _selectedAbsentees = [];

  final List<int> _selectedClockingIds = [];

  List<Attendee?> _attendees = [];

  List<Attendee?> _tempAttendees = [];

  final List<Attendee?> _selectedAttendees = [];

  List<MeetingEventModel> _pastMeetingEvents = [];

  List<MeetingEventModel> get pastMeetingEvents => _pastMeetingEvents;

  MeetingEventModel? selectedPastMeetingEvent;
  DateTime? selectedDate;

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;
  MessagingType? selectedMessagingType;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MessagingType> get messagingTypes => _messagingTypes;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  int totalAttendees = 0;
  List<Attendee?> totalMaleAttendees = [];
  List<Attendee?> totalFemaleAttendees = [];

  int totalAbsentees = 0;
  List<Attendee?> totalMaleAbsentees = [];
  List<Attendee?> totalFemaleAbsentees = [];

  BuildContext? _context;
  String? search = '';

  List<Attendee?> get absentees => _absentees;

  List<Attendee?> get selectedAbsentees => _selectedAbsentees;

  List<Attendee?> get attendees => _attendees;

  List<Attendee?> get selectedAttendees => _selectedAttendees;

  List<int> get selectedClockingIds => _selectedClockingIds;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get clocking => _clocking;
  bool get submitting => _submitting;

  BuildContext get currentContext => _context!;

  // pagination variables
  int _absenteesPage = 1;
  int _attendeesPage = 1;
  var limit = AppConstants.pageLimit;
  var isFirstLoadRunning = false;
  var hasNextPage = true;
  var isLoadMoreRunning = false;

  String? userType;

  late ScrollController absenteesScrollController = ScrollController()
    ..addListener(_loadMoreAbsentees);

  late ScrollController attendeesScrollController = ScrollController()
    ..addListener(_loadMoreAttendees);

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setLoadingMore(bool loading) {
    _loadingMore = loading;
    notifyListeners();
  }

  setSubmitting(bool submitting) {
    _submitting = submitting;
    notifyListeners();
  }

  setClocking(bool clocking) {
    _clocking = clocking;
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

  // validate member attendance - single
  Future<void> validateMemberAttendance({required int clockingId}) async {
    try {
      showLoadingDialog(_context!);
      var response = await AttendanceAPI.validateMemberAttendance(
        clockingId: clockingId,
      );
      Navigator.of(_context!).pop();
      showNormalToast(response.message!);
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
    } catch (err) {
      Navigator.of(_context!).pop();
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // validate member attendances - bulk
  Future<void> validateMemberAttendances() async {
    try {
      debugPrint('ClockingIds: ${_selectedClockingIds.toString()}');
      showLoadingDialog(_context!);
      var message = await AttendanceAPI.validateMemberAttendances(
        clockingIds: _selectedClockingIds,
      );
      Navigator.of(_context!).pop();
      showNormalToast(message);
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
    } catch (err) {
      Navigator.of(_context!).pop();
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void validateFollowUpField({
    required int meetingEventId,
    required int clockingId,
  }) {
    if (followUpTEC.text.isEmpty) {
      showErrorToast('Please enter your follow-up message');
      return;
    }
    if (selectedMessagingType == null) {
      showErrorToast('Please select messaging type');
      return;
    }
    submitFollowUp(
      meetingEventId: meetingEventId,
      clockingId: clockingId,
      messagingType: selectedMessagingType!.id!,
      followUp: followUpTEC.text.trim(),
    );
  }

  // submit follow up
  Future<void> submitFollowUp({
    required int meetingEventId,
    required int clockingId,
    required int messagingType,
    required String followUp,
  }) async {
    try {
      setLoading(true);
      var message = await AttendanceAPI.submitFollowUp(
        meetingEventId: meetingEventId,
        clockingId: clockingId,
        messagingType: messagingType,
        followUp: followUp,
      );
      setLoading(false);
      followUpTEC.clear();
      Navigator.of(_context!).pop();
      showNormalToast(message);
    } catch (err) {
      setLoading(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of messaging types
  Future<void> getMessagingTypes({required int gender}) async {
    try {
      _messagingTypes = await AttendanceAPI.getMessagingTypes(gender: gender);
      debugPrint('Messaging Types: ${_messagingTypes.length}');
      getSubGroups();
    } catch (err) {
      setLoading(false);
      debugPrint('Error MT: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
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
    await getAllAttendees(
      meetingEventModel: selectedPastMeetingEvent!,
    );
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
        page: 1,
        date: selectedDate!.toIso8601String().substring(0, 10),
      );
      if (_pastMeetingEvents.isNotEmpty) {
        selectedPastMeetingEvent = _pastMeetingEvents[0];
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
      getGenders();
      getGroups();
    } catch (err) {
      debugPrint('Error PMs: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// reset stats data
  resetStatsData() {
    totalAbsentees = 0;
    totalAttendees = 0;
    totalMaleAttendees.clear();
    totalMaleAbsentees.clear();
    totalFemaleAttendees.clear();
    totalFemaleAbsentees.clear();
  }

  // get all attendees members for a meeting
  Future<void> getAllAttendees({
    required MeetingEventModel meetingEventModel,
  }) async {
    userType = await SharedPrefs().getUserType();
    setLoading(true);
    try {
      _attendeesPage = 1;
      var response = await ClockingAPI.getAttendeesList(
        page: _attendeesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null
            ? selectedPastMeetingEvent!.branchId!
            : selectedBranch!.id!,
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
        memberCategoryId:
            selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
        groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
        subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
        genderId: selectedGender == null ? 0 : selectedGender!.id!,
        fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
        toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
      );
      selectedAttendees.clear();

      resetStatsData();

      if (response.results!.isNotEmpty) {
        // get total number of attendees
        totalAttendees = response.count!;
        // filter list for only members excluding
        // admin if he is also a member
        _attendees = response.results!;

        _tempAttendees = _attendees;

        // calc total males
        totalMaleAttendees = _tempAttendees
            .where((attendee) =>
                attendee!.attendance!.memberId!.gender == AppConstants.male)
            .toList();

        // calc total females
        totalFemaleAttendees = _tempAttendees
            .where((attendee) =>
                attendee!.attendance!.memberId!.gender == AppConstants.female)
            .toList();

        debugPrint('Atendees: ${_attendees.length}');
      }

      getAllAbsentees(
        meetingEventModel: meetingEventModel,
      );

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint("Error Attendees --> $err");
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of absentees of past meeting
  Future<void> _loadMoreAttendees() async {
    if (hasNextPage == true &&
        loading == false &&
        isLoadMoreRunning == false &&
        attendeesScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _attendeesPage += 1; // increase page by 1
      try {
        var response = await ClockingAPI.getAttendeesList(
          page: _attendeesPage,
          meetingEventModel: selectedPastMeetingEvent!,
          branchId: selectedBranch == null
              ? selectedPastMeetingEvent!.branchId!
              : selectedBranch!.id!,
          filterDate: selectedDate == null
              ? getFilterDate()
              : selectedDate!.toIso8601String().substring(0, 10),
          memberCategoryId:
              selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
          groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
          subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
          genderId: selectedGender == null ? 0 : selectedGender!.id!,
          fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
          toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
        );
        if (response.results!.isNotEmpty) {
          _attendees.addAll(response.results!);

          _tempAttendees.addAll(_attendees);

          // calc rest of the total males
          for (var attendee in _tempAttendees) {
            if (attendee!.attendance!.memberId!.gender == AppConstants.male) {
              totalMaleAttendees.add(attendee);
            }
          }

          debugPrint("Total male attendees: ${totalMaleAttendees.length}");

          // calc rest of the total females
          for (var attendee in _tempAttendees) {
            if (attendee!.attendance!.memberId!.gender == AppConstants.female) {
              totalFemaleAttendees.add(attendee);
            }
          }

          debugPrint("Total female attendees: ${totalFemaleAttendees.length}");
        } else {
          hasNextPage = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);

        debugPrint("Error Attendees --> $err");
      }
    }
    notifyListeners();
  }

  // get clocked members for a meeting
  Future<void> getAllAbsentees({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      _absenteesPage = 1;
      var response = await ClockingAPI.getAbsenteesList(
        page: _absenteesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null
            ? selectedPastMeetingEvent!.branchId!
            : selectedBranch!.id!,
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
        memberCategoryId:
            selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
        groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
        subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
        genderId: selectedGender == null ? 0 : selectedGender!.id!,
        fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
        toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
      );
      selectedAbsentees.clear();

      if (response.results!.isNotEmpty) {
        // get total number of absentees
        totalAbsentees = response.count!;
        // filter list for only members excluding
        // admin if he is also a member
        _absentees = response.results!;

        _tempAbsentees = _absentees;

        // calc total males
        for (var absentee in _tempAbsentees) {
          if (absentee!.attendance!.memberId!.gender == AppConstants.male) {
            totalMaleAbsentees.add(absentee);
          }
        }

        // calc total females
        for (var absentee in _tempAbsentees) {
          if (absentee!.attendance!.memberId!.gender == AppConstants.female) {
            totalFemaleAbsentees.add(absentee);
          }
        }

        debugPrint('Absentees: ${_absentees.length}');
      }

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint("Error Absentees --> $err");
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of absentees of past meeting
  Future<void> _loadMoreAbsentees() async {
    if (hasNextPage == true &&
        loading == false &&
        isLoadMoreRunning == false &&
        absenteesScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _absenteesPage += 1; // increase page by 1
      try {
        var response = await ClockingAPI.getAbsenteesList(
          page: _absenteesPage,
          meetingEventModel: selectedPastMeetingEvent!,
          branchId: selectedBranch == null
              ? selectedPastMeetingEvent!.branchId!
              : selectedBranch!.id!,
          filterDate: selectedDate == null
              ? getFilterDate()
              : selectedDate!.toIso8601String().substring(0, 10),
          memberCategoryId:
              selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
          groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
          subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
          genderId: selectedGender == null ? 0 : selectedGender!.id!,
          fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
          toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
        );
        if (response.results!.isNotEmpty) {
          _absentees.addAll(response.results!);

          _tempAbsentees.addAll(_absentees);

          // calc rest of the total males
          for (var absentee in _tempAbsentees) {
            if (absentee!.attendance!.memberId!.gender == AppConstants.male) {
              totalMaleAbsentees.add(absentee);
            }
          }

          debugPrint("Total male absentees: ${totalMaleAbsentees.length}");

          // calc rest of the total females
          for (var absentee in _tempAbsentees) {
            if (absentee!.attendance!.memberId!.gender == AppConstants.female) {
              totalFemaleAbsentees.add(absentee);
            }
          }

          debugPrint("Total female absentees: ${totalFemaleAbsentees.length}");
        } else {
          hasNextPage = false;
        }

        debugPrint("Total users: ${_absentees.length}");
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("Error Absentees --> $err");
      }
    }
    notifyListeners();
  }

  void clearFilters() {
    selectedDate = null;
    selectedBranch = null;
    selectedGender = null;
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMemberCategory = null;
    selectedPastMeetingEvent = null;
    minAgeTEC.clear();
    maxAgeTEC.clear();
    notifyListeners();
  }

  // cancel clocking for meeting
  Future<void> cancelClocking({
    required BuildContext context,
    required Attendee? attendee,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.cancelClocking(
          clockingId: attendee!.attendance!.id!,
          time: time ?? selectedDate!.toIso8601String().substring(0, 10),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.cancelClocking(
            clockingId: attendee!.attendance!.id!,
            time: time ?? selectedDate!.toIso8601String().substring(0, 10),
          );
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAttendees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        showNormalToast(response.message);
        debugPrint("SUCCESS ${response.message}");
      }
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void validateFilterFields(context) {
    if (selectedDate != null ||
        selectedPastMeetingEvent != null ||
        selectedBranch != null ||
        selectedMemberCategory != null ||
        selectedGender != null ||
        selectedGroup != null ||
        selectedSubGroup != null ||
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      getAllAttendees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
    } else if (selectedPastMeetingEvent == null) {
      showErrorToast('Please select a meeting or event to contitue');
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  // search through attendance list by name
  void searchAbsenteesByName({required String searchText}) {
    List<Attendee?> results = [];
    if (searchText.isEmpty) {
      results = _tempAbsentees;
    } else {
      results = _tempAbsentees
          .where((element) =>
              element!.attendance!.memberId!.firstname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.attendance!.memberId!.surname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _absentees = results;
    notifyListeners();
  }

  // search through attendance list by id
  void searchAbsenteesById({required String searchText}) {
    List<Attendee?> results = [];
    if (searchText.isEmpty) {
      results = _tempAbsentees;
    } else {
      results = _tempAbsentees
          .where((element) =>
              element!.attendance!.memberId!.id!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.attendance!.memberId!.surname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _absentees = results;
    notifyListeners();
  }

  // search through clocked member list by name
  void searchAttendeesByName({required String searchText}) {
    List<Attendee?> results = [];
    if (searchText.isEmpty) {
      results = _tempAttendees;
    } else {
      results = _tempAttendees
          .where((element) =>
              element!.attendance!.memberId!.firstname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.attendance!.memberId!.surname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _attendees = results;
    notifyListeners();
  }

  // search through clocked member list by name
  void searchAttendeesById({required String searchText}) {
    List<Attendee?> results = [];
    if (searchText.isEmpty) {
      results = _tempAttendees;
    } else {
      results = _tempAttendees
          .where((element) =>
              element!.attendance!.memberId!.id!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.attendance!.memberId!.surname!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _attendees = results;
    notifyListeners();
  }

  Future<void> clearData() async {
    clearFilters();
    search = '';
    totalAttendees = 0;
    totalAbsentees = 0;
    totalMaleAttendees.clear();
    totalFemaleAttendees.clear();
    totalMaleAbsentees.clear();
    totalFemaleAbsentees.clear();
    _attendees.clear();
    _tempAttendees.clear();
    _selectedAttendees.clear();
    _absentees.clear();
    _tempAbsentees.clear();
  }
}
