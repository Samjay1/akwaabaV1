import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeProvider extends ChangeNotifier {
  String? _memberToken;
  bool _loading = false;
  bool _loadingMore = false;
  bool _clocking = false;
  bool _submitting = false;
  BuildContext? _context;

  List<int> meetingEventIds = [];

  List<MeetingEventModel> _todayMeetingEventList = [];
  List<MeetingEventModel> _upcomingMeetingEventList = [];

  MeetingEventModel? _meetingEventModel;

  final TextEditingController excuseTEC = TextEditingController();

  Position? _currentUserLocation;

  // Retrieve all meetings
  List<MeetingEventModel> get todayMeetings => _todayMeetingEventList;
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;

  MeetingEventModel get selectedMeeting => _meetingEventModel!;

  get currentUserLocation => _currentUserLocation;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get clocking => _clocking;
  bool get submitting => _submitting;
  get memberToken => _memberToken;
  BuildContext get currentContext => _context!;

  int _page = 1;
  var isFirstLoadRunning = false;
  var hasNext = false;
  var isLoadMoreRunning = false;

  late ScrollController scrollController = ScrollController()
    ..addListener(_loadMoreTodayMeetingEvents);

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
    debugPrint("Clocking: $_clocking");
    notifyListeners();
  }

  setSelectedMeeting(MeetingEventModel meetingEventModel) {
    _meetingEventModel = meetingEventModel;
    notifyListeners();
  }

  setCurrentContext(BuildContext context) {
    _context = context;
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

  Future<void> getTodayMeetingEvents() async {
    setLoading(true);
    try {
      _page = 1;
      var branch = await getUserBranch(currentContext);
      var response = await EventAPI.getTodayMeetingEventList(
        branchId: branch.id!,
        page: _page,
      );
      _todayMeetingEventList = response.results!;
      hasNext = response.next == null ? false : true;
      debugPrint("TODAY Meeting: ${_todayMeetingEventList.length}");
      if (_todayMeetingEventList.isNotEmpty) {
        for (var meeting in _todayMeetingEventList) {
          await checkClockedMeetings(
            meetingEventModel: meeting,
            branchId: meeting.branchId!,
          );
        }
      } else {
        setLoading(false);
      }
    } catch (err) {
      debugPrint('Error TM ${err.toString()}');
      //showErrorToast(err.toString());
    }

    notifyListeners();
  }

  // load more list of events or meetings
  Future<void> _loadMoreTodayMeetingEvents() async {
    if (hasNext &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      setLoadingMore(true); // show loading indicator
      _page += 1; // increase page by 1
      try {
        var branch = await getUserBranch(currentContext);
        var response = await EventAPI.getTodayMeetingEventList(
          branchId: branch.id!,
          page: _page,
        );
        if (response.results!.isNotEmpty) {
          hasNext = response.next == null ? false : true;
          _todayMeetingEventList.addAll(response.results!);
        } else {
          hasNext = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("Error --> $err");
        showIndefiniteSnackBar(
            context: currentContext,
            message: err.toString(),
            onPressed: () => _loadMoreTodayMeetingEvents());
      }
    }
    notifyListeners();
  }

  // Future<void> getUpcomingMeetingEvents({
  //   required var memberToken,
  //   required BuildContext context,
  // }) async {
  //   _upcomingMeetingEventList.clear();
  //   setLoading(true);
  //   try {
  //     _upcomingMeetingEventList = await EventAPI.getUpcomingMeetingEventList();
  //     getCurrentUserLocation();
  //     // getAttendanceList();
  //     getTodayMeetingEvents(
  //       memberToken: memberToken,
  //       context: context,
  //     );
  //   } catch (err) {
  //     debugPrint('Error UM ${err.toString()}');
  //     showErrorToast(err.toString());
  //   }

  //   notifyListeners();
  // }

  // queries for coordinates of a particular meeting
  Future<void> getMeetingCoordinates({
    required BuildContext context,
    required bool isBreak,
    required MeetingEventModel meetingEventModel,
    required String? time,
  }) async {
    //setClocking(true);
    try {
      showLoadingDialog(context);
      getCurrentUserLocation();

      var response = await EventAPI.getMeetingCoordinates(
        meetingEventModel: meetingEventModel,
      );
      // debugPrint("Latitude: ${response.results![0].latitude}");
      // debugPrint("Longitude: ${response.results![0].longitude}");
      if (response.results == null || response.results!.isEmpty) {
        if (context.mounted) {
          Navigator.of(context).pop();
          showInfoDialog(
            'ok',
            context: context,
            title: 'Hey there!',
            content:
                'Sorry, we were unable to get your meeting location. Please contact your admin and try again.',
            onTap: () => Navigator.pop(context),
          );
        }
        return;
      }

      double calculatedRadius = calculateDistance(
        currentUserLocation.latitude,
        currentUserLocation.longitude,
        double.parse(response.results![0].latitude!),
        double.parse(response.results![0].longitude!),
      );

      if (calculatedRadius <= response.results![0].radius!) {
        if (context.mounted) {
          debugPrint('You\'re within the radius of the premise');
          await getAttendanceList(
            context: context,
            meetingEventModel: meetingEventModel,
            time: null,
            isBreak: isBreak,
          );
        }
      } else {
        if (context.mounted) {
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
      }
      debugPrint('Meeting Lat: ${response.results![0].latitude!}');
      debugPrint('Meeting Lng: ${response.results![0].longitude!}');
    } catch (err) {
      Navigator.of(context).pop();
      debugPrint('Error MC: ${err.toString()}');
      showInfoDialog(
        'ok',
        context: context,
        title: 'Hey there!',
        content:
            'Sorry, an unexpected error occurred when getting the meeting or event coordinates.  Please be sure you have turned on your location and try again.',
        onTap: () => Navigator.pop(context),
      );
      //showErrorToast('An unexpected error occurred. Please try again!');
    }

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
    var response = await EventAPI.getAttendanceList(
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
      var response = await EventAPI.getAttendanceList(
        meetingEventModel: meetingEventModel,
        filterDate: getFilterDate(),
      );
      if (isBreak) {
        if (response.results!.isNotEmpty) {
          var clockingId = response.results![0].id!;
          if (response.results![0].inOrOut!) {
            if (response.results![0].startBreak == null &&
                response.results![0].endBreak == null) {
              // user has not started a break
              // so start break
              if (context.mounted) {
                startMeetingBreak(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null,
                );
              }
            } else if (response.results![0].startBreak != null &&
                response.results![0].endBreak == null) {
              // user has started a break
              // so end break
              if (context.mounted) {
                endMeetingBreak(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null,
                );
              }
            } else if (response.results![0].startBreak != null &&
                response.results![0].endBreak != null) {
              // user has started and ended a break
              // so show message
              if (context.mounted) {
                Navigator.pop(context);
                showNormalToast('You\'ve already ended your break. Good Bye!');
              }
            }
          } else {
            showNormalToast(
              'Hi there, you\'ve not clocked in. \nPlease clock-in before you can start your break.',
            );
          }
          //debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
        } else {
          if (context.mounted) {
            showInfoDialog(
              'ok',
              context: context,
              title: 'Hey there!',
              content:
                  'Sorry, you can\'t clock because you are not assigned to this meeting. Please contact your admin for asssistance.',
              onTap: () => Navigator.pop(context),
            );
          }
        }
      } else {
        if (response.results!.isNotEmpty) {
          var clockingId = response.results![0].id!;
          if (response.results![0].inOrOut!) {
            if (response.results![0].outTime == null) {
              // user has not clocked out
              // so clock user out of meeting
              if (context.mounted) {
                clockMemberOut(
                  context: context,
                  clockingId: clockingId,
                  meetingEventModel: meetingEventModel,
                  time: null,
                );
              }
            } else {
              // user has already clocked out
              // hide loading widget
              // and display a user friendly message
              setClocking(false);
              showNormalToast('You\'ve already clocked out. Good Bye!');
            }
          } else {
            if (context.mounted) {
              clockMemberIn(
                context: context,
                clockingId: clockingId,
                meetingEventModel: meetingEventModel,
                time: null,
              );
            }
          }
          //debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            showInfoDialog(
              'ok',
              context: context,
              title: 'Hey there!',
              content:
                  'Sorry, you can\'t clock because you are not assigned to this meeting. Please contact your admin for asssistance.',
              onTap: () => Navigator.pop(context),
            );
          }
        }
      }
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ATL: ${err.toString()}');
      //showErrorToast(err.toString());
    }
  }

// clocks a member in of a meeting or event
  Future<void> clockMemberIn(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await EventAPI.clockIn(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      showNormalToast('You\'re Welcome');
      if (context.mounted) Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error: ${err.toString()}');
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> clockMemberOut(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await EventAPI.clockOut(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      showNormalToast('Good Bye!');
      if (context.mounted) Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      //showErrorToast(err.toString());
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
      var response = await EventAPI.startBreak(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );

      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        // update fields of meeting event model
        meetingEventModel.inOrOut = response.inOrOut;
        meetingEventModel.startBreak = response.startBreak;
        meetingEventModel.endBreak = response.endBreak;
        meetingEventModel.inTime = response.inTime;
        meetingEventModel.outTime = response.outTime;
        showNormalToast('Enjoy Break Time!');
      }
      if (context.mounted) Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      //showErrorToast(err.toString());
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
      var response = await EventAPI.endBreak(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      //showNormalToast('Welcome Back!');
      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        // update fields of meeting event model
        meetingEventModel.inOrOut = response.inOrOut;
        meetingEventModel.startBreak = response.startBreak;
        meetingEventModel.endBreak = response.endBreak;
        meetingEventModel.inTime = response.inTime;
        meetingEventModel.outTime = response.outTime;
        showNormalToast('Welcome Back!');
      }
      if (context.mounted) Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

// checks if member has clcoked in for a meeting
  Future<void> checkClockedMeetings({
    required MeetingEventModel meetingEventModel,
    required int branchId,
  }) async {
    try {
      final currentDate =
          DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
              .substring(0, 10)
              .trim();
      var response = await EventAPI.getAttendanceList(
        meetingEventModel: meetingEventModel,
        filterDate: currentDate,
      );
      if (response.results!.isNotEmpty) {
        meetingEventModel.inOrOut = response.results![0].inOrOut;
        meetingEventModel.startBreak = response.results![0].startBreak;
        meetingEventModel.endBreak = response.results![0].endBreak;
        meetingEventModel.inTime = response.results![0].inTime;
        meetingEventModel.outTime = response.results![0].outTime;
      }
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error CCM: ${err.toString()}');
      //showErrorToast(err.toString());
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
    if (context.mounted) {
      await submitExcuse(
        context: context,
        meetingId: selectedMeeting.id!,
        clockingId: clockingId,
        excuse: excuseTEC.text.trim(),
      );
    }
  }

  Future<void> submitExcuse({
    required BuildContext context,
    required int meetingId,
    required int clockingId,
    required String excuse,
  }) async {
    try {
      var response = await EventAPI.submitExcuse(
        meetingEventId: meetingId,
        clockingId: clockingId,
        excuse: excuse,
      );
      setSubmitting(false);
      if (context.mounted) Navigator.of(context).pop();
      showErrorToast(
          'You\'ve already submitted an excuse for this meeting. Thank you');
      excuseTEC.clear();
    } catch (err) {
      setSubmitting(false);
      debugPrint('Error: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void clearData() {
    _todayMeetingEventList.clear();
    _upcomingMeetingEventList.clear();
  }
}
