import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../providers/schoolManager_provider.dart';

class SchoolManagerClassScorePage extends StatefulWidget {
  const SchoolManagerClassScorePage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerClassScorePage> createState() => _SchoolManagerClassScorePageState();
}

class _SchoolManagerClassScorePageState extends State<SchoolManagerClassScorePage> {
  bool _isAdminAccountView=true;
  late var _assessmentTypeList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SchoolProvider>(context,listen:false).assessmentList();
    _assessmentTypeList = Provider.of<SchoolProvider>(context,listen:false).getAssessmentTypeList();
    // print(_assessmentTypeList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Score"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              _isAdminAccountView?
                  adminAccountOptionsView():
                  nonAdminAccountView(),

              const SizedBox(height: 36,),

              CustomElevatedButton(label: "Download  Report ", function: (){})

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

        const SizedBox(height: 12,),

        LabelWidgetContainer(label: "Course",
            child: FormButton(label: "Select Course",
              function: () {  },)),

        LabelWidgetContainer(label: "Subject",
            child: FormButton(label: "Select Subject",
              function: () {  },)),

        const SizedBox(height: 12,),

        LabelWidgetContainer(label: "Assessment Type",
            child: FormButton(label: "Select Assessment Type",
              function: () {  },)),
      ],
    );
  }

  Widget adminAccountOptionsView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        LabelWidgetContainer(label: "Branch",
            child: FormButton(label: "Select Branch", function: (){},)),

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


        LabelWidgetContainer(label: "Group",
            child: FormButton(label: "Select Group",
              function: () {  },)),

        LabelWidgetContainer(label: "Sub Group",
            child: FormButton(label: "Select Sub Group",
              function: () {  },)),



        LabelWidgetContainer(label: "Course",
            child: FormButton(label: "Select Course",
              function: () {  },)),

        LabelWidgetContainer(label: "Subject",
            child: FormButton(label: "Select Subject",
              function: () {  },)),

        const SizedBox(height: 12,),

        LabelWidgetContainer(label: "Assessment Type",
            child: FormButton(label: "Select Assessment Type",
              function: () {  },)),

        LabelWidgetContainer(label: "Student/Pupil",
            child: FormButton(label: "Select Student/Pupil",
              function: () {  },)),

      ],
    );
  }
}
