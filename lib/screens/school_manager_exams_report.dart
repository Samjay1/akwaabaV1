import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/material.dart';

class SchoolManagerExamsReportPage extends StatefulWidget {
  const SchoolManagerExamsReportPage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerExamsReportPage> createState() => _SchoolManagerExamsReportPageState();
}

class _SchoolManagerExamsReportPageState extends State<SchoolManagerExamsReportPage> {
  bool _isAdminAccount=true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_isAdminAccount);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exams Report"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              _isAdminAccount?adminAccountView():
                  nonAdminAccountView(),

              const SizedBox(height: 36,),
              const Text('Data Available', style: TextStyle(fontSize: 21,),textAlign: TextAlign.center,),
              const SizedBox(height: 36,),
              CustomElevatedButton(label: "View Report ", function: (){})

            ],
          ),
        ),
      ),
    );
  }

  Widget nonAdminAccountView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Academic Year"),

        const SizedBox(height: 12,),

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

        const SizedBox(height: 12,),

        LabelWidgetContainer(label: "Term/Semester",
            child: FormButton(label: "Select Term/ Semester",
              function: () {  },)),

        LabelWidgetContainer(label: "Class/Level",
            child: FormButton(label: "Select Class/ Level",
              function: () {  },)),
      ],
    );
  }

  Widget adminAccountView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Academic Year"),

        const SizedBox(height: 12,),

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

        const SizedBox(height: 12,),

        LabelWidgetContainer(label: "Term/Semester",
            child: FormButton(label: "Select Term/ Semester",
              function: () {  },)),

        LabelWidgetContainer(label: "Class/Level",
            child: FormButton(label: "Select Class/ Level",
              function: () {  },)),

        LabelWidgetContainer(label: "Student",
            child: FormButton(label: "Select Student",
              function: () {  },)),
      ],
    );
  }
}
