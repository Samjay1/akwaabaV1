import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/custom_rect_cached_image_widget.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AgendaDialog extends StatelessWidget {
  final MeetingEventModel? meetingEventModel;
  const AgendaDialog({
    super.key,
    this.meetingEventModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all((AppPadding.p20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.025,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              meetingEventModel!.name!,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     DateUtil.formatStringDate(
          //       DateFormat.yMMMEd(),
          //       date: DateTime.parse(
          //         meetingEventModel!.updateDate!,
          //       ),
          //     ),
          //     style: TextStyle(
          //       color: blackColor.withOpacity(0.4),
          //       fontWeight: FontWeight.w500,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                meetingEventModel!.agendaFile != ""
                    ? SizedBox(
                        width: displayWidth(context),
                        height: 200,
                        child: CustomRectCachedImageWidget(
                          url: meetingEventModel!.agendaFile!,
                          height: 130,
                        ),
                      )
                    : Container(
                        width: displayWidth(context),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                              image: AssetImage('images/placeholder.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    meetingEventModel!.agenda!,
                    style: const TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
