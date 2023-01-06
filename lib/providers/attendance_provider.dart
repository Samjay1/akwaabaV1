import 'dart:math';

import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AttendanceProvider extends ChangeNotifier {
  String? _memberToken;
  bool _loading = false;
  bool _clocking = false;
  bool _submitting = false;

  List<int> meetingEventIds = [];

  List<MeetingEventModel> _meetingEventList = [];
  List<MeetingEventModel> _upcomingMeetingEventList = [];

  MeetingEventModel? _meetingEventModel;

  final TextEditingController excuseTEC = TextEditingController();

  Position? _currentUserLocation;

  // Retrieve all meetings
  List<MeetingEventModel> get todayMeetings => _meetingEventList;
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;

  MeetingEventModel get selectedMeeting => _meetingEventModel!;

  get currentUserLocation => _currentUserLocation;
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
    debugPrint("Clocking: $_clocking");
    notifyListeners();
  }

  setSelectedMeeting(MeetingEventModel meetingEventModel) {
    _meetingEventModel = meetingEventModel;
    notifyListeners();
  }

  setToken({required String token}) {
    _memberToken = token;
    notifyListeners();
  }

  getCurrentUserLocation() async {
    _currentUserLocation = await LocationServices().getUserCurrentLocation();
    debugPrint("Current user location: ${_currentUserLocation.toString()}");
    notifyListeners();
  }

  Future<void> getTodayMeetingEvents({
    required var memberToken,
    required BuildContext context,
  }) async {
    _meetingEventList = await AttendanceAPI.getTodayMeetingEventList(
      context,
      memberToken,
    );
    if (_meetingEventList.isNotEmpty) {
      for (var meeting in _meetingEventList) {
        await checkClockedMeetings(
          meetingEventModel: meeting,
          branchId: meeting.branchId!,
        );
      }
    } else {
      setLoading(false);
    }
    notifyListeners();
  }

  Future<void> getUpcomingMeetingEvents({
    required var memberToken,
    required BuildContext context,
  }) async {
    setLoading(true);
    _upcomingMeetingEventList = await AttendanceAPI.getUpcomingMeetingEventList(
      context,
      memberToken,
    );
    getCurrentUserLocation();
    // getAttendanceList();
    getTodayMeetingEvents(
      memberToken: memberToken,
      context: context,
    );
    notifyListeners();
  }

  // queries for coordinates of a particular meeting
  Future<void> getMeetingCoordinates({
    required BuildContext context,
    required bool isBreak,
    required MeetingEventModel meetingEventModel,
    required String? time,
  }) async {
    //setClocking(true);
    showLoadingDialog(context);
    getCurrentUserLocation();

    var response = await AttendanceAPI.getMeetingCoordinates(
      meetingEventModel: meetingEventModel,
    );
    debugPrint("Latitude: ${response.results![0].latitude}");
    debugPrint("Longitude: ${response.results![0].longitude}");

    double totalDistance = calculateDistance(
      currentUserLocation.latitude,
      currentUserLocation.longitude,
      double.parse(response.results![0].latitude!),
      double.parse(response.results![0].longitude!),
    );

    if (totalDistance <= response.results![0].radius!) {
      await getAttendanceList(
        context: context,
        meetingEventModel: meetingEventModel,
        time: null,
        isBreak: isBreak,
      );
      debugPrint('You\'re within the radius of the premise');
    } else {
      Navigator.of(context).pop();
      debugPrint('You\'re not within the radius of the premise');
      showInfoDialog(
        'ok',
        context: context,
        title: 'Hey there!',
        content:
            'Sorry, it looks like you\'re not within the specified location radius. Please get closer and try again.',
        onTap: () => Navigator.pop(context),
      );
    }
    debugPrint('Calculated Radius: ${totalDistance.toString()}');
    debugPrint('Premise Radius: ${response.results![0].radius!}');
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

  // queries for attendance of a particular meeting
  Future<void> getAttendanceList({
    required BuildContext context,
    required bool isBreak,
    required MeetingEventModel meetingEventModel,
    required String? time,
  }) async {
    try {
      var response = await AttendanceAPI.getAttendanceList(
        meetingEventModel: meetingEventModel,
        filterDate: getFilterDate(),
      );
      if (isBreak) {
        if (response.results!.isNotEmpty) {
          var clockingId = response.results![0].id!;
          debugPrint("ClockingId: $clockingId");
          if (response.results![0].inOrOut!) {
            if (response.results![0].startBreak == null &&
                response.results![0].endBreak == null) {
              // user has not started a break
              // so start break
              startMeetingBreak(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null);
            } else if (response.results![0].startBreak != null &&
                response.results![0].endBreak == null) {
              // user has started a break
              // so end break
              endMeetingBreak(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null);
            } else if (response.results![0].startBreak != null &&
                response.results![0].endBreak != null) {
              // user has started and ended a break
              // so show message
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              showNormalToast('You\'ve already ended your break. Good Bye!');
            }
          } else {
            showNormalToast(
                'Hi there, you\'ve not clocked in. \nPlease clock-in before you can start your break.');
          }
          debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
        }
      } else {
        if (response.results!.isNotEmpty) {
          var clockingId = response.results![0].id!;
          debugPrint("ClockingId: $clockingId");
          if (response.results![0].inOrOut!) {
            if (response.results![0].outTime == null) {
              // user has not clocked out
              // so clock user out of meeting
              clockMemberOut(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null);
            } else {
              // user has already clocked out
              // hide loading widget
              // and display a user friendly message
              setClocking(false);
              showNormalToast('You\'ve already clocked out. Good Bye!');
            }
          } else {
            clockMemberIn(
                context: context,
                clockingId: clockingId,
                meetingEventModel: meetingEventModel,
                time: null);
          }
          debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
        }
      }
    } catch (err) {
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
  }

// clocks a member in of a meeting or event
  Future<void> clockMemberIn(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await AttendanceAPI.clockIn(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('You\'re Welcome');
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> clockMemberOut(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await AttendanceAPI.clockOut(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('Good Bye!');
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// starts break time for meeting
  Future<void> startMeetingBreak(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await AttendanceAPI.startBreak(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      // update fields of meeting event model
      meetingEventModel.inOrOut = response.inOrOut;
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('Enjoy Break Time!');
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

// ends break time for meeting
  Future<void> endMeetingBreak(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await AttendanceAPI.endBreak(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      // update fields of meeting event model
      meetingEventModel.inOrOut = response.inOrOut;
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('Welcome Back!');
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
      final currentDate =
          DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
              .substring(0, 10)
              .trim();
      var response = await AttendanceAPI.getAttendanceList(
        //meetingEventIds: [meetingEventModel.id!],
        meetingEventModel: meetingEventModel,
        filterDate: currentDate,
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

  // validate field for submitting an excuse for a meeting
  void validateExcuseField({
    required BuildContext context,
  }) async {
    if (excuseTEC.text.isEmpty) {
      showErrorToast('Please enter your excuse for the meeting or event');
      return;
    }
    setSubmitting(true);
    int clockingId = await getClockingId(
      meetingEventModel: selectedMeeting,
    ); // retrieve clocking id
    await submitExcuse(
      context: context,
      meetingId: selectedMeeting.id!,
      clockingId: clockingId,
      excuse: excuseTEC.text.trim(),
    ); // s
  }

  Future<void> submitExcuse({
    required BuildContext context,
    required int meetingId,
    required int clockingId,
    required String excuse,
  }) async {
    try {
      var response = await AttendanceAPI.submitExcuse(
        meetingEventId: meetingId,
        clockingId: clockingId,
        excuse: excuse,
      );
      setSubmitting(false);
      Navigator.of(context).pop();
      showNormalToast(response.message ??
          'Hi there, you\'ve already submitted an excuse for this meeting');
      excuseTEC.clear();
    } catch (err) {
      setSubmitting(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }
}
