import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/meeting_event_item.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingEventWidget extends StatelessWidget {
  final MeetingEventModel? meetingEventModel;
  const MeetingEventWidget({Key? key, required this.meetingEventModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = '';
    // check if there are many dates are added
    if (!meetingEventModel!.isRecuring! &&
        meetingEventModel!.upcomingDates != null) {
      if (meetingEventModel!.upcomingDates!.length > 1) {
        for (var i = 0; i < meetingEventModel!.upcomingDates!.length; i++) {
          if (DateTime.now().isAtSameMomentAs(
              DateTime.parse(meetingEventModel!.upcomingDates![i].date!))) {
            debugPrint(
                'Current Date: ${DateTime.now().toIso8601String().substring(0, 10)}');
            debugPrint(
                'First Date: ${DateTime.parse(meetingEventModel!.upcomingDates![i].date!).toIso8601String().substring(0, 10)}');
            if (meetingEventModel!.upcomingDates!.length - 1 == i) {
              date = DateUtil.formatStringDate(
                DateFormat.yMMMEd(),
                date: DateTime.parse(
                  meetingEventModel!.upcomingDates![i].date!,
                ),
              );
            } else if (meetingEventModel!.upcomingDates!.length - 1 > i) {
              date = DateUtil.formatStringDate(
                DateFormat.yMMMEd(),
                date: DateTime.parse(
                  meetingEventModel!.upcomingDates![i + 1].date!,
                ),
              );
              debugPrint(
                  'Next Date: ${DateTime.parse(meetingEventModel!.upcomingDates![i + 1].date!).toIso8601String().substring(0, 10)}');
            }

            break;
          }
          if (DateTime.now().isBefore(
              DateTime.parse(meetingEventModel!.upcomingDates![i].date!))) {
            date = DateUtil.formatStringDate(
              DateFormat.yMMMEd(),
              date: DateTime.parse(
                meetingEventModel!.upcomingDates![i].date!,
              ),
            );
            break;
          }
        }
      }
      // check if there is only one date added
      else {
        date = DateUtil.formatStringDate(
          DateFormat.yMMMEd(),
          date: DateTime.parse(meetingEventModel!.upcomingDates![0].date!),
        );
      }
    } else {
      date = DateUtil.formatStringDate(
        DateFormat.yMMMEd(),
        date: DateTime.parse(
          meetingEventModel!.upcomingDays != null
              ? meetingEventModel!.upcomingDays![0].endDate!
              : meetingEventModel!.upcomingDates != null
                  ? meetingEventModel!.upcomingDates![0].date!
                  : meetingEventModel!.updateDate!,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)),
        child: Container(
          //margin: const EdgeInsets.symmetric(vertical: 8),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(defaultRadius)
          // ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      meetingEventModel!.name!,
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  Text(
                    "Span: ${meetingEventModel!.meetingSpan} Day(s)",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColorLight),
                      ),
                    ],
                  ),
                  Text(
                    meetingEventModel!.isRecuring!
                        ? "Recurring Weekly "
                        : "Non-Recurring",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.alarm_add_outlined,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        DateUtil.formate12hourTime(
                          myTime: meetingEventModel!.startTime!,
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColorLight),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.alarm_add_outlined,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        DateUtil.formate12hourTime(
                          myTime: meetingEventModel!.closeTime!,
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColorLight),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
