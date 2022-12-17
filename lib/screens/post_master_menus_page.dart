import 'package:akwaaba/components/message_manager_menu_widget.dart';
import 'package:akwaaba/screens/post_master_credit_history_page.dart';
import 'package:akwaaba/screens/post_master_outbox_page.dart';
import 'package:akwaaba/screens/post_master_scheduled_msgs_page.dart';
import 'package:akwaaba/screens/post_master_send_msg_page.dart';
import 'package:akwaaba/screens/post_master_topup_credit.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../components/school_manager_menu_widget.dart';

class PostMasterMenusPage extends StatefulWidget {
  const PostMasterMenusPage({Key? key}) : super(key: key);

  @override
  State<PostMasterMenusPage> createState() => _PostMasterMenusPageState();
}

class _PostMasterMenusPageState extends State<PostMasterMenusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Master "),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  [
              MessageManagerMenuWidget(menuName: "Send or Check Message",
                  function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const PostMasterSendMsgPage()));
                  }),

              MessageManagerMenuWidget(menuName: "Outbox", function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const PostMasterOutboxPage()));
              }),

              MessageManagerMenuWidget(menuName: "Topup Credit", function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const PostMasterTopupCreditPage()));
              }),


              MessageManagerMenuWidget(menuName: "Credit History", function: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const PostMasterCreditHistoryPage()));
              }),



              MessageManagerMenuWidget(menuName: "Schedule Messages",
                  function: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>
                    const PostMasterScheduledMessagesPage()));
              }),


              MessageManagerMenuWidget(menuName: "Email Setting",
                  function: (){
                showNormalToast("Open Webview - Gideon will give redirection url");
                  }),

              MessageManagerMenuWidget(menuName: "Visit Dashboard",
                  function: (){
                    showNormalToast("Open Webview - Gideon will give redirection url");
                  }),


            ],
          ),
        ),
      ),
    );
  }
}
