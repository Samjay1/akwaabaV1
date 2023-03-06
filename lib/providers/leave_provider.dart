import 'package:akwaaba/Networks/api_helpers/api_exception.dart';
import 'package:akwaaba/Networks/leave_api.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/models/general/absent_leave.dart';
import 'package:akwaaba/models/general/leave_status.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveProvider extends ChangeNotifier {
  bool _loading = false;
  bool _loadingMore = false;

  List<LeaveStatus> _leaveStatuses = [];
  List<AbsentLeave> _absentLeaveList = [];

  final TextEditingController reasonTEC = TextEditingController();

  List<LeaveStatus> get leaveStatuses => _leaveStatuses;
  List<AbsentLeave> get absentLeaveList => _absentLeaveList;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  LeaveStatus? selectedLeaveStatus;

  BuildContext? _context;

  bool get loading => _loading;

  bool get loadingMore => _loadingMore;

  BuildContext get currentContext => _context!;

  String search = '';

  // pagination variables
  int _page = 1;
  var limit = AppConstants.pageLimit;
  var isFirstLoadRunning = false;
  var hasNextPage = true;
  var isLoadMoreRunning = false;

  late ScrollController scrollController = ScrollController()
    ..addListener(_loadMoreAbsentLeave);

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

  // Future<void> refreshList() async {
  //   if (selectedPastMeetingEvent == null) {
  //     showErrorToast('Please select a date and meeting or event to proceed');
  //     return;
  //   }
  //   search = '';
  //   await getAttendanceHistory();
  // }

  // get list of branches
  Future<void> getAbsentLeaveStatuses() async {
    try {
      var userBranch = await getUserBranch(currentContext);
      _leaveStatuses =
          await LeaveAPI.getAbsentLeaveStatuses(branchId: userBranch.id!);
      debugPrint('Statuses: ${_leaveStatuses.toString()}');
    } catch (err) {
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  void validateInputFields() {
    if (selectedStartDate == null || selectedEndDate == null) {
      showErrorToast('Please select start and end date to proceed');
      return;
    }
    if (selectedLeaveStatus == null) {
      showErrorToast('Please select absent or leave status to proceed');
      return;
    }
    if (reasonTEC.text.isEmpty) {
      showErrorToast('Please type in your reason to proceed');
      return;
    }
    applyLeaveExcuse();
  }

  void validateFilterFields() {
    if (selectedStartDate == null || selectedEndDate == null) {
      showErrorToast('Please select start and end date to proceed');
      return;
    }
    getAllAbsentLeave();
  }

  // apply absent or leave

  Future<void> applyLeaveExcuse() async {
    try {
      setLoading(true);
      var message = await LeaveAPI.createAbsentLeave(
        statusId: selectedLeaveStatus!.id!,
        fromDate: selectedStartDate!.toIso8601String().substring(0, 10),
        toDate: selectedEndDate!.toIso8601String().substring(0, 10),
        memberId: Provider.of<MemberProvider>(currentContext, listen: false)
            .memberProfile
            .user
            .id,
        reason: reasonTEC.text.trim(),
      );
      if (currentContext.mounted) Navigator.pop(currentContext);
      setLoading(false);
      showNormalToast(message);
      debugPrint('Statuses: ${_leaveStatuses.toString()}');
    } catch (err) {
      setLoading(false);
      debugPrint('Error Branch: ${err.toString()}');
      showErrorToast(err.toString());
    }
    notifyListeners();
  }

  // get all assigned absent or leaves
  Future<void> getAllAbsentLeave() async {
    setLoading(true);
    var userBranch =
        await getUserBranch(currentContext); // get current user branch
    // search with member name if account type is member else
    search = search.isNotEmpty ? search : '';
    try {
      _page = 1;
      var response = await LeaveAPI.getAllAbsentLeave(
        page: _page,
        branchId: userBranch.id!,
        search: search,
        fromDate: selectedStartDate == null
            ? ''
            : selectedStartDate!.toIso8601String().substring(0, 10),
        toDate: selectedEndDate == null
            ? ''
            : selectedEndDate!.toIso8601String().substring(0, 10),
      );

      _absentLeaveList = response;

      debugPrint('Absent Leave: ${_absentLeaveList.length}');

      setLoading(false);
    } catch (err) {
      setLoading(false);
      debugPrint('Error ABL: ${err.toString()}');
      if (err is FetchDataException) {
        // ignore: use_build_context_synchronously
        showIndefiniteSnackBar(
            context: currentContext,
            message: err.toString(),
            onPressed: () => getAllAbsentLeave());
      }
      //showErrorToast('No records found');
    }
    notifyListeners();
  }

  // get more attendance history for a meeting
  Future<void> _loadMoreAbsentLeave() async {
    if (hasNextPage == true &&
        loading == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      setLoadingMore(true); // show loading indicator
      _page += 1;
      try {
        var userBranch =
            await getUserBranch(currentContext); // get current user branch
        var response = await LeaveAPI.getAllAbsentLeave(
          page: _page,
          branchId: userBranch.id!,
          search: search,
          fromDate: selectedStartDate!.toIso8601String().substring(0, 10),
          toDate: selectedEndDate!.toIso8601String().substring(0, 10),
        );

        if (response.isNotEmpty) {
          _absentLeaveList.addAll(response);
        } else {
          hasNextPage = false;
        }

        setLoadingMore(false);
      } catch (err) {
        setLoadingMore(false);
        debugPrint('Error ABL: ${err.toString()}');
        if (err is FetchDataException) {
          // ignore: use_build_context_synchronously
          showIndefiniteSnackBar(
              context: currentContext,
              message: err.toString(),
              onPressed: _loadMoreAbsentLeave);
        }
        //showErrorToast(err.toString());
      }
    }
    notifyListeners();
  }

  void clearFilters() {
    selectedStartDate = null;
    selectedEndDate = null;
    notifyListeners();
  }

  Future<void> clearData() async {
    _absentLeaveList.clear();
    clearFilters();
  }
}
