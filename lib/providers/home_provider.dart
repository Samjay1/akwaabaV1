import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/location/location_services.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
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

  Future<Position?> getCurrentUserLocation() async {
    return await LocationServices().getUserCurrentLocation();
  }

  Future<void> getTodayMeetingEvents() async {
    setLoading(true);
    try {
      _page = 1;
      var userType = await SharedPrefs().getUserType();
      // ignore: use_build_context_synchronously
      var branch = await getUserBranch(currentContext);
      var response = await EventAPI.getTodayMeetingEventList(
        branchId: branch.id!,
        page: _page,
      );
      _todayMeetingEventList = response.results!;
      hasNext = response.next == null ? false : true;
      debugPrint("TODAY Meeting: ${_todayMeetingEventList.length}");
      if (_todayMeetingEventList.isNotEmpty) {
        if (userType == AppConstants.member) {
          for (var meeting in _todayMeetingEventList) {
            await checkClockedMeetings(
              meetingEventModel: meeting,
              branchId: meeting.branchId!,
            );
          }
        } else {
          setLoading(false);
        }
      } else {
        setLoading(false);
      }
    } catch (err) {
      debugPrint('Error TM: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => getTodayMeetingEvents(),
        );
      }
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
        if (err is FetchDataException) {
          showIndefiniteSnackBar(
            context: currentContext,
            message: err.toString(),
            onPressed: _loadMoreTodayMeetingEvents,
          );
        }
      }
    }
    notifyListeners();
  }

  var isLocationLoaded = false;

  // queries for coordinates of a particular meeting
  Future<void> getMeetingCoordinates({
    required BuildContext context,
    required bool isBreak,
    required bool isVirtual,
    required MeetingEventModel meetingEventModel,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);

      Position? currentUserLocation = await getCurrentUserLocation();

      if (meetingEventModel.locationInfo == null &&
          meetingEventModel.locationInfo!.isEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
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

      double distanceInKilometers = calculateDistanceInKilo(
        currentUserLocation!.latitude,
        currentUserLocation.longitude,
        double.parse(meetingEventModel.locationInfo![0].latitude!),
        double.parse(meetingEventModel.locationInfo![0].longitude!),
      );

      if (distanceInKilometers <= meetingEventModel.locationInfo![0].radius!) {
        if (context.mounted) {
          debugPrint('You\'re within the radius of the premise');
          await getAttendanceList(
              context: context,
              meetingEventModel: meetingEventModel,
              time: null,
              isBreak: isBreak,
              isVirtual: isVirtual);
        }
      } else {
        if (context.mounted) {
          debugPrint('You\'re not within the radius of the premise');
          Navigator.pop(context);
          showInfoDialog(
            'ok',
            context: context,
            title: AppString.heyThereTitle,
            content:
                'Sorry, it looks like you\'re not within the specified location radius. Please get closer and try again.',
            onTap: () => Navigator.pop(context),
          );
        }
      }
      debugPrint('Calculated distance: $distanceInKilometers km');
      debugPrint('Current Location Lat: ${currentUserLocation.latitude}');
      debugPrint('Current Location Lng: ${currentUserLocation.longitude}');
      debugPrint('Meeting Lat: ${meetingEventModel.locationInfo![0].latitude}');
      debugPrint(
          'Meeting Lng: ${meetingEventModel.locationInfo![0].longitude}');
      debugPrint(
          'Meeting Radius: ${meetingEventModel.locationInfo![0].radius}');
    } catch (err) {
      debugPrint('Error MC: ${err.toString()}');
      Navigator.pop(context);
      showInfoDialog(
        'ok',
        context: context,
        title: AppString.heyThereTitle,
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
    required bool isVirtual,
    required MeetingEventModel meetingEventModel,
    required String? time,
  }) async {
    try {
      showLoadingDialog(context);
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
            } else if (meetingEventModel.breakInfo!.isNotEmpty &&
                (DateTime.now().isAfter(DateTime.parse(
                        meetingEventModel.breakInfo![0].endBreak!)) &&
                    response.results![0].startBreak == null)) {
              // user wants to start break after end break time
              // so show message
              if (context.mounted) {
                Navigator.pop(context);
                showInfoDialog(
                  'ok',
                  context: context,
                  title: AppString.heyThereTitle,
                  content:
                      'Sorry, you cannot start break at this time because break time is over. Thank you.',
                  onTap: () => Navigator.pop(context),
                );
              }
            } else if (meetingEventModel.breakInfo!.isNotEmpty &&
                (DateTime.now().isBefore(DateTime.parse(
                        meetingEventModel.breakInfo![0].startBreak!)) &&
                    response.results![0].startBreak == null)) {
              // user wants to start break before break starts
              // so show message
              if (context.mounted) {
                Navigator.pop(context);
                showInfoDialog(
                  'ok',
                  context: context,
                  title: AppString.heyThereTitle,
                  content:
                      'Sorry, you cannot start break at this time because time is not up for break. Thank you.',
                  onTap: () => Navigator.pop(context),
                );
              }
            } else if (response.results![0].startBreak != null &&
                response.results![0].endBreak != null) {
              // user has started and ended a break
              // so show message
              if (context.mounted) {
                Navigator.pop(context);
                showInfoDialog(
                  'ok',
                  context: context,
                  title: AppString.heyThereTitle,
                  content:
                      'Sorry, you have already ended your break. Good Bye!',
                  onTap: () => Navigator.pop(context),
                );
              }
            }
          } else {
            if (context.mounted) {
              Navigator.pop(context);
              showInfoDialog(
                'ok',
                context: context,
                title: AppString.heyThereTitle,
                content:
                    'Sorry, you have not clocked in. \nPlease clock in before you can start your break',
                onTap: () => Navigator.pop(context),
              );
            }
          }
          //debugPrint('ClockedIn: ${response.results![0].inOrOut!}');
        } else {
          if (context.mounted) {
            showInfoDialog(
              'ok',
              context: context,
              title: AppString.heyThereTitle,
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
                if (isVirtual) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    joinVirtualMeeting(
                      context: context,
                      meetingEventModel: meetingEventModel,
                    );
                  }
                } else {
                  clockMemberOut(
                    context: context,
                    clockingId: clockingId,
                    meetingEventModel: meetingEventModel,
                    time: null,
                  );
                }
              }
            } else {
              // user has already clocked out
              // hide loading widget
              // and display a user friendly message
              setClocking(false);
              if (context.mounted) {
                showInfoDialog(
                  'ok',
                  context: context,
                  title: AppString.heyThereTitle,
                  content: 'Sorry, you have already clocked out. Good Bye!.',
                  onTap: () => Navigator.pop(context),
                );
              }
            }
          } else {
            if (context.mounted) {
              clockMemberIn(
                context: context,
                clockingId: clockingId,
                isVirtual: isVirtual,
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
              title: AppString.heyThereTitle,
              content:
                  'Sorry, you can\'t clock because you are not assigned to this meeting. Please contact your admin for asssistance.',
              onTap: () => Navigator.pop(context),
            );
          }
        }
      }
    } catch (err) {
      if (context.mounted) Navigator.pop(context);
      debugPrint('Error ATL: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => getAttendanceList(
              context: context,
              isBreak: isBreak,
              isVirtual: isVirtual,
              meetingEventModel: meetingEventModel,
              time: time),
        );
      }
      //showErrorToast(err.toString());
    }
  }

  // clocks a member in of a meeting or event
  Future<void> clockMemberIn(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel,
      required bool isVirtual,
      required int clockingId,
      required String? time}) async {
    try {
      var response = await EventAPI.clockIn(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );
      if (response.nonFieldErrors != null &&
          response.nonFieldErrors!.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          showInfoDialog(
            'ok',
            context: context,
            title: AppString.heyThereTitle,
            content: response.nonFieldErrors![0],
            onTap: () => Navigator.pop(context),
          );
        }
        return;
      }
      if (context.mounted) Navigator.pop(context);
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      // when meeting is virtual
      if (isVirtual) {
        if (context.mounted) {
          joinVirtualMeeting(
            context: context,
            meetingEventModel: meetingEventModel,
          );
        }
      } else {
        showNormalToast('You\'re Welcome');
      }
    } catch (err) {
      if (context.mounted) Navigator.pop(context);
      debugPrint('Clock in error: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => clockMemberIn(
              context: context,
              meetingEventModel: meetingEventModel,
              isVirtual: isVirtual,
              clockingId: clockingId,
              time: time),
        );
      }
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
      if (response.nonFieldErrors != null &&
          response.nonFieldErrors!.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          showInfoDialog(
            'ok',
            context: context,
            title: AppString.heyThereTitle,
            content: response.nonFieldErrors![0],
            onTap: () => Navigator.pop(context),
          );
        }
        return;
      }
      if (context.mounted) Navigator.pop(context);
      meetingEventModel.inOrOut = response.inOrOut; // update clock status
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      showNormalToast('Good Bye!');
    } catch (err) {
      if (context.mounted) Navigator.pop(context);
      debugPrint('Clock out error: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => clockMemberOut(
              context: context,
              meetingEventModel: meetingEventModel,
              clockingId: clockingId,
              time: time),
        );
      }
      //showErrorToast(err.toString());
    }
    notifyListeners();
  }

