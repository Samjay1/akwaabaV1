import 'package:akwaaba/models/meeting_event_item.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/material.dart';

class MeetingEventWidget extends StatelessWidget {
  final MeetingEventItem meetingEventItem;
  const MeetingEventWidget(this.meetingEventItem,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
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
              Text(meetingEventItem.title,
              style: const TextStyle(fontSize: 19),),
              const SizedBox(height: 8,),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,size: 16,color: primaryColor,),
                  const SizedBox(width: 3,),
                  Text(meetingEventItem.date,style: const TextStyle(fontWeight: FontWeight.w400,
                  fontSize: 14,color: textColorLight),),
                ],
              ),
              const SizedBox(height: 4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(child: Row(
                    children: [
                      const Icon(Icons.alarm_add_outlined,size: 16,color: primaryColor,),
                      const SizedBox(width: 3,),
                      Text(meetingEventItem.startTime,style: const TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 14,color: textColorLight))
                    ],
                  )
                  ),
                  const SizedBox(width: 12,),
                  Expanded(child: Row(
                    children: [
                      const Icon(Icons.alarm_add_outlined,size: 16,color: primaryColor,),
                      const SizedBox(width: 3,),
                      Text(meetingEventItem.endTime,style: const TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 14,color: textColorLight))
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
