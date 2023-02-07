import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/attendance_api.dart';
import 'package:akwaaba/Networks/clocking_api.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfClockingProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;
  bool _clocking = false;
  bool _submitting = false;

  final TextEditingController searchTEC = TextEditingController();
  final TextEditingController minAgeTEC = TextEditingController();
  final TextEditingController maxAgeTEC = TextEditingController();

  List<Attendee?> _absentees = [];

  final List<Attendee?> _selectedAbsentees = [];

  List<Attendee?> _attendees = [];

  final List<Attendee?> _selectedAttendees = [];

  DateTime? selectedDate;

  MeetingEventModel? _meetingEventModel;

  BuildContext? _context;

  // Retrieve all meetings

  List<Attendee?> get absentees => _absentees;

  List<Attendee?> get attendees => _attendees;

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

  String searchName = '';
  String searchIdentity = '';

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

  Future<void> refreshList() async {
    clearFilters();
    await getAllAbsentees(
      meetingEventModel: selectedCurrentMeeting,
    );
  }

  // initial loading of members or absentees for a meeting
  Future<void> getAllAbsentees({
    required MeetingEventModel meetingEventModel,
  }) async {
    //var userBranch = await getUserBranch(currentContext);
    try {
      setLoading(true);
      _absenteesPage = 1;
      var response = await ClockingAPI.getAbsenteesList(
        page: _absenteesPage,
        meetingEventModel: meetingEventModel,
        branchId: meetingEventModel.branchId,
        filterDate: getFilterDate(),
        searchName: searchName.isEmpty ? '' : searchName,
        searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
        memberCategoryId: '',
        groupId: '',
        subGroupId: '',
        genderId: '',
        fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
        toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
      );

      _selectedAbsentees.clear();

      if (response.results != null || response.results!.isNotEmpty) {
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
      } else {
        _absentees.clear();
      }

      getAllAttendees(
        meetingEventModel: meetingEventModel,
      );
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
          branchId: selectedCurrentMeeting.branchId,
          filterDate: getFilterDate(),
          searchName: searchName.isEmpty ? '' : searchName,
          searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
          memberCategoryId: '',
          groupId: '',
          subGroupId: '',
          genderId: '',
          fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
          toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
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
        branchId: meetingEventModel.branchId,
        filterDate: getFilterDate(),
        searchName: searchName.isEmpty ? '' : searchName,
        searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
        memberCategoryId: '',
        groupId: '',
        subGroupId: '',
        genderId: '',
        fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
        toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
      );

      _selectedAttendees.clear();

      if (response.results != null || response.results!.isNotEmpty) {
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
      } else {
        _attendees.clear();
      }

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
      // get current user branch
      try {
        var response = await ClockingAPI.getAttendeesList(
          page: _attendeesPage,
          meetingEventModel: selectedCurrentMeeting,
          branchId: selectedCurrentMeeting.branchId,
          filterDate: selectedDate == null
              ? getFilterDate()
              : selectedDate!.toIso8601String().substring(0, 10),
          searchName: searchName.isEmpty ? '' : searchName,
          searchIdentity: searchIdentity.isEmpty ? '' : searchIdentity,
          memberCategoryId: '',
          groupId: '',
          subGroupId: '',
          genderId: '',
          fromAge: minAgeTEC.text.isEmpty ? '' : minAgeTEC.text,
          toAge: maxAgeTEC.text.isEmpty ? '' : maxAgeTEC.text,
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
    searchName = '';
    searchIdentity = '';
    searchTEC.clear();
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
      // Perform individual clock-in
      var response = await ClockingAPI.clockIn(
        clockingId: attendee!.attendance!.id!,
        time: time ?? getCurrentClockingTime(),
      );
      if (context.mounted) Navigator.of(context).pop();
      clearData(); // clear list after operation
      // refresh list when there is bulk operation
      showNormalToast('You\'re Welcome');
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
      // Perform individual clock-out
      var response = await ClockingAPI.clockOut(
        clockingId: attendee!.attendance!.id!,
        time: time ?? getCurrentClockingTime(),
      );
      if (context.mounted) Navigator.of(context).pop();
      clearData(); // clear list after operation
      showNormalToast('Good Bye!');
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

      // Perform individual start break
      var response = await ClockingAPI.startBreak(
        clockingId: attendee!.attendance!.id!,
        time: time ?? getCurrentClockingTime(),
      );

      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        clearData(); // clear list after operation
        showNormalToast(response.message!);
      }
      if (context.mounted) Navigator.of(context).pop();
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

      // Perform individual start break
      var response = await ClockingAPI.endBreak(
        clockingId: attendee!.attendance!.id!,
        time: time ?? getCurrentClockingTime(),
      );

      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        clearData(); // clear list after operation
        showNormalToast(response.message!);
        debugPrint("SUCCESS ${response.message}");
      }
      if (context.mounted) Navigator.of(context).pop();
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

      // Perform individual start break
      var response = await ClockingAPI.cancelClocking(
        clockingId: attendee!.attendance!.id!,
        time: time ?? getCurrentClockingTime(),
      );

      if (response.message == null) {
        showErrorToast(response.nonFieldErrors![0]);
      } else {
        clearData(); // clear list after operation
        showNormalToast(response.message!);
        debugPrint("SUCCESS ${response.message}");
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void clearData() {
    clearFilters();
    _attendees.clear();
    _absentees.clear();
    _selectedAttendees.clear();
    _selectedAbsentees.clear();
  }
}