// starts break time for meeting
  Future<void> startMeetingBreak({
    required BuildContext context,
    required MeetingEventModel meetingEventModel,
    required int clockingId,
    required String? time,
  }) async {
    try {
      var response = await EventAPI.startBreak(
        clockingId: clockingId,
        time: time ?? getClockingTime(),
      );

      if (response.nonFieldErrors != null &&
          response.nonFieldErrors!.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          showInfoDialog(
            'ok',
            context: context,
            title: AppString.heyThereTitle,
            content: response.nonFieldErrors![0],
            onTap: () => Navigator.pop(context),
          );
        }
        return;
      }
      if (context.mounted) Navigator.pop(context);
      // update fields of meeting event model
      meetingEventModel.inOrOut = response.inOrOut;
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      showNormalToast('Enjoy Break Time!');
    } catch (err) {
      if (context.mounted) Navigator.pop(context);
      debugPrint('Start break error: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => startMeetingBreak(
              context: context,
              meetingEventModel: meetingEventModel,
              clockingId: clockingId,
              time: time),
        );
      }
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
      if (response.nonFieldErrors != null &&
          response.nonFieldErrors!.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          showInfoDialog(
            'ok',
            context: context,
            title: AppString.heyThereTitle,
            content: response.nonFieldErrors![0],
            onTap: () => Navigator.pop(context),
          );
        }
        return;
      }
      if (context.mounted) Navigator.pop(context);
      // update fields of meeting event model
      meetingEventModel.inOrOut = response.inOrOut;
      meetingEventModel.startBreak = response.startBreak;
      meetingEventModel.endBreak = response.endBreak;
      meetingEventModel.inTime = response.inTime;
      meetingEventModel.outTime = response.outTime;
      showNormalToast('Welcome Back!');
    } catch (err) {
      if (context.mounted) Navigator.pop(context);
      debugPrint('End break error: ${err.toString()}');
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => endMeetingBreak(
            context: context,
            meetingEventModel: meetingEventModel,
            clockingId: clockingId,
            time: time,
          ),
        );
      }
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
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => checkClockedMeetings(
            meetingEventModel: meetingEventModel,
            branchId: branchId,
          ),
        );
      }
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
      if (err is FetchDataException) {
        showIndefiniteSnackBar(
          context: currentContext,
          message: err.toString(),
          onPressed: () => submitExcuse(
            context: context,
            meetingId: meetingId,
            clockingId: clockingId,
            excuse: excuse,
          ),
        );
      }
      // showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // allow member to join virtual meeting
  void joinVirtualMeeting(
      {required BuildContext context,
      required MeetingEventModel meetingEventModel}) {
    debugPrint("Virtual URL: ${meetingEventModel.virtualMeetingLink}");
    launchURL(meetingEventModel.virtualMeetingLink!);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => WebViewPage(
    //       url: meetingEventModel.virtualMeetingLink,
    //       title: meetingEventModel.name,
    //     ),
    //   ),
    // );
  }

  void clearData() {
    _todayMeetingEventList.clear();
    _upcomingMeetingEventList.clear();
  }
}
