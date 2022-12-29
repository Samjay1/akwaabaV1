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
    debugPrint("callTodayMeetingEventList");
    _meetingEventList = await AttendanceAPI.getTodayMeetingEventList(
      context,
      memberToken,
    );
    for (var meeting in _meetingEventList) {
      await checkClockedMeetings(
        meetingEventModel: meeting,
        branchId: meeting.branchId!,
      );
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> getUpcomingMeetingEvents({
    required var memberToken,
    required BuildContext context,
  }) async {
    setLoading(true);
    final clockingTime = DateTime.now().toIso8601String().substring(0, 19);
    debugPrint("Current DateTime: $clockingTime");
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
    required MeetingEventModel meetingEventModel,
  }) async {
    setClocking(true);
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
      getAttendanceList(meetingEventModel: meetingEventModel);
      debugPrint('You\'re within the radius of the premise');
    } else {
      debugPrint('You\'re not within the radius of the premise');
      showNormalToast(
          'You\'re not within the radius of the premise to clock. \nGet closer to clock-in');
    }
    debugPrint('Calculated Radius: ${totalDistance.toString()}');
    debugPrint('Premise Radius: ${response.results![0].radius!}');
  }

  // queries for clockingId of a particular meeting
  Future<int> getClockingId({
    required MeetingEventModel meetingEventModel,
  }) async {
    final filterDate =
        DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
            .substring(0, 10)
            .trim();
    var response = await AttendanceAPI.getAttendanceList(
      meetingEventModel: meetingEventModel,
      filterDate: filterDate,
    );
    return response.results![0].id!;
  }

  // queries for attendance of a particular meeting
  Future<void> getAttendanceList({
    required MeetingEventModel meetingEventModel,
  }) async {
    final filterDate =
        DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
            .substring(0, 10)
            .trim();
    debugPrint("Filter DateTime: $filterDate");
    var response = await AttendanceAPI.getAttendanceList(
      meetingEventModel: meetingEventModel,
      filterDate: filterDate,
    );
    if (response.results!.isNotEmpty) {
      var clockingId = response.results![0].id!;
      debugPrint("ClockingId: $clockingId");
      if (response.results![0].inOrOut!) {
        if (response.results![0].outTime == null) {
          // user has not clocked out
          // so clock user out of meeting
          clockMemberOut(clockingId: clockingId);
        } else {
          // user has already clocked out
          // hide loading widget
          // and display a user friendly message
          setClocking(false);
          showNormalToast('You\'ve already clocked out. Good Bye!');
        }
      } else {
        clockMemberIn(clockingId: clockingId);
      }
      debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
    }
  }

  Future<void> clockMemberIn({
    required int clockingId,
  }) async {
    try {
      final clockingTime = DateTime.now().toIso8601String().substring(0, 19);
      debugPrint("DateTime: $clockingTime");
      var response = await AttendanceAPI.clockIn(
        clockingId: clockingId,
        time: clockingTime,
      );
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('You\'re Welcome');
      setClocking(false);
    } catch (err) {
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> clockMemberOut({
    required int clockingId,
  }) async {
    try {
      setClocking(true);
      var response = await AttendanceAPI.clockOut(
        clockingId: clockingId,
      );
      debugPrint("SUCCESS ${response.message}");
      showNormalToast('Good Bye!');
      setClocking(false);
    } catch (err) {
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
      meetingEventModel.inOrOut = response.results![0].inOrOut;
      debugPrint('Meeting name: ${meetingEventModel.name}');
      debugPrint('inOrOut: ${meetingEventModel.inOrOut}');
    } catch (err) {
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // validate field for submitting an excuse for a meeting
  void validateExcuseField() async {
    if (excuseTEC.text.isEmpty) {
      showErrorToast('Please enter your excuse for the meeting or event');
      return;
    }
    setSubmitting(true);
    int clockingId = await getClockingId(
      meetingEventModel: selectedMeeting,
    ); // retrieve clocking id
    await submitExcuse(
      meetingId: selectedMeeting.id!,
      clockingId: clockingId,
      excuse: excuseTEC.text.trim(),
    ); // s
  }

  Future<void> submitExcuse({
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
      showNormalToast(response.message ??
          'Hi there, you\'ve already submitted an excuse for this meeting');
      excuseTEC.clear();
      setSubmitting(false);
    } catch (err) {
      setSubmitting(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }
}
