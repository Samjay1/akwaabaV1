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
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockingProvider extends ChangeNotifier {
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

  List<Attendee?> _tempAbsentees = [];

  final List<Attendee?> _selectedAbsentees = [];

  List<Attendee?> _attendees = [];

  List<Attendee?> _tempAttendees = [];

  final List<Attendee?> _selectedAttendees = [];

  DateTime? selectedDate;

  MeetingEventModel? _meetingEventModel;

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;
  Gender? selectedGender;
  Branch? selectedBranch;

  BuildContext? _context;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MemberCategory> get memberCategories => _memberCategories;
  List<Gender> get genders => _genders;
  List<Branch> get branches => _branches;

  List<Attendee?> get absentees => _absentees;

  List<Attendee?> get selectedAbsentees => _selectedAbsentees;

  List<Attendee?> get attendees => _attendees;

  List<Attendee?> get selectedAttendees => _selectedAttendees;

  MeetingEventModel get selectedCurrentMeeting => _meetingEventModel!;
  BuildContext get currentContext => _context!;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get clocking => _clocking;
  bool get submitting => _submitting;

  // pagination variables
  int _absenteesPage = 1;
  int _attendeesPage = 1;
  bool hasNextPage = true;

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

  setCurrentContext(BuildContext context) {
    _context = context;
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

  // get current date and format for filtering
  String getCurrentClockingTime() {
    final clockingTime = DateTime.now().toIso8601String().substring(0, 19);
    debugPrint("Clocking DT: $clockingTime");
    return clockingTime;
  }

  // queries for clockingId of a particular meeting
  Future<int> getClockingId({
    required MeetingEventModel meetingEventModel,
  }) async {
    var response = await AttendanceAPI.getAttendanceList(
      meetingEventModel: meetingEventModel,
      filterDate: getFilterDate(),
    );
    return response.results![0].id!;
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
        branchId: selectedCurrentMeeting.branchId!,
      );
      debugPrint('Groups: ${_groups.length}');
      // selectedGroup = _groups[0];
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
    await getAllAbsentees(
      meetingEventModel: selectedCurrentMeeting,
    );
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    try {
      _subGroups = await GroupAPI.getSubGroups(
        branchId: selectedCurrentMeeting.branchId!,
        memberCategoryId: selectedMemberCategory!.id!,
      );
      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error SubGroup: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // initial loading of members or absentees for a meeting
  Future<void> getAllAbsentees({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      setLoading(true);
      _absenteesPage = 1;
      var response = await ClockingAPI.getAbsenteesList(
        page: _absenteesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null
            ? meetingEventModel.branchId!
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
      _absentees.clear();
      _selectedAbsentees.clear();
      if (response.results!.isNotEmpty) {
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

        _tempAbsentees = _absentees;
      }

      debugPrint('Absentees: ${_absentees.length}');

      getAllAttendees(
        meetingEventModel: meetingEventModel,
      );

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Absentees: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of attendees of a meeting
  Future<void> _loadMoreAbsentees() async {
    if (hasNextPage == true &&
        loading == false &&
        _loadingMore == false &&
        absenteesScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _absenteesPage += 1; // increase page by 1
      try {
        var response = await ClockingAPI.getAbsenteesList(
          page: _absenteesPage,
          meetingEventModel: selectedCurrentMeeting,
          branchId: selectedBranch == null
              ? selectedCurrentMeeting.branchId!
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
          var newAbsenteesList = response.results!
              .where((absentee) => (absentee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantEmail ||
                  absentee.attendance!.memberId!.phone !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantPhone))
              .toList();
          _absentees.addAll(newAbsenteesList);
          _tempAbsentees.addAll(_absentees);
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
      _attendeesPage = 1;
      var response = await ClockingAPI.getAttendeesList(
        page: _attendeesPage,
        meetingEventModel: meetingEventModel,
        branchId: selectedBranch == null
            ? meetingEventModel.branchId!
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
      _selectedAttendees.clear();
      _attendees.clear();

      if (response.results!.isNotEmpty) {
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

        _tempAttendees = _attendees;
      }
      debugPrint('Atendees: ${_attendees.length}');
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error Attendees: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of absentees of a meeting
  Future<void> _loadMoreAttendees() async {
    if (hasNextPage == true &&
        loading == false &&
        _loadingMore == false &&
        attendeesScrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _attendeesPage += 1; // increase page by 1
      try {
        var response = await ClockingAPI.getAttendeesList(
          page: _attendeesPage,
          meetingEventModel: selectedCurrentMeeting,
          branchId: selectedBranch == null
              ? selectedCurrentMeeting.branchId!
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
          var newAtendeesList = response.results!
              .where((attendee) => (attendee.attendance!.memberId!.email !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantEmail ||
                  attendee.attendance!.memberId!.phone !=
                      Provider.of<ClientProvider>(_context!, listen: false)
                          .getUser!
                          .applicantPhone))
              .toList();
          _attendees.addAll(newAtendeesList);
          _tempAttendees.addAll(_attendees);
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
    selectedBranch = null;
    selectedGender = null;
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMemberCategory = null;
    minAgeTEC.clear();
    maxAgeTEC.clear();
    notifyListeners();
  }

// clocks a member in of a meeting or event by admin
  Future<void> clockMemberIn({
    required BuildContext context,
    required Attendee? attendee,
    required String? time,
  }) async {
    try {
      debugPrint("ClockingTime $time");
      showLoadingDialog(context);
      var response;
      if (_selectedAbsentees.isEmpty) {
        // Perform individual clock-in
        response = await ClockingAPI.clockIn(
          clockingId: attendee!.attendance!.id!,
          time: time ?? getCurrentClockingTime(),
        );
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
            time: time ?? getCurrentClockingTime(),
          );
          if (_absentees.contains(attendee)) {
            _absentees.remove(attendee);
          }
          attendee.attendance!.memberId!.selected = false;
        }
        _selectedAbsentees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(meetingEventModel: selectedCurrentMeeting);
      showNormalToast(response.message!);
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> clockMemberOut({
    required BuildContext context,
    required Attendee? attendee,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual clock-out
        response = await ClockingAPI.clockOut(
          clockingId: attendee!.attendance!.id!,
          time: time ?? getCurrentClockingTime(),
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
              time: time ?? getCurrentClockingTime(),
            );
            attendee.attendance!.memberId!.selected = false;
          }
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedCurrentMeeting,
      );
      showNormalToast(response.message);
      Navigator.pop(context);
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
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.startBreak(
          clockingId: attendee!.attendance!.id!,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.startBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getCurrentClockingTime(),
          );
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(meetingEventModel: selectedCurrentMeeting);

      if (response!.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        showNormalToast(response.message!);
      }
      Navigator.pop(context);
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
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (selectedAttendees.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.endBreak(
          clockingId: attendee!.attendance!.id!,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.endBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getCurrentClockingTime(),
          );
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedCurrentMeeting,
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
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId ${attendee.attendance!.id!}");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in selectedAttendees) {
          response = await ClockingAPI.cancelClocking(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getCurrentClockingTime(),
          );
        }
        _selectedAttendees.clear();
      }
      // refresh list when there is bulk operation
      getAllAbsentees(
        meetingEventModel: selectedCurrentMeeting,
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

  void validateFilterFields() {
    if (selectedMemberCategory != null ||
        selectedBranch != null ||
        selectedGender != null ||
        selectedGroup != null ||
        selectedSubGroup != null ||
        selectedDate != null ||
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      getAllAbsentees(
        meetingEventModel: selectedCurrentMeeting,
      );
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
          .where((element) => element!.additionalInfo!.id!
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
          .where((element) => element!.additionalInfo!.id!
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
    _attendees = results;
    notifyListeners();
  }

  void clearData() {
    clearFilters();
    _attendees.clear();
    _tempAttendees.clear();
    _selectedAttendees.clear();
    _absentees.clear();
    _tempAbsentees.clear();
  }
}
