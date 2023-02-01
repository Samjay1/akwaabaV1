import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/components/tag_widget.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/absent_leave.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class AbsentLeaveWidget extends StatelessWidget {
  final AbsentLeave? absentLeave;
  const AbsentLeaveWidget({super.key, this.absentLeave});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              absentLeave!.member!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: absentLeave!.member!.profilePicture!,
                        height: 60,
                      ),
                    )
                  : defaultProfilePic(height: 60),
              SizedBox(
                width: displayHeight(context) * 0.02,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      absentLeave!.statusId!.status!,
                      style: const TextStyle(
                        fontSize: AppSize.s16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Text(
                      'Reason: ${absentLeave!.reason == null ? 'N/A' : absentLeave!.reason!}',
                      style: const TextStyle(
                        fontSize: AppSize.s14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateUtil.formatStringDate(DateFormat.yMMMEd(),
                              date: DateTime.parse(absentLeave!.fromDate!)),
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // SizedBox(
                        //   width: displayHeight(context) * 0.02,
                        // ),
                        Text(
                          ' - ${DateUtil.formatStringDate(DateFormat.yMMMEd(), date: DateTime.parse(absentLeave!.toDate!))}',
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            fontWeight: FontWeight.w500,
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
                        Text(
                          'Total Days : ${absentLeave!.totalDays!}',
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${absentLeave!.totalDaysLeft!} Day(s) left',
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Update on: ${DateUtil.formatStringDate(DateFormat.yMMMEd().add_jm(), date: DateTime.parse(absentLeave!.fromDate!))}  by  ${absentLeave!.clientInfo!.applicantFirstname!}',
                            style: const TextStyle(
                              fontSize: AppSize.s14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.02,
                        ),
                        TagWidget(
                          text: absentLeave!.term!.name == 'Running'
                              ? 'Approved'
                              : absentLeave!.term!.name == 'Pending'
                                  ? 'Pending'
                                  : 'Cancelled',
                          color: absentLeave!.term!.name == 'Running'
                              ? Colors.green
                              : absentLeave!.term!.name == 'Pending'
                                  ? Colors.blue
                                  : Colors.red,
                        ),
                      ],
                    ),
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
