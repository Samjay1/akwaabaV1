import 'package:akwaaba/Networks/event_api.dart';
import 'package:akwaaba/Networks/group_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Networks/api_responses/meeting_event_response.dart';

class AllEventsProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingFilters = false;
  bool _filter = false;
  bool _loadingMore = false;
  List<MeetingEventModel> _upcomingMeetingEventList = [];
  List<MeetingEventModel> _tempUpcomingMeetingEventList = [];
  List<MeetingEventModel> _eventsList = [];
  List<MeetingEventModel> _meetingsList = [];
  BuildContext? _context;
  Branch? selectedBranch;

  // Retrieve all meetings
  List<MeetingEventModel> get upcomingMeetings => _upcomingMeetingEventList;
  List<MeetingEventModel> get eventsList => _eventsList;
  List<MeetingEventModel> get meetingsList => _meetingsList;
  List<Branch> _branches = [];

  BuildContext get currentContext => _context!;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get filter => _filter;

  List<Branch> get branches => _branches;

  int _page = 1;
  var isFirstLoadRunning = false;
  var hasNext = true;
  var isLoadMoreRunning = false;

  DateTime? selectedDate;

  String? userType;

  bool get loadingFilters => _loadingFilters;

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

  setCurrentContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  setLoadingFilters(bool loading) {
    _loadingFilters = loading;
    notifyListeners();
  }

  // get list of branches
  Future<void> getBranches() async {
    setLoadingFilters(true);
    try {
      _branches = await GroupAPI.getBranches();
      setLoadingFilters(false);
      debugPrint('Branches: ${_branches.length}');
    } catch (err) {
      setLoadingFilters(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  Future<void> getUpcomingMeetingEvents() async {
    setLoading(true);
    try {
      _page = 1;
      var userBranch = await getUserBranch(currentContext);
      var response = await EventAPI.getUpcomingMeetingEventList(
          page: _page,
          branchId:
              selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
          date: selectedDate == null
              ? ''
              : selectedDate!.toIso8601String().substring(0, 10));
      hasNext = response.next == null ? false : true;
      _upcomingMeetingEventList = response.results!;
      _tempUpcomingMeetingEventList = _upcomingMeetingEventList;
      _eventsList = _upcomingMeetingEventList
          .where((meeting) => meeting.type == AppConstants.meetingTypeEvent)
          .toList();
      _meetingsList = _upcomingMeetingEventList
          .where((meeting) => meeting.type == AppConstants.meetingTypeMeeting)
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
    if (hasNext &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      setLoadingMore(true); // show loading indicator
      _page += 1; // increase page by 1
      try {
        MeetingEventResponse? response;
        var userBranch = await getUserBranch(currentContext);
        _filter
            ? response = await EventAPI.getMeetingsFromDate(
                page: _page,
                date: selectedDate!.toIso8601String().substring(0, 10),
                branchId: selectedBranch == null
                    ? userBranch.id!
                    : selectedBranch!.id!,
              )
            : response = await EventAPI.getUpcomingMeetingEventList(
                page: _page,
                branchId: selectedBranch == null
                    ? userBranch.id!
                    : selectedBranch!.id!,
                date: selectedDate == null
                    ? ''
                    : selectedDate!.toIso8601String().substring(0, 10));
        if (response.results!.isNotEmpty) {
          hasNext = response.next == null ? false : true;
          _upcomingMeetingEventList.addAll(response.results!);
          _tempUpcomingMeetingEventList.addAll(response.results!);
          _eventsList.addAll(response.results!
              .where((meeting) => meeting.type == AppConstants.meetingTypeEvent)
              .toList());
          _meetingsList.addAll(response.results!
              .where(
                  (meeting) => meeting.type == AppConstants.meetingTypeMeeting)
              .toList());
        } else {
          hasNext = false;
        }
        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint("Error --> $err");
        // showIndefiniteSnackBar(
        //     context: currentContext,
        //     message: err.toString(),
        //     onPressed: () => _loadMoreEventMeetings());
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
    getUpcomingMeetingEvents();
  }

  // get meetins from date specified
  Future<void> getPastMeetingEvents() async {
    setLoading(true);
    _page = 1;
    try {
      var userBranch = await getUserBranch(currentContext);
      var response = await EventAPI.getMeetingsFromDate(
        page: _page,
        date: selectedDate!.toIso8601String().substring(0, 10),
        branchId: selectedBranch == null ? userBranch.id! : selectedBranch!.id!,
      );
      hasNext = response.next == null ? false : true;
      _upcomingMeetingEventList = response.results!;
      _tempUpcomingMeetingEventList = _upcomingMeetingEventList;
      _eventsList = _upcomingMeetingEventList
          .where((meeting) => meeting.type == AppConstants.meetingTypeEvent)
          .toList();
      _meetingsList = _upcomingMeetingEventList
          .where((meeting) => meeting.type == AppConstants.meetingTypeMeeting)
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
    selectedBranch = null;
    getUpcomingMeetingEvents();
  }

  void clearData() {
    _upcomingMeetingEventList.clear();
    _meetingsList.clear();
    _eventsList.clear();
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
    _eventsList = results
        .where((meeting) => meeting.type == AppConstants.meetingTypeEvent)
        .toList();
    _meetingsList = results
        .where((meeting) => meeting.type == AppConstants.meetingTypeMeeting)
        .toList();
    notifyListeners();
  }
}
