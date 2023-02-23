import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/Networks/clocking_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/dialogs_modals/info_dialog.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/gender.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostClockingProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingFilters = false;
  bool _loadingMore = false;
  bool _clocking = false;
  bool _submitting = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];

  final TextEditingController searchNameTEC = TextEditingController();
  final TextEditingController searchIDTEC = TextEditingController();
  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  List<Attendee?> _absentees = [];

  final List<Attendee?> _selectedAbsentees = [];

  List<Attendee?> _attendees = [];

  final List<Attendee?> _selectedAttendees = [];

  List<MeetingEventModel> _pastMeetingEvents = [];

  List<MeetingEventModel> get pastMeetingEvents => _pastMeetingEvents;

  MeetingEventModel? selectedPastMeetingEvent;
  DateTime? selectedDate;
  String? postClockTime;
  String? displayClockTime;

  String searchName = '';
  String searchIdentity = '';

  MeetingEventModel? _meetingEventModel;

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  BuildContext? _context;

  List<Attendee?> get absentees => _absentees;

  List<Attendee?> get selectedAbsentees => _selectedAbsentees;

  List<Attendee?> get attendees => _attendees;

  List<Attendee?> get selectedAttendees => _selectedAttendees;

  MeetingEventModel get selectedCurrentMeeting => _meetingEventModel!;

  bool get loading => _loading;
  bool get loadingFilters => _loadingFilters;
  bool get loadingMore => _loadingMore;
  bool get clocking => _clocking;
  bool get submitting => _submitting;

  BuildContext get currentContext => _context!;

  // pagination variables
  int _absenteesPage = 1;
  int _attendeesPage = 1;
  var limit = AppConstants.pageLimit;
  var isFirstLoadRunning = false;
  bool hasNextAbsentees = false;
  bool hasNextAttendees = false;
  bool isSearch = false;
  var isLoadMoreRunning = false;

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

  setLoadingFilters(bool loading) {
    _loadingFilters = loading;
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

  setSelectedMeeting(MeetingEventModel meetingEventModel) {
    _meetingEventModel = meetingEventModel;
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
    setLoadingFilters(true);
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
      setLoadingFilters(false);
      debugPrint('Branches: ${_branches.length}');
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get list of genders
  Future<void> getGenders() async {
    setLoadingFilters(true);
    try {
      _genders = await GroupAPI.getGenders();
      debugPrint('Genders: ${_genders.length}');
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
      var userBranch = await getUserBranch(currentContext);
      _groups = await GroupAPI.getGroups(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        memberCategoryId: selectedMemberCategory!.id!,
      );
      debugPrint('Groups: ${_groups.length}');
      setLoadingFilters(false);
      // selectedGroup = _groups[0];
    } catch (err) {
      setLoadingFilters(false);
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
    await getAllAbsentees(
      meetingEventModel: selectedPastMeetingEvent!,
    );
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    setLoadingFilters(true);
    try {
      selectedSubGroup = null;
      _subGroups = await GroupAPI.getSubGroups(
        groupId: selectedGroup!.id!,
      );
      setLoadingFilters(false);
      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error SubGroup: ${err.toString()}');
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get meetings from date specified
  Future<void> getAllMeetingEvents() async {
    setLoadingFilters(true);
    try {
      var userBranch = await getUserBranch(currentContext);
      _pastMeetingEvents = await EventAPI.getAllMeetings(
        page: 1,
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
      );
      if (_pastMeetingEvents.isNotEmpty) {
        selectedPastMeetingEvent = _pastMeetingEvents[0];
      }
      setLoadingFilters(false);
      getMemberCategories();
    } catch (err) {
      setLoadingFilters(false);
      //debugPrint('Error PMs: ${err.toString()}');
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get clocked members for a meeting
  Future<void> getAllAbsentees({
    required MeetingEventModel meetingEventModel,
  }) async {
    var userBranch =
        await getUserBranch(currentContext); // get current user branch
    try {
      setLoading(true);
      _absenteesPage = 1;
      var response = await ClockingAPI.getAbsenteesList(
        page: _absenteesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
        searchName: searchName.isEmpty ? '' : searchName,
        searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
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
      selectedAbsentees.clear();

      hasNextAbsentees = response.next == null ? false : true;

      if (response.results != null || response.results!.isNotEmpty) {
        // filter list for only members excluding
        // admin if he is also a member
        _absentees = response.results!
            .where((absentee) => (absentee.attendance!.memberId!.firstname !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .firstname ||
                absentee.attendance!.memberId!.surname !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .surname ||
                absentee.attendance!.memberId!.email !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .email))
            .toList();

        debugPrint('Absentees: ${_absentees.length}');
      } else {
        _absentees.clear();
      }

      if (!isSearch) {
        getAllAttendees(
          meetingEventModel: meetingEventModel,
        );
      } else {
        setLoading(false);
      }
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
      // showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of absentees of past meeting
  Future<void> _loadMoreAbsentees() async {
    if (hasNextAbsentees &&
        (absenteesScrollController.position.pixels ==
            absenteesScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _absenteesPage += 1; // increase page by 1
      var userBranch =
          await getUserBranch(currentContext); // get current user branch
      try {
        var response = await ClockingAPI.getAbsenteesList(
          page: _absenteesPage,
          meetingEventModel: selectedPastMeetingEvent!,
          branchId:
              selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
          filterDate: selectedDate == null
              ? getFilterDate()
              : selectedDate!.toIso8601String().substring(0, 10),
          searchName: searchName.isEmpty ? '' : searchName,
          searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
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
        );

        if (response.results!.isNotEmpty) {
          hasNextAbsentees = response.next == null ? false : true;
          _absentees.addAll(response.results!
              .where((absentee) => (absentee.attendance!.memberId!.firstname !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .firstname ||
                  absentee.attendance!.memberId!.surname !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .surname ||
                  absentee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .email))
              .toList());
        } else {
          hasNextAbsentees = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("error --> $err");
      }
    }
    notifyListeners();
  }

  // get clocked members for a meeting
  Future<void> getAllAttendees({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      setLoading(true);
      var userBranch =
          await getUserBranch(currentContext); // get current user branch
      _attendeesPage = 1;
      var response = await ClockingAPI.getAttendeesList(
        page: _attendeesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
        searchName: searchName.isEmpty ? '' : searchName,
        searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
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
      selectedAttendees.clear();

      hasNextAttendees = response.next == null ? false : true;

      if (response.results != null || response.results!.isNotEmpty) {
        // filter list for only members excluding
        // admin if he is also a member
        _attendees = response.results!
            .where((attendee) => (attendee.attendance!.memberId!.firstname !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .firstname ||
                attendee.attendance!.memberId!.surname !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .surname ||
                attendee.attendance!.memberId!.email !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .adminProfile!
                        .email))
            .toList();
      } else {
        _attendees.clear();
      }

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
      // showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of absentees of past meeting
  Future<void> _loadMoreAttendees() async {
    if (hasNextAttendees &&
        (attendeesScrollController.position.pixels ==
            attendeesScrollController.position.maxScrollExtent)) {
      setLoadingMore(true); // show loading indicator
      _attendeesPage += 1; // increase page by 1
      var userBranch =
          await getUserBranch(currentContext); // get current user branch
      try {
        var response = await ClockingAPI.getAttendeesList(
          page: _attendeesPage,
          meetingEventModel: selectedPastMeetingEvent!,
          branchId:
              selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
          filterDate: selectedDate == null
              ? getFilterDate()
              : selectedDate!.toIso8601String().substring(0, 10),
          searchName: searchName.isEmpty ? '' : searchName,
          searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
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
        );
        if (response.results!.isNotEmpty) {
          hasNextAttendees = response.next == null ? false : true;
          _attendees.addAll(response.results!
              .where((attendee) => (attendee.attendance!.memberId!.firstname !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .firstname ||
                  attendee.attendance!.memberId!.surname !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .surname ||
                  attendee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .adminProfile!
                          .email))
              .toList());
        } else {
          hasNextAttendees = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("error --> $err");
      }
    }
    notifyListeners();
  }

// clocks a member in of a meeting or event by admin
  Future<void> clockMemberIn({
    required BuildContext context,
    required Attendee? attendee,
    required String time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (_selectedAbsentees.isEmpty) {
        // Perform individual clock-in
        response = await ClockingAPI.clockIn(
          clockingId: attendee!.attendance!.id!,
          time: time,
        );
        debugPrint("ClockingTime $time");
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
        // // remove from list after member is been clocked in
        // if (_absentees.contains(attendee)) {
        //   _absentees.remove(attendee);
        // }
      } else {
        // Perform bulk clock-in
        for (Attendee? attendee in _selectedAbsentees) {
          response = await ClockingAPI.clockIn(
            clockingId: attendee!.attendance!.id!,
            time: time,
          );
          if (_absentees.contains(attendee)) {
            _absentees.remove(attendee);
          }
          attendee.attendance!.memberId!.selected = false;
        }
        _selectedAbsentees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
      showNormalToast(response.message);
      if (context.mounted) Navigator.of(context).pop();
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error Clocking In: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> clockMemberOut({
    required BuildContext context,
    required Attendee? attendee,
    required String time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual clock-out
        response = await ClockingAPI.clockOut(
          clockingId: attendee!.attendance!.id!,
          time: time,
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk clock-out
        for (Attendee? attendee in selectedAttendees) {
          // check if member has already clocked out
          if (attendee!.attendance!.outTime == null) {
            response = await ClockingAPI.clockOut(
              clockingId: attendee.attendance!.id!,
              time: time,
            );
            attendee.attendance!.memberId!.selected = false;
          }
        }
        _selectedAttendees.clear();
      }
      if (context.mounted) Navigator.of(context).pop();
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
      showNormalToast(response.message);
      if (context.mounted) Navigator.of(context).pop();
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// starts break time for meeting
  Future<void> startMeetingBreak({
    required BuildContext context,
    required Attendee? attendee,
    required String time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.startBreak(
          clockingId: attendee!.attendance!.id!,
          time: time,
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.startBreak(
            clockingId: attendee!.attendance!.id!,
            time: time,
          );
        }
        _selectedAttendees.clear();
      }
      if (context.mounted) Navigator.of(context).pop();
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );

      if (response.message == null) {
        showErrorToast(response.nonFieldErrors[0]);
      } else {
        showNormalToast(response.message);
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// ends break time for meeting
  Future<void> endMeetingBreak({
    required BuildContext context,
    required Attendee? attendee,
    required String time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.endBreak(
          clockingId: attendee!.attendance!.id!,
          time: time,
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.endBreak(
            clockingId: attendee!.attendance!.id!,
            time: time,
          );
        }
        _selectedAttendees.clear();
      }
      if (context.mounted) Navigator.of(context).pop();
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
      if (response.message == null) {
        showErrorToast(response.nonFieldErrors[0]);
      } else {
        showNormalToast(response.message);
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
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
          time: time!,
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.cancelClocking(
            clockingId: attendee!.attendance!.id!,
            time: time!,
          );
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        showNormalToast(response.message);
        debugPrint("SUCCESS ${response.message}");
      }
      if (context.mounted) Navigator.of(context).pop();
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
      getAllAbsentees(
        meetingEventModel: selectedPastMeetingEvent!,
      );
    } else if (selectedPastMeetingEvent == null) {
      showErrorToast('Please select a meeting or event to contitue');
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  String getPostClockDateTime() {
    var date = selectedDate!.toIso8601String().substring(0, 11);
    var time = '$postClockTime:00';
    return '$date$time';
  }

  void clearFilters() {
    selectedDate = null;
    selectedBranch = null;
    selectedGender = null;
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMemberCategory = null;
    selectedPastMeetingEvent = null;
    searchName = '';
    searchIdentity = '';
    minAgeTEC.clear();
    maxAgeTEC.clear();
    notifyListeners();
  }

  Future<void> clearData() async {
    clearFilters();
    postClockTime = null;
    _pastMeetingEvents.clear();
    _attendees.clear();
    searchIDTEC.clear();
    searchNameTEC.clear();
    _selectedAttendees.clear();
    _selectedAbsentees.clear();
    _absentees.clear();
  }
}
