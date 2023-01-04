import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/clocking_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/attendance/attendance.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/subgroup.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ClockingProvider extends ChangeNotifier {
  String? _memberToken;
  bool _loading = false;
  bool _clocking = false;
  bool _submitting = false;

  List<int> meetingEventIds = [];

  List<Group> _groups = [];
  List<SubGroup> _subGroups = [];
  List<MemberCategory> _memberCategories = [];

  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();
  final TextEditingController searchTEC = TextEditingController();

  List<Member?> _tempMeetingMembersList = [];

  List<Member?> _meetingMembers = [];

  List<Member?> _selectedMeetingMembers = [];

  List<Attendee?> _clockedMembers = [];

  List<Attendee?> _tempClockedMembers = [];

  List<Attendee?> _selectedClockedMembers = [];

  List<MeetingEventModel> _pastMeetingEvents = [];

  List<MeetingEventModel> get pastMeetingEvents => _pastMeetingEvents;

  MeetingEventModel? selectedPastMeetingEvent;
  DateTime? selectedDate;
  DateTime? postClockDate;
  DateTime? postClockTime;

  MeetingEventModel? _meetingEventModel;

  Group? selectedGroup;
  SubGroup? selectedSubGroup;
  MemberCategory? selectedMemberCategory;

  // Retrieve all meetings
  List<Group> get groups => _groups;
  List<SubGroup> get subGroups => _subGroups;
  List<MemberCategory> get memberCategories => _memberCategories;

  // List<Member?> get filteredMeetingMembers => _filteredMeetingMembers;

  List<Member?> get meetingMembers => _meetingMembers;

  List<Attendee?> get clockedMembers => _clockedMembers;

  List<Member?> get selectedMeetingMembers => _selectedMeetingMembers;

  List<Attendee?> get selectedClockedMembers => _selectedClockedMembers;

  MeetingEventModel get selectedCurrentMeeting => _meetingEventModel!;

  bool get loading => _loading;
  bool get clocking => _clocking;
  bool get submitting => _submitting;
  get memberToken => _memberToken;

  setLoading(bool loading) {
    _loading = loading;
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
      //selectedMemberCategory = _memberCategories[0];
      getGroups();
    } catch (err) {
      setLoading(false);
      debugPrint('Error MA: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// get list of groups
  Future<void> getGroups() async {
    try {
      _groups = await GroupAPI.getGroups(
        branchId: selectedPastMeetingEvent == null
            ? selectedCurrentMeeting.branchId!
            : selectedPastMeetingEvent!.branchId!,
      );
      debugPrint('Groups: ${_groups.length}');
      // selectedGroup = _groups[0];
    } catch (err) {
      setLoading(false);
      debugPrint('Error MA: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList() async {
    clearFilters();
    await getAttendanceList(
      meetingEventModel: selectedCurrentMeeting,
    );
  }

  // get list of subgroups
  Future<void> getSubGroups() async {
    try {
      _subGroups = await GroupAPI.getSubGroups(
        branchId: selectedPastMeetingEvent == null
            ? selectedCurrentMeeting.branchId!
            : selectedPastMeetingEvent!.branchId!,
        memberCategoryId: selectedMemberCategory!.id!,
      );

      debugPrint('Sub Groups: ${_subGroups.length}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error MA: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get meetins from date specified
  Future<void> getPastMeetingEvents() async {
    try {
      _pastMeetingEvents = await AttendanceAPI.getMeetingsFromDate(
        date: selectedDate!.toIso8601String().substring(0, 10),
      );
      selectedPastMeetingEvent = _pastMeetingEvents[0];
    } catch (err) {
      debugPrint('Error MA: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> getAttendanceList({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      setLoading(true);
      var response = await ClockingAPI.getAttendanceList(
        meetingEventModel: selectedPastMeetingEvent ?? meetingEventModel,
        //filterDate: getFilterDate(),
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
      );
      if (response.results!.isNotEmpty) {
        // _tempMeetingMembersList =
        //     response.results!.map((e) => e.memberId).toList();

        List<Member> members = [];
        for (Attendance attendance in response.results!) {
          Member member = Member(
            id: attendance.memberId!.id,
            clockingId: attendance.id!,
            firstname: attendance.memberId!.firstname,
            surname: attendance.memberId!.surname,
            middlename: attendance.memberId!.middlename,
            gender: attendance.memberId!.gender,
            profilePicture: attendance.memberId!.profilePicture,
            phone: attendance.memberId!.phone,
            email: attendance.memberId!.email,
            dateOfBirth: attendance.memberId!.dateOfBirth,
            religion: attendance.memberId!.religion,
            nationality: attendance.memberId!.nationality,
            countryOfResidence: attendance.memberId!.countryOfResidence,
            stateProvince: attendance.memberId!.stateProvince,
            region: attendance.memberId!.region,
            district: attendance.memberId!.district,
            electoralArea: attendance.memberId!.electoralArea,
            community: attendance.memberId!.community,
            hometown: attendance.memberId!.hometown,
            houseNoDigitalAddress: attendance.memberId!.houseNoDigitalAddress,
            digitalAddress: attendance.memberId!.digitalAddress,
            level: attendance.memberId!.level,
            status: attendance.memberId!.status,
            accountType: attendance.memberId!.accountType,
            memberType: attendance.memberId!.memberType,
            date: attendance.memberId!.date,
            lastLogin: attendance.memberId!.lastLogin,
            referenceId: attendance.memberId!.referenceId,
            branchId: attendance.memberId!.branchId,
            editable: attendance.memberId!.editable,
            profileResume: attendance.memberId!.profileResume,
            profileIdentification: attendance.memberId!.profileIdentification,
            archived: attendance.memberId!.archived,
            branchInfo: attendance.memberId!.branchInfo,
            categoryInfo: attendance.memberId!.categoryInfo,
            selected: false,
          );
          debugPrint("Clocking ID: ${attendance.id}");
          members.add(member);
        }
        _tempMeetingMembersList = members;
      }
      getClockedMembers(
          meetingEventModel: selectedPastMeetingEvent ?? meetingEventModel);
    } catch (err) {
      setLoading(false);
      debugPrint('Error MA: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// get clocked members for a meeting
  Future<void> getClockedMembers({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      var response = await ClockingAPI.getClockedMembers(
        meetingEventModel: meetingEventModel,
        //filterDate: getFilterDate(),
        //filterDate: '2022-12-30',
        filterDate: selectedDate == null
            ? getFilterDate()
            : selectedDate!.toIso8601String().substring(0, 10),
        memberCategoryId:
            selectedMemberCategory == null ? 0 : selectedMemberCategory!.id!,
        groupId: selectedGroup == null ? 0 : selectedGroup!.id!,
        subGroupId: selectedSubGroup == null ? 0 : selectedSubGroup!.id!,
        genderId: 0,
        fromAge: int.parse(minAgeTEC.text.isEmpty ? '0' : minAgeTEC.text),
        toAge: int.parse(maxAgeTEC.text.isEmpty ? '0' : maxAgeTEC.text),
      );
      _selectedClockedMembers.clear();
      //_clockedMembers.clear();
      //_tempClockedMembers.clear();
      if (response.results!.isNotEmpty) {
        // _clockedMembers =
        //     response.results!.map((e) => e.additionalInfo!.memberInfo).toList();
        _clockedMembers = response.results!;

        _tempClockedMembers = _clockedMembers;

        debugPrint('Clocked members: ${_clockedMembers.length}');

        debugPrint(
            'Clocked members name: ${_clockedMembers[0]!.additionalInfo!.memberInfo!.firstname!}');
        debugPrint(
            'Clocked members surname: ${_clockedMembers[0]!.additionalInfo!.memberInfo!.surname!}');
      }
      if (_clockedMembers.isNotEmpty) {
        // remove clocked members from attendance or unclocked members list
        for (var i = 0; i < _clockedMembers.length; i++) {
          if (_tempMeetingMembersList
              .contains(_clockedMembers[i]!.additionalInfo!.memberInfo!)) {
            _tempMeetingMembersList
                .remove(_clockedMembers[i]!.additionalInfo!.memberInfo!);
            debugPrint('Clocked member removed');
          }
        }
        _meetingMembers = _tempMeetingMembersList;
      } else {
        _meetingMembers = _tempMeetingMembersList;
      }

      //clearFilters();

      // debugPrint('Clocked members: ${_clockedMembers.length}');
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void clearFilters() {
    selectedDate = null;
    selectedGroup = null;
    selectedSubGroup = null;
    selectedMemberCategory = null;
    minAgeTEC.clear();
    maxAgeTEC.clear();
  }

// clocks a member in of a meeting or event by admin
  Future<void> clockMemberIn({
    required BuildContext context,
    required Member? member,
    required int clockingId,
    required String? time,
  }) async {
    try {
      debugPrint("ClockingTime $time");
      showLoadingDialog(context);
      var response;
      if (_selectedMeetingMembers.isEmpty) {
        // Perform individual clock-in
        response = await ClockingAPI.clockIn(
          clockingId: clockingId,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
        // remove from list after member is been clocked in
        if (_meetingMembers.contains(member)) {
          _meetingMembers.remove(member);
        }
      } else {
        // Perform bulk clock-in
        for (Member? member in _selectedMeetingMembers) {
          response = await ClockingAPI.clockIn(
            clockingId: member!.clockingId!,
            time: time ?? getCurrentClockingTime(),
          );
          if (_meetingMembers.contains(member)) {
            _meetingMembers.remove(member);
          }
          member.selected = false;
        }
        _selectedMeetingMembers.clear();
        // refresh list when there is bulk operation
        //getAttendanceList(meetingEventModel: selectedPastMeetingEvent ?? selectedCurrentMeeting);
      }
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
    required int clockingId,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (_selectedClockedMembers.isEmpty) {
        // Perform individual clock-out
        response = await ClockingAPI.clockOut(
          clockingId: clockingId,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
      } else {
        // Perform bulk clock-out
        for (Attendee? attendee in _selectedClockedMembers) {
          // check if member has already clocked out
          if (attendee!.attendance!.outTime == null) {
            response = await ClockingAPI.clockOut(
              clockingId: attendee.attendance!.id!,
              time: time ?? getCurrentClockingTime(),
            );
            attendee.attendance!.memberId!.selected = false;
          }
        }
        _selectedClockedMembers.clear();
      }
      // refresh list when there is bulk operation
      getAttendanceList(
        meetingEventModel: selectedPastMeetingEvent ?? selectedCurrentMeeting,
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
    required int clockingId,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (_selectedClockedMembers.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.startBreak(
          clockingId: clockingId,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in _selectedClockedMembers) {
          response = await ClockingAPI.startBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getCurrentClockingTime(),
          );
        }
        _selectedClockedMembers.clear();
        // refresh list when there is bulk operation
        getAttendanceList(
            meetingEventModel:
                selectedPastMeetingEvent ?? selectedCurrentMeeting);
      }

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
    required int clockingId,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (_selectedClockedMembers.isEmpty) {
        // Perform individual start break
        response = await ClockingAPI.endBreak(
          clockingId: clockingId,
          time: time ?? getCurrentClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in _selectedClockedMembers) {
          response = await ClockingAPI.endBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getCurrentClockingTime(),
          );
        }
        _selectedClockedMembers.clear();
        // refresh list when there is bulk operation
        getAttendanceList(
          meetingEventModel: selectedPastMeetingEvent ?? selectedCurrentMeeting,
        );
      }
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
        selectedGroup != null ||
        selectedSubGroup != null ||
        selectedDate != null ||
        minAgeTEC.text.isNotEmpty ||
        maxAgeTEC.text.isNotEmpty) {
      getAttendanceList(
        meetingEventModel: selectedPastMeetingEvent == null
            ? selectedCurrentMeeting
            : selectedPastMeetingEvent!,
      );
    } else {
      showErrorToast('Please select fields to filter by');
    }
  }

  // search through attendance list by name
  void searchAttendanceList({required String searchText}) {
    List<Member?> results = [];
    if (searchText.isEmpty) {
      results = _tempMeetingMembersList;
    } else {
      results = _tempMeetingMembersList
          .where((element) => element!.firstname
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
    _meetingMembers = results;
  }

  // search through attendance list by id
  void searchAttendanceListById({required String searchText}) {
    List<Member?> results = [];
    if (searchText.isEmpty) {
      results = _tempMeetingMembersList;
    } else {
      results = _tempMeetingMembersList
          .where((element) => element!.id
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
    _meetingMembers = results;
    notifyListeners();
  }

  // search through clocked member list by name
  void searchClockedList({required String searchText}) {
    List<Attendee?> results = [];
    if (_tempClockedMembers.isNotEmpty) {
      if (searchText.isEmpty) {
        results = _tempClockedMembers;
      } else {
        results = _tempClockedMembers
            .where((element) => element!.attendance!.memberId!.firstname!
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
      _clockedMembers = results;
    }
  }

  // search through clocked member list by name
  void searchClockedListById({required String searchText}) {
    List<Attendee?> results = [];
    if (_tempClockedMembers.isNotEmpty) {
      if (searchText.isEmpty) {
        results = _tempClockedMembers;
      } else {
        results = _tempClockedMembers
            .where((element) => element!.attendance!.memberId!.id!
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
      _clockedMembers = results;
    }
  }

  String getPostClockDateTime() {
    var date = postClockDate!.toIso8601String().substring(0, 11);
    var time = postClockTime!.toIso8601String().substring(11, 19);
    return '$date$time';
  }

  void clearData() {
    clearFilters();
    postClockDate = null;
    postClockTime = null;
    _tempMeetingMembersList.clear();
    _tempClockedMembers.clear();
    _selectedClockedMembers.clear();
    _selectedMeetingMembers.clear();
    _clockedMembers.clear();
    _meetingMembers.clear();
    _pastMeetingEvents.clear();
    selectedPastMeetingEvent = null;
    notifyListeners();
  }

  // search through member list
  // void search() {
  //   if (searchTEC.text.isNotEmpty) {
  //     for (Member? member in _attendanceList) {
  //       if (member!.firstname!.toLowerCase().contains(searchTEC.text.toLowerCase())) {
  //         _filteredMeetingMembers.add(value);
  //       }
  //     }
  //   } else {
  //     _meetingMembers = _meetingMembers;
  //   }
  // }
}
