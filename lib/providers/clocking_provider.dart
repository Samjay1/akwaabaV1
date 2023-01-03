import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/api_responses/clocking_response.dart';
import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/clocking_api.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/attendance/attendance.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
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

  List<Member?> _tempMeetingMembersList = [];

  List<Member?> _meetingMembers = [];

  List<Attendee?> _clockedMembers = [];

  List<Member?> _selectedMeetingMembers = [];

  List<Attendee?> _selectedClockedMembers = [];

  MeetingEventModel? _meetingEventModel;

  // Retrieve all meetings
  List<Member?> get meetingMembers => _meetingMembers;

  List<Attendee?> get clockedMembers => _clockedMembers;

  List<Member?> get selectedMeetingMembers => _selectedMeetingMembers;

  List<Attendee?> get selectedClockedMembers => _selectedClockedMembers;

  MeetingEventModel get selectedMeeting => _meetingEventModel!;

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
  String getClockingTime() {
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

  Future<void> getAttendanceList({
    required MeetingEventModel meetingEventModel,
  }) async {
    try {
      setLoading(true);
      var response = await ClockingAPI.getAttendanceList(
        meetingEventModel: meetingEventModel,
        //filterDate: getFilterDate(),
        filterDate: '2022-12-30',
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
        //_tempMeetingMembersList = response.results!;
        // debugPrint(
        //     'Unclocked members name: ${_tempMeetingMembersList[0]!.firstname!}');
        // debugPrint(
        //     'Unclocked members name: ${_tempMeetingMembersList[1]!.firstname!}');
      }
      getClockedMembers(meetingEventModel: meetingEventModel);
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
        filterDate: '2022-12-30',
      );
      _selectedClockedMembers.clear();
      if (response.results!.isNotEmpty) {
        // _clockedMembers =
        //     response.results!.map((e) => e.additionalInfo!.memberInfo).toList();
        _clockedMembers = response.results!;

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
      }

      // debugPrint('Clocked members: ${_clockedMembers.length}');
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CK: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// clocks a member in of a meeting or event by admin
  Future<void> clockMemberIn({
    required BuildContext context,
    required Member? member,
    required int clockingId,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
      var response;
      if (_selectedMeetingMembers.isEmpty) {
        // Perform individual clock-in
        response = await ClockingAPI.clockIn(
          clockingId: clockingId,
          time: time ?? getClockingTime(),
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
            time: time ?? getClockingTime(),
          );
          if (_meetingMembers.contains(member)) {
            _meetingMembers.remove(member);
          }
          member.selected = false;
        }
        _selectedMeetingMembers.clear();
        // refresh list when there is bulk operation
        //getAttendanceList(meetingEventModel: selectedMeeting);
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
          time: time ?? getClockingTime(),
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
              time: time ?? getClockingTime(),
            );
            attendee.attendance!.memberId!.selected = false;
          }
        }
        _selectedClockedMembers.clear();
      }
      // refresh list when there is bulk operation
      getAttendanceList(meetingEventModel: selectedMeeting);
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
          time: time ?? getClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in _selectedClockedMembers) {
          response = await ClockingAPI.startBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getClockingTime(),
          );
        }
        _selectedClockedMembers.clear();
        // refresh list when there is bulk operation
        getAttendanceList(meetingEventModel: selectedMeeting);
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
          time: time ?? getClockingTime(),
        );
        debugPrint("SUCCESS ${response.message}");
        debugPrint("ClockingId $clockingId");
      } else {
        // Perform bulk start break
        for (Attendee? attendee in _selectedClockedMembers) {
          response = await ClockingAPI.endBreak(
            clockingId: attendee!.attendance!.id!,
            time: time ?? getClockingTime(),
          );
        }
        _selectedClockedMembers.clear();
        // refresh list when there is bulk operation
        getAttendanceList(meetingEventModel: selectedMeeting);
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

  Future<void> checkClockedMeetings({
    required MeetingEventModel meetingEventModel,
    required int branchId,
  }) async {
    try {
      var response = await AttendanceAPI.getAttendanceList(
        meetingEventModel: meetingEventModel,
        filterDate: getFilterDate(),
      );
      if (response.results!.isNotEmpty) {
        meetingEventModel.inOrOut = response.results![0].inOrOut;
        meetingEventModel.startBreak = response.results![0].startBreak;
        meetingEventModel.endBreak = response.results![0].endBreak;
        meetingEventModel.inTime = response.results![0].inTime;
        meetingEventModel.outTime = response.results![0].outTime;
        debugPrint('Has break: ${meetingEventModel.hasBreakTime}');
        debugPrint('Meeting name: ${meetingEventModel.name}');
        debugPrint('inOrOut: ${meetingEventModel.inOrOut}');
        debugPrint('Start break time: ${meetingEventModel.startBreak}');
        debugPrint('End break time: ${meetingEventModel.endBreak}');
      }
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }
}
