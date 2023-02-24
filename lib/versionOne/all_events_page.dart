import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/filter_loader.dart';
import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/all_events_provider.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/search_util.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../utils/app_theme.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({Key? key}) : super(key: key);

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  int selectedEventType = 0;

  late AllEventsProvider _eventsProvider;

  bool isShowTopView = true;

  bool isTileExpanded = false;

  final _debouncer = Debouncer(milliseconds: AppConstants.searchTimerDuration);

  void loadAllMeetingEvents() async {
    Future.delayed(Duration.zero, () {
      Provider.of<AllEventsProvider>(context, listen: false)
          .setCurrentContext(context);
      if (Provider.of<AllEventsProvider>(context, listen: false)
          .upcomingMeetings
          .isEmpty) {
        // load all upcoming events or meetings
        Provider.of<AllEventsProvider>(context, listen: false)
            .getUpcomingMeetingEvents();
      }
      if (context.read<ClientProvider>().branch.id == 1) {
        Provider.of<AllEventsProvider>(context, listen: false).getBranches();
      }

      setState(() {});
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            setState(() {
              isShowTopView = true;
            });

            break;
          case ScrollDirection.reverse:
            setState(() {
              isShowTopView = false;
            });
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  initState() {
    super.initState();
    loadAllMeetingEvents();
  }

  @override
  Widget build(BuildContext context) {
    _eventsProvider = context.watch<AllEventsProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: displayHeight(context),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isShowTopView
                ? SizedBox(
                    height: isTileExpanded
                        ? displayHeight(context) * 0.39
                        : displayHeight(context) * 0.07,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          filterButton(),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            //filterButton(),
            const SizedBox(
              height: 16,
            ),
            CupertinoSearchTextField(
              padding: const EdgeInsets.all(AppPadding.p14),
              onChanged: ((val) {
                _debouncer.run(() {
                  setState(() {
                    _eventsProvider.searchEventMeetings(searchText: val);
                  });
                });
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.0, color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return Row(
                    children: [
                      Radio(
                          activeColor: primaryColor,
                          value: index,
                          groupValue: selectedEventType,
                          onChanged: (int? value) {
                            setState(() {
                              selectedEventType = index;
                            });
                          }),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        index == 0
                            ? 'All'
                            : index == 1
                                ? "Events"
                                : "Meetings",
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.01,
            ),
            _eventsProvider.loading
                ? Expanded(
                    child: Shimmer.fromColors(
                      baseColor: greyColorShade300,
                      highlightColor: greyColorShade100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, __) => const EventShimmerItem(),
                        itemCount: 10,
                      ),
                    ),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _eventsProvider.refreshList(),
                      child: Column(
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification: _handleScrollNotification,
                            child: Expanded(
                              child: Consumer<AllEventsProvider>(
                                builder: (context, data, child) {
                                  if (selectedEventType == 0 &&
                                      data.upcomingMeetings.isEmpty) {
                                    return const EmptyStateWidget(
                                      text:
                                          'You currently have no upcoming \nevents or meetings at the moment!',
                                    );
                                  }

                                  if (selectedEventType == 1 &&
                                      data.eventsList.isEmpty) {
                                    return const EmptyStateWidget(
                                      text:
                                          'You currently have no upcoming \nevents at the moment!',
                                    );
                                  }
                                  if (selectedEventType == 2 &&
                                      data.meetingsList.isEmpty) {
                                    return const EmptyStateWidget(
                                      text:
                                          'You currently have no upcoming \nmeetings at the moment!',
                                    );
                                  }

                                  return ListView.builder(
                                      controller:
                                          _eventsProvider.scrollController,
                                      itemCount: selectedEventType == 0
                                          ? data.upcomingMeetings.length
                                          : selectedEventType == 1
                                              ? data.eventsList.length
                                              : data.meetingsList.length,
                                      physics: const BouncingScrollPhysics(),
                                      //shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var item = selectedEventType == 0
                                            ? data.upcomingMeetings[index]
                                            : selectedEventType == 1
                                                ? data.eventsList[index]
                                                : data.meetingsList[index];
                                        return upcomingEvents(
                                          meetingEvent: item,
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                          if (_eventsProvider.loadingMore)
                            const PaginationLoader(
                              loadingText: 'Loading. please wait...',
                            )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget upcomingEvents({
    required MeetingEventModel meetingEvent,
  }) {
    return MeetingEventWidget(
      meetingEventModel: meetingEvent,
    );
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
          LabelWidgetContainer(
            label: "Date",
            child: FormButton(
              label: _eventsProvider.selectedDate == null
                  ? "Select Date"
                  : _eventsProvider.selectedDate!
                      .toIso8601String()
                      .substring(0, 10),
              function: () async {
                _eventsProvider.selectedDate = await DateUtil.selectDate(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: null,
                );
                setState(() {});
              },
            ),
          ),
          Consumer<ClientProvider>(
            builder: (context, data, child) {
              return data.branch.id == AppConstants.mainAdmin
                  ? LabelWidgetContainer(
                      label: "Branch",
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.0, color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonFormField<Branch>(
                          isExpanded: true,
                          style: const TextStyle(
                            color: textColorPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: const Text('Select Branch'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          value: _eventsProvider.selectedBranch,
                          icon: _eventsProvider.loadingFilters
                              ? const FilterLoader()
                              : Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: Colors.grey.shade500,
                                  size: 16,
                                ),
                          // Array list of items
                          items: _eventsProvider.branches.map((Branch branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _eventsProvider.selectedBranch = val as Branch;
                            });
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          SizedBox(
            height: displayHeight(context) * 0.03,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () {
                      _eventsProvider.clearFilters();
                    },
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
                    function: () {
                      _eventsProvider.filterByDate();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
