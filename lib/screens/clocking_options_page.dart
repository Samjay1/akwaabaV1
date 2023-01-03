import 'package:akwaaba/components/member_clock_time_selection_widget.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ClockingOptionsPage extends StatefulWidget {
  const ClockingOptionsPage({Key? key}) : super(key: key);

  @override
  State<ClockingOptionsPage> createState() => _ClockingOptionsPageState();
}

class _ClockingOptionsPageState extends State<ClockingOptionsPage> {
  DateTime? generalClockTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clock Options"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LabelWidgetContainer(label: "Meeting Type",
                    //     child: FormButton(label: "Select Meeting Type",
                    //     function: (){},)),
                    //
                    // LabelWidgetContainer(label: "Date",
                    //     child: FormButton(label: "Select Date",
                    //       function: (){},)),
                    //
                    // LabelWidgetContainer(label: "Set Mass Time",
                    //     child:  FormButton(label: generalClockTime!=null?
                    //     DateFormat("hh:mm").format(generalClockTime!):"Select time",
                    //         function: (){selectGroupTime();})),

                    // const SizedBox(height: 24,),

                    const Text(
                      "Selected Members",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),

                    Column(
                      children: List.generate(10, (index) {
                        return const MemberClockTimeSelectionWidget();
                      }),
                    )
                  ],
                ),
              ),
            ),

            //CustomElevatedButton(label: "Submit", function: (){}),

            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              onPressed: () {},
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Clock In"),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),

            const SizedBox(
              height: 12,
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: () {},
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Clock Out"),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),

            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void selectGroupTime() {
    displayTimeSelector(
            initialDate: generalClockTime ?? DateTime.now(), context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          generalClockTime = value;
        });
      }
    });
  }
}
