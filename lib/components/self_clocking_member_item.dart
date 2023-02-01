import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_cached_image_widget.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/providers/clocking_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_outlined_button.dart';

class SelfClockingMemberItem extends StatelessWidget {
  final Attendee? absentee;
  SelfClockingMemberItem({
    Key? key,
    this.absentee,
  }) : super(key: key);

  late ClockingProvider _clockingProvider;

  @override
  Widget build(BuildContext context) {
    var attendeeName =
        "${absentee!.attendance!.memberId!.firstname!} ${absentee!.attendance!.memberId!.surname!}";
    _clockingProvider = context.watch<ClockingProvider>();

    var inTime = 'N/A';
    if (absentee!.attendance!.inTime != null) {
      inTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.inTime!))
          .toLowerCase();
    }

    var outTime = 'N/A';
    if (absentee!.attendance!.outTime != null) {
      outTime = DateUtil.formatStringDate(DateFormat.jm(),
              date: DateTime.parse(absentee!.attendance!.outTime!))
          .toLowerCase();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Card(
        color: absentee!.selected! ? Colors.orange.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: absentee!.selected! ? 3 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                absentee!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: absentee!.selected! ? primaryColor : Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              absentee!.additionalInfo!.memberInfo!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: absentee!
                            .additionalInfo!.memberInfo!.profilePicture!,
                        height: 60,
                      ),
                    )
                  : defaultProfilePic(height: 60),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      attendeeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${absentee!.identification}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    absentee!.attendance!.inTime != null
                        ? Text('IN : $inTime')
                        : const SizedBox(),
                    SizedBox(
                      height: displayHeight(context) * 0.008,
                    ),
                    absentee!.attendance!.inTime != null
                        ? Text('OUT :  $outTime')
                        : const SizedBox(),
                  ],
                ),
              ),
              CustomOutlinedButton(
                label: absentee!.attendance!.inTime == null ? "IN" : "OUT",
                mycolor: absentee!.attendance!.inTime == null
                    ? Colors.green
                    : redColor,
                radius: 5,
                function: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      insetPadding: const EdgeInsets.all(10),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: ConfirmDialog(
                        title: absentee!.attendance!.inTime == null
                            ? 'Clock In'
                            : 'Clock Out',
                        content: absentee!.attendance!.inTime == null
                            ? 'Are you sure you want to clockin?'
                            : 'Are you sure you want to clockout?',
                        onConfirmTap: () async {
                          Navigator.pop(context);
                          absentee!.attendance!.inTime == null
                              ? await Provider.of<ClockingProvider>(context,
                                      listen: false)
                                  .clockMemberIn(
                                  context: context,
                                  attendee: absentee!,
                                  time: null,
                                )
                              : await Provider.of<ClockingProvider>(context,
                                      listen: false)
                                  .clockMemberOut(
                                  context: context,
                                  attendee: absentee!,
                                  time: null,
                                );
                          _clockingProvider.clearData();
                        },
                        onCancelTap: () => Navigator.pop(context),
                        confirmText: 'Yes',
                        cancelText: 'Cancel',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
