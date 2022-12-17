import 'package:flutter/material.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';

class FilterPageClocking extends StatefulWidget {
  const FilterPageClocking({Key? key}) : super(key: key);

  @override
  State<FilterPageClocking> createState() => _FilterPageClockingState();
}

class _FilterPageClockingState extends State<FilterPageClocking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Members"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    LabelWidgetContainer(label: "Branch",
                      child: FormButton(label: "All", function: () {  },),),

                    LabelWidgetContainer(label: "Member Category",
                      child: FormButton(label: "All", function: () {  },),),


                    LabelWidgetContainer(label: "Group",
                      child: FormButton(label: "Select Group", function: () {  },),),


                    LabelWidgetContainer(label: "Sub Group",
                      child: FormButton(label: "Select Sub Group", function: () {  },),),



                  ],
                ),
              ),
            ),

            CustomElevatedButton(label: "Apply Filter",
                function: (){
                  Navigator.pop(context);
                }),
            const SizedBox(height: 12,),

          ],
        ),
      ),
    );
  }
}
