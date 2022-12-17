import 'package:flutter/material.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';


class SchoolManagerExamMarksFilter extends StatefulWidget {
  const SchoolManagerExamMarksFilter({Key? key}) : super(key: key);

  @override
  State<SchoolManagerExamMarksFilter> createState() => _SchoolManagerExamMarksFilterState();
}

class _SchoolManagerExamMarksFilterState extends State<SchoolManagerExamMarksFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Student"),
      ),
      body:  Padding(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    LabelWidgetContainer(label: "Branch",
                        child: FormButton(label: "Select Branch",function: (){},)),

                    LabelWidgetContainer(label: "Groups/Class",
                        child: FormButton(label: "Select Groups/Class",function: (){},)),

                    LabelWidgetContainer(label: "Sub Group/Class",
                        child: FormButton(label: "Select Sub Group/Class",function: (){},)),

                    LabelWidgetContainer(label: "Course",
                        child: FormButton(label: "Select Course",function: (){},)),

                    LabelWidgetContainer(label: "Term/Semester",
                        child: FormButton(label: "Select Term/Semester",function: (){},)),

                    const SizedBox(height: 16,),

                    const Text("Academic Year"),

                    const SizedBox(height: 18,),

                    Row(
                      children: [
                        Expanded(
                          child: LabelWidgetContainer(
                            label: 'Start Year',
                            child: FormButton(
                              label: "Select Year", function: () {  },

                            ),
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: LabelWidgetContainer(
                            label: 'End Year',
                            child: FormButton(
                              label: "Select Year", function: () {  },

                            ),
                          ),
                        )
                      ],
                    ),

                    LabelWidgetContainer(label: "Subject",
                        child: FormButton(label: "Select Subject",function: (){},)),

                    LabelWidgetContainer(label: "Assessment Type",
                        child: FormButton(label: "Select Assessment Type",function: (){},)),

                    const SizedBox(height: 7,),

                    LabelWidgetContainer(label: "Student /Pupil",
                        child: FormButton(label: "Select Student /Pupil",function: (){},)),

                    const SizedBox(height: 16,),


                  ],
                ),
              ),
            ),
            CustomElevatedButton(label: "Filter",
                function: (){
                  Navigator.pop(context,true);
                }),

          ],
        ),

      ),
    );
  }
}
