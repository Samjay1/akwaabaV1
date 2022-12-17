import 'package:akwaaba/screens/report_inbox_page.dart';
import 'package:akwaaba/screens/report_new_msg_page.dart';
import 'package:akwaaba/screens/report_outbox_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ContactLeadersPage extends StatefulWidget {
  const ContactLeadersPage({Key? key}) : super(key: key);

  @override
  State<ContactLeadersPage> createState() => _ContactLeadersPageState();
}

class _ContactLeadersPageState extends State<ContactLeadersPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contact Leaders"),
          bottom:  const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.black54,

            tabs: [
              Tab(text: 'Inbox'),
              Tab(text: 'Outbox'),
            ],
          ),
        ),
        body: const TabBarView(

          children: [
            ReportInboxPage(),
            ReportOutboxPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ReportNewMsgPage()));
          },
            label: const Text("New Message",
            style: TextStyle(color: Colors.white),),icon: Icon(Icons.add),),
      ),
    );
  }
}
