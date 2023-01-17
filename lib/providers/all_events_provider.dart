import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllEventsProvider extends ChangeNotifier {
  bool _loading = false;
  bool _filter = false;
  bool _loadingMore = false;
  List<MeetingEventModel> _upcomingMeetingEventList = [];
  List<MeetingEventModel> _tempUpcomingMeetingEventList = [];
  List<MeetingEventModel> _eventsList = [];
  List<MeetingEventModel> _meetingsList = [];

  // Retrieve all meetings
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;
  List<MeetingEventModel> get eventsList => _eventsList;
  List<MeetingEventModel> get meetingsList => _meetingsList;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get filter => _filter;

  int _page = 1;
  var isFirstLoadRunning = false;
  var hasNextPage = true;
  var isLoadMoreRunning = false;

  DateTime? selectedDate;

  String? userType;

  late ScrollController scrollController = ScrollController()
    ..addListener(_loadMoreEventMeetings);

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setFilter(bool filter) {
    _filter = filter;
    notifyListeners();
  }

  setLoadingMore(bool loading) {
    _loadingMore = loading;
    notifyListeners();
  }

  Future<void> getUpcomingMeetingEvents() async {
    _upcomingMeetingEventList.clear();
    setLoading(true);
    try {
      _page = 1;
      _upcomingMeetingEventList = await EventAPI.getUpcomingMeetingEventList(
        page: _page,
      );
      _tempUpcomingMeetingEventList = _upcomingMeetingEventList;
      _eventsList = _upcomingMeetingEventList
          .where(
              (meeting) => meeting.memberType == AppConstants.meetingTypeEvent)
          .toList();
      _meetingsList = _upcomingMeetingEventList
          .where((meeting) =>
              meeting.memberType == AppConstants.meetingTypeMeeting)
          .toList();
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error UM ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // load more list of events or meetings
  Future<void> _loadMoreEventMeetings() async {
    if (hasNextPage == true &&
        loading == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _page += 1; // increase page by 1
      try {
        var response;
        if (_filter) {
          response = await EventAPI.getMeetingsFromDate(
            page: _page,
            date: selectedDate!.toIso8601String().substring(0, 10),
          );
        } else {
          response = await EventAPI.getUpcomingMeetingEventList(
            page: _page,
          );
        }
        if (response.isNotEmpty) {
          _upcomingMeetingEventList.addAll(response);
        } else {
          hasNextPage = false;
        }
        debugPrint("All upcomings: ${_upcomingMeetingEventList.length}");
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("Error --> $err");
      }
    }
    notifyListeners();
  }

  // filter event or meetings by date
  void filterByDate() {
    if (selectedDate == null) {
      showErrorToast('Please select date to proceed');
      return;
    }
    getPastMeetingEvents();
  }

  // get meetins from date specified
  Future<void> getPastMeetingEvents() async {
    setLoading(true);
    _upcomingMeetingEventList.clear();
    _page = 1;
    try {
      _upcomingMeetingEventList = await EventAPI.getMeetingsFromDate(
        page: _page,
        date: selectedDate!.toIso8601String().substring(0, 10),
      );
      _tempUpcomingMeetingEventList = _upcomingMeetingEventList;
      _eventsList = _upcomingMeetingEventList
          .where(
              (meeting) => meeting.memberType == AppConstants.meetingTypeEvent)
          .toList();
      _meetingsList = _upcomingMeetingEventList
          .where((meeting) =>
              meeting.memberType == AppConstants.meetingTypeMeeting)
          .toList();
      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error PMs: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> refreshList() async {
    await getUpcomingMeetingEvents();
  }

  // get current date and format for filtering
  String getCurrentDate() =>
      DateUtil.formatDate('yyyy-MM-dd', dateTime: DateTime.now())
          .substring(0, 10)
          .trim();

  void clearFilters() {
    selectedDate = null;
  }

  void clearData() {
    _upcomingMeetingEventList.clear();
  }

  // search through attendees list by name
  void searchEventMeetings({required String searchText}) {
    List<MeetingEventModel> results = [];
    if (searchText.isEmpty) {
      results = _tempUpcomingMeetingEventList;
    } else {
      results = _tempUpcomingMeetingEventList
          .where((meeting) => meeting.name!
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
    _upcomingMeetingEventList = results;
    notifyListeners();
  }
}
