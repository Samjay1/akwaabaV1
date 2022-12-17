import 'package:akwaaba/components/msg_manager_scheduled_msg_widget.dart';
import 'package:flutter/material.dart';

class PostMasterScheduledMessagesPage extends StatefulWidget {
  const PostMasterScheduledMessagesPage({Key? key}) : super(key: key);

  @override
  State<PostMasterScheduledMessagesPage> createState() => _PostMasterScheduledMessagesPageState();
}

class _PostMasterScheduledMessagesPageState extends State<PostMasterScheduledMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled Messages"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
          Column(
            children: List.generate(10, (index) {
              return const MsgManagerScheduleMsgWidget(
                showCancelButton: true,
              );
            }),
          ),
        ),
      ),
    );
  }
}
