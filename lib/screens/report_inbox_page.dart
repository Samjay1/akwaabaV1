import 'package:akwaaba/components/report_inbox_outbox_item_widget.dart';
import 'package:flutter/material.dart';

class ReportInboxPage extends StatefulWidget {
  const ReportInboxPage({Key? key}) : super(key: key);

  @override
  State<ReportInboxPage> createState() => _ReportInboxPageState();
}

class _ReportInboxPageState extends State<ReportInboxPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: List.generate(30, (index) => ReportInboxOutboxItemWidget()),
      ),
    );
  }
}
