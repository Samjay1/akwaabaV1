import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/duty_report_item_widget.dart';
import 'package:akwaaba/screens/duty_tracker_previous_assigned_list_page.dart';
import 'package:akwaaba/screens/duty_tracker_self_assign_duty.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DutyTrackerMainPage extends StatefulWidget {
  const DutyTrackerMainPage({Key? key}) : super(key: key);

  @override
  State<DutyTrackerMainPage> createState() => _DutyTrackerMainPageState();
}

class _DutyTrackerMainPageState extends State<DutyTrackerMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duty Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius)
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        defaultProfilePic(height: 70),
                        const SizedBox(height: 8,),
                        const Text("Lord Ante Fordjour",
                        style: TextStyle(fontSize: 16),),
                        const Text("Assigned Duties (2)",
                        style: TextStyle(fontSize: 14,color: textColorLight),)

                      ],
                    ),
                  ),
                ),
              ),

              Text("**Test Only**  --> Assuming user has no assigned duty",
              style: TextStyle(color: Colors.red),),

              noAssignedDuties(),


              const SizedBox(height: 24,),
              Text("Today’s Assigned Duties",
                style: Theme.of(context).textTheme.headline4,),

              todayDutiesListView(),
              
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text("View Previous Assigned Duties"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        DutyTrackerPreviousAssignedListPage()));
                  })
            ],
          ),
        ),
      ),
    );
  }


  Widget noAssignedDuties(){
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: textColorLight,width: 0),
        borderRadius: BorderRadius.circular(12)
      ),
      padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 8),
      child: Column(
        children: [
          const Text("Sorry, you have no assigned duty today. ",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),

          const SizedBox(height: 12,),
          const Text("What work do you plan doing to day?"),
          const SizedBox(height: 8,),

          CustomElevatedButton(label: "Assign Yourself Duty",
              function: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>
            DutyTrackerSelfAssignDutyPage()));
              })


        ],
      ),
    );
  }

  Widget todayDutiesListView(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(2, (index) => const DutyReportItemWidget()),
    );
  }
}
