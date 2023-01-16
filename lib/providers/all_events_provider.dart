import 'package:akwaaba/Networks/event_api.dart';
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

  // Retrieve all meetings
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;

  bool get loading => _loading;
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
      _upcomingMeetingEventList.clear();
      _page = 1;
      _upcomingMeetingEventList = await EventAPI.getUpcomingMeetingEventList(
        page: _page,
        date: null,
      );
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
            date: getCurrentDate(),
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

  // get meetins from date specified
  Future<void> getPastMeetingEvents() async {
    setLoading(true);
    try {
      _upcomingMeetingEventList.clear();
      _page = 1;
      _upcomingMeetingEventList = await EventAPI.getMeetingsFromDate(
        page: _page,
        date: selectedDate!.toIso8601String().substring(0, 10),
      );
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

  void clearData() {
    _upcomingMeetingEventList.clear();
  }
}
