import 'package:akwaaba/components/contact_leader_list_widget.dart';
import 'package:flutter/material.dart';

class AssignLeadersViewLeadersListPage extends StatefulWidget {
  const AssignLeadersViewLeadersListPage({Key? key}) : super(key: key);

  @override
  State<AssignLeadersViewLeadersListPage> createState() => _AssignLeadersViewLeadersListPageState();
}

class _AssignLeadersViewLeadersListPageState extends State<AssignLeadersViewLeadersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Leaders"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: List.generate(30, (index) {
                return const ContactLeaderListWidget();
              }),
            )
          ],
        ),
      ),
    );
  }
}
