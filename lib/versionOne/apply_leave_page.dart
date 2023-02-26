import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/models/general/leave_status.dart';
import 'package:akwaaba/models/general/messaging_type.dart';
import 'package:akwaaba/providers/attendance_provider.dart';
import 'package:akwaaba/providers/leave_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({Key? key}) : super(key: key);

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  late LeaveProvider _leaveProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<LeaveProvider>(context, listen: false)
          .setCurrentContext(context);
      Provider.of<LeaveProvider>(context, listen: false)
          .getAbsentLeaveStatuses();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _leaveProvider = context.watch<LeaveProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply Leave/Excuse"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "You can submit an absent or leave just in a second!",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LabelWidgetContainer(
                      label: "Start Date",
                      child: FormButton(
                        label: _leaveProvider.selectedStartDate == null
                            ? "Select Start Date"
                            : _leaveProvider.selectedStartDate!
                                .toIso8601String()
                                .substring(0, 10),
                        function: () async {
                          _leaveProvider.selectedStartDate =
                              await DateUtil.selectDate(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.03,
                  ),
                  Expanded(
                    child: LabelWidgetContainer(
                      label: "End Date",
                      child: FormButton(
                        label: _leaveProvider.selectedEndDate == null
                            ? "Select End Date"
                            : _leaveProvider.selectedEndDate!
                                .toIso8601String()
                                .substring(0, 10),
                        function: () async {
                          _leaveProvider.selectedEndDate =
                              await DateUtil.selectDate(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              LabelWidgetContainer(
                label: "Select Leave/Excuse Type",
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.0, color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonFormField<LeaveStatus>(
                    isExpanded: true,
                    style: const TextStyle(
                      color: textColorPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    hint: const Text('Select Leave/Excuse Type'),
                    decoration: const InputDecoration(border: InputBorder.none),
                    value: _leaveProvider.selectedLeaveStatus,
                    icon: Icon(
                      CupertinoIcons.chevron_up_chevron_down,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                    // Array list of items
                    items: _leaveProvider.leaveStatuses.map((LeaveStatus ls) {
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls.status!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _leaveProvider.selectedLeaveStatus = val as LeaveStatus;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              FormTextField(
                controller: _leaveProvider.reasonTEC,
                maxLength: 500,
                showMaxLength: true,
                minLines: 8,
                maxLines: 15,
                label: "What's your reason?",
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              CustomElevatedButton(
                label: "Submit",
                showProgress: _leaveProvider.loading,
                function: () => _leaveProvider.validateInputFields(),
              )
            ],
          )),
    );
  }
}
