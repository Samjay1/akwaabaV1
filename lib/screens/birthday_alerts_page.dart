import 'package:akwaaba/components/birthday_alert_today_widget.dart';
import 'package:akwaaba/components/birthday_alert_upcoming_item_widget.dart';
import 'package:flutter/material.dart';

class BirthdayAlertsPage extends StatefulWidget {
  const BirthdayAlertsPage({Key? key}) : super(key: key);

  @override
  State<BirthdayAlertsPage> createState() => _BirthdayAlertsPageState();
}

class _BirthdayAlertsPageState extends State<BirthdayAlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Birthday Alerts"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            todaysBirthdayViews(),

            const SizedBox(height: 36,),
            upcomingBirthdayAlerts(),
          ],
        ),
      ),
    );
  }

  Widget todaysBirthdayViews(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:  [
        const Text("Today",
        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
        const SizedBox(height: 8,),
        Column(
          children: List.generate(2, (index) {
            return BirthdayAlertItemTodayWidget();
          }),
        )
      ],
    );
  }

  Widget upcomingBirthdayAlerts(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:  [
        const Text("Upcoming",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
        const SizedBox(height: 8,),
        Column(
          children: List.generate(10, (index) {
            return BirthdayAlertUpcomingItemWidget();
          }),
        )
      ],
    );
  }
}
