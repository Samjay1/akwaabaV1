import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ReportInboxOutboxItemWidget extends StatelessWidget {
  const ReportInboxOutboxItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              defaultProfilePic(height: 55),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text("Sender/Recipient Name",
                    style: TextStyle(fontSize:  17,fontWeight: FontWeight.w500),),
                    Text("some sample text about the msg ",
                    maxLines: 2,overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,
                    color: textColorLight),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
