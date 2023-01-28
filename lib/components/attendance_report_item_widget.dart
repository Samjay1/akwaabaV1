import 'package:akwaaba/versionOne/attendance_report_preview.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AttendanceReportItemWidget extends StatelessWidget {
  final bool isLate;
  const AttendanceReportItemWidget({required this.isLate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_)=>
          // AttendanceReportDetailsPage()));
          //displayCustomDialog(context, const AttendanceReportItemPreview());
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    defaultProfilePic(height: 50),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "John Jane Doe",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Friday Night Duties",
                                  style: TextStyle(
                                      fontSize: 14, color: textColorLight),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: this.isLate
                                        ? Colors.red
                                        : Colors.green),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Text(
                                  this.isLate ? "Late" : "Early",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: textColorLight,
                                size: 16,
                              ),
                              Text(
                                "12 Aug 2022",
                                style: TextStyle(
                                    color: textColorLight, fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: primaryColor,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextWidget({String label = "", String text = ""}) {
    return RichText(
      text: TextSpan(
          text: '$label ',
          style: const TextStyle(color: textColorLight, fontSize: 13),
          children: <TextSpan>[
            TextSpan(
              text: ' $text',
              style: const TextStyle(color: textColorPrimary, fontSize: 15),
            )
          ]),
    );
  }
}
