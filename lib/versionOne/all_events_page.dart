import 'package:akwaaba/components/custom_date_picker.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/all_events_provider.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void loadAllMeetingEvents() async {
    Future.delayed(Duration.zero, () {
      if (Provider.of<AllEventsProvider>(context, listen: false)
          .upcomingMeetings
          .isEmpty) {
        // load all upcoming events or meetings
        Provider.of<AllEventsProvider>(context, listen: false)
            .getUpcomingMeetingEvents();
      }
      setState(() {});
    });
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
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            filterButton(),
            const SizedBox(
              height: 16,
            ),
            CupertinoSearchTextField(
              onChanged: ((val) {
                setState(() {
                  _eventsProvider.searchEventMeetings(searchText: val);
                });
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.only(right: 12.0),
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
                          Expanded(
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
                                      var item = data.upcomingMeetings[index];
                                      return upcomingEvents(
                                        meetingEvent: item,
                                      );
                                    });
                              },
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
          // initiallyExpanded: isTileExpanded,
          // onExpansionChanged: (value) {
          //   setState(() {
          //     isTileExpanded = value;
          //   });
          //   debugPrint("Expanded: $isTileExpanded");
          // },
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
            child: CustomDatePicker(
              hintText: 'Select Date',
              firstDate: DateTime(1970),
              lastDate: DateTime(2050),
              onChanged: (dateString) {
                setState(() {
                  _eventsProvider.selectedDate = DateTime.parse(dateString);
                });
              },
              onSaved: (dateString) {
                setState(() {
                  _eventsProvider.selectedDate = DateTime.parse(dateString!);
                });
                debugPrint(
                    "Selected DateTime: ${_eventsProvider.selectedDate!.toIso8601String().substring(0, 10)}");
              },
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () => _eventsProvider.clearFilters(),
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
