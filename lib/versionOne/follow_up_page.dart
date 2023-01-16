import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/messaging_type.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/home_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widget_utils.dart';

class FollowUpPage extends StatefulWidget {
  final Attendee? attendee;
  FollowUpPage({Key? key, this.attendee}) : super(key: key);

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  late AttendanceProvider attendanceProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AttendanceProvider>(context, listen: false).getMessagingTypes(
          gender: widget.attendee!.attendance!.memberId!.gender!);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    attendanceProvider = context.watch<AttendanceProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "You can send a follow up message to a member just in a second!",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              // const Divider(
              //   color: textColorPrimary,
              // ),
              SizedBox(
                height: displayHeight(context) * 0.006,
              ),
              LabelWidgetContainer(
                label: "Messaging Type",
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.0, color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonFormField<MessagingType>(
                    isExpanded: true,
                    style: const TextStyle(
                      color: textColorPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    hint: const Text('Select Messaging Type'),
                    decoration: const InputDecoration(border: InputBorder.none),
                    value: attendanceProvider.selectedMessagingType,
                    icon: Icon(
                      CupertinoIcons.chevron_up_chevron_down,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                    // Array list of items
                    items: attendanceProvider.messagingTypes
                        .map((MessagingType messagingType) {
                      return DropdownMenuItem(
                        value: messagingType,
                        child: Text(messagingType.name!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        attendanceProvider.selectedMessagingType =
                            val as MessagingType;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              FormTextField(
                controller: attendanceProvider.followUpTEC,
                maxLength: 256,
                showMaxLength: true,
                minLines: 8,
                maxLines: 15,
                label: "What's your follow-up message?",
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              CustomElevatedButton(
                label: "Submit",
                showProgress: attendanceProvider.loading,
                function: () async => attendanceProvider.validateFollowUpField(
                  meetingEventId:
                      widget.attendee!.attendance!.meetingEventId!.id!,
                  clockingId: widget.attendee!.attendance!.id!,
                ),
              )
            ],
          )),
    );
  }
}
