import 'package:akwaaba/components/absent_leave_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/providers/leave_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ViewLeavePage extends StatefulWidget {
  const ViewLeavePage({Key? key}) : super(key: key);

  @override
  State<ViewLeavePage> createState() => _ViewLeavePageState();
}

class _ViewLeavePageState extends State<ViewLeavePage> {
  late LeaveProvider _leaveProvider;

  bool isTileExpanded = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<LeaveProvider>(context, listen: false)
          .setCurrentContext(context);
      Provider.of<LeaveProvider>(context, listen: false).getAllAbsentLeave();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (context.mounted) _leaveProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _leaveProvider = context.watch<LeaveProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("View Leave/Excuse Status"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            children: [
              SizedBox(
                height: isTileExpanded
                    ? displayHeight(context) * 0.25
                    : displayHeight(context) * 0.07,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      filterButton(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              CupertinoSearchTextField(
                padding: const EdgeInsets.all(AppPadding.p14),
                onChanged: (val) {
                  setState(() {
                    _leaveProvider.search = val;
                  });
                  _leaveProvider.getAllAbsentLeave();
                },
                onSubmitted: (val) {
                  setState(() {
                    _leaveProvider.search = val;
                  });
                  _leaveProvider.getAllAbsentLeave();
                },
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              _leaveProvider.loading
                  ? Expanded(
                      child: Shimmer.fromColors(
                        baseColor: greyColorShade300,
                        highlightColor: greyColorShade100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => const EventShimmerItem(),
                          itemCount: 20,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _leaveProvider.absentLeaveList.isEmpty
                                ? const EmptyStateWidget(
                                    text: 'No records found!',
                                  )
                                : ListView.builder(
                                    itemCount:
                                        _leaveProvider.absentLeaveList.length,
                                    physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics(),
                                    ),
                                    controller: _leaveProvider.scrollController,
                                    itemBuilder: (context, index) {
                                      return AbsentLeaveWidget(
                                        absentLeave: _leaveProvider
                                            .absentLeaveList[index],
                                      );
                                    }),
                          ),
                          if (_leaveProvider.loadingMore)
                            const PaginationLoader(
                              loadingText: 'Loading. please wait...',
                            )
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget filterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          initiallyExpanded: isTileExpanded,
          onExpansionChanged: (value) {
            setState(() {
              isTileExpanded = value;
            });
            debugPrint("Expanded: $isTileExpanded");
          },
          title: const Text(
            "Filter Options ",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[filterOptionsList()],
        ),
      ),
    );
  }

  Widget filterOptionsList() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LabelWidgetContainer(
                  label: "Start Date",
                  child: FormButton(
                    label: _leaveProvider.selectedStartDate == null
                        ? "Select Start Date"
                        : _leaveProvider.selectedStartDate!
                            .toIso8601String()
                            .substring(0, 10),
                    function: () async {
                      _leaveProvider.selectedStartDate =
                          await DateUtil.selectDate(
                        context: context,
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                width: displayWidth(context) * 0.03,
              ),
              Expanded(
                child: LabelWidgetContainer(
                  label: "End Date",
                  child: FormButton(
                    label: _leaveProvider.selectedEndDate == null
                        ? "Select End Date"
                        : _leaveProvider.selectedEndDate!
                            .toIso8601String()
                            .substring(0, 10),
                    function: () async {
                      _leaveProvider.selectedEndDate =
                          await DateUtil.selectDate(
                        context: context,
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () => _leaveProvider.clearFilters(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius:
                            BorderRadius.circular(AppRadius.borderRadius8),
                      ),
                      child: const Text(
                        'Clear',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    )),
              ),
              SizedBox(
                width: displayWidth(context) * 0.04,
              ),
              Expanded(
                child: CustomElevatedButton(
                  label: "Filter",
                  radius: AppRadius.borderRadius8,
                  function: () => _leaveProvider.validateFilterFields(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
