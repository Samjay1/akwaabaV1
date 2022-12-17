import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DutyTrackerDateRangeFilterView extends StatefulWidget {
  const DutyTrackerDateRangeFilterView({Key? key}) : super(key: key);

  @override
  State<DutyTrackerDateRangeFilterView> createState() => _DutyTrackerDateRangeFilterViewState();
}

class _DutyTrackerDateRangeFilterViewState extends State<DutyTrackerDateRangeFilterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text("Close"), onPressed: (){
              Navigator.pop(context);
            }),
          ),
          const Divider(height: 1,),
          const SizedBox(height: 24,),
          Text("Filter List",
          style: Theme.of(context).textTheme.headline4,),
          const SizedBox(height: 24,),
          LabelWidgetContainer(label: "From",
              child: FormButton(label: "Select Date", function: () {  },)),

          const SizedBox(height: 24,),

          LabelWidgetContainer(label: "To",
              child: FormButton(label: "Select Date", function: () {  },))
        ],
      ),
    );
  }
}
