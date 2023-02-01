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
  bool _loadingMore = false;
  bool _clocking = false;
  bool _submitting = false;

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];
  List<Gender> _genders = [];
  List<Branch> _branches = [];

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

  String search = '';

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
    try {
      _memberCategories = await GroupAPI.getMemberCategories();
      debugPrint('Member Categories: ${_memberCategories.length}');
      getGenders();
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
      var userBranch = await getUserBranch(currentContext);
      _groups = await GroupAPI.getGroups(
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
        memberCategoryId: selectedMemberCategory!.id!,
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
    await getAllAbsentees(
      meetingEventModel: selectedPastMeetingEvent!,
    );
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

  // get meetings from date specified
  Future<void> getAllMeetingEvents() async {
    try {
      // _pastMeetingEvents = await EventAPI.getMeetingsFromDate(
      //   page: 1,
      //   date: selectedDate!.toIso8601String().substring(0, 10),
      // );
      var userBranch = await getUserBranch(currentContext);
      _pastMeetingEvents = await EventAPI.getAllMeetings(
        page: 1,
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
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
      getMemberCategories();
      getGenders();
    } catch (err) {
      //debugPrint('Error PMs: ${err.toString()}');
      showErrorToast(err.toString());
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
        search: search.isEmpty ? '' : search,
        memberCategoryId:
            selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
        groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
        subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
        genderId: selectedGender == null ? 0 : selectedGender!.id!,
        fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
        toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
      );
      selectedAbsentees.clear();

      if (response.results != null || response.results!.isNotEmpty) {
        // filter list for only members excluding
        // admin if he is also a member
        _absentees = response.results!
            .where((absentee) => (absentee.attendance!.memberId!.email !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .getUser!
                        .applicantEmail ||
                absentee.attendance!.memberId!.phone !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .getUser!
                        .applicantPhone))
            .toList();

        debugPrint('Absentees: ${_absentees.length}');
      } else {
        _absentees.clear();
      }

      getAllAttendees(
        meetingEventModel: meetingEventModel,
      );

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
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
          search: search.isEmpty ? '' : search,
          memberCategoryId:
              selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
          groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
          subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
          genderId: selectedGender == null ? 0 : selectedGender!.id!,
          fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
          toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
        );
        if (response.results!.isNotEmpty) {
          _absentees.addAll(response.results!
              .where((absentee) => (absentee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantEmail ||
                  absentee.attendance!.memberId!.phone !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantPhone))
              .toList());
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

  // get clocked members for a meeting
  Future<void> getAllAttendees({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
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
        search: search.isEmpty ? '' : search,
        memberCategoryId:
            selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
        groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
        subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
        genderId: selectedGender == null ? 0 : selectedGender!.id!,
        fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
        toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
      );
      selectedAttendees.clear();

      if (response.results != null || response.results!.isNotEmpty) {
        // filter list for only members excluding
        // admin if he is also a member
        _attendees = response.results!
            .where((attendee) => (attendee.attendance!.memberId!.email !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .getUser!
                        .applicantEmail ||
                attendee.attendance!.memberId!.phone !=
                    Provider.of<ClientProvider>(_context!, listen: false)
                        .getUser!
                        .applicantPhone))
            .toList();
      } else {
        _attendees.clear();
      }

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
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
          search: search.isEmpty ? '' : search,
          memberCategoryId:
              selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
          groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
          subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
          genderId: selectedGender == null ? 0 : selectedGender!.id!,
          fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
          toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
        );
        if (response.results!.isNotEmpty) {
          _attendees.addAll(response.results!
              .where((atendee) => (atendee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantEmail ||
                  atendee.attendance!.memberId!.phone !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantPhone))
              .toList());
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
    search = '';
    minAgeTEC.clear();
    maxAgeTEC.clear();
    notifyListeners();
  }

  Future<void> clearData() async {
    clearFilters();
    postClockTime = null;
    _attendees.clear();
    _selectedAttendees.clear();
    _selectedAbsentees.clear();
    _absentees.clear();
  }
}
