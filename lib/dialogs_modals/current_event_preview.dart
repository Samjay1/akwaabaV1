import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/models/meeting_event_item.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CurrentEventPreviewPage extends StatelessWidget {
  const CurrentEventPreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ))),
          //MeetingEventWidget(MeetingEventItem("Tues Office Work", "16 Aug 2022", "8:00AM", "5:00PM"),),

          Container(
            padding: EdgeInsets.only(left: 8, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Clocked In Time",
                      style: TextStyle(color: textColorLight, fontSize: 14),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "0.00 AM",
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Clocked Out Time",
                      style: TextStyle(color: textColorLight, fontSize: 14),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text("0.00 PM"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
