import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterMembersPage extends StatefulWidget {
  const FilterMembersPage({Key? key}) : super(key: key);

  @override
  State<FilterMembersPage> createState() => _FilterMembersPageState();
}

class _FilterMembersPageState extends State<FilterMembersPage> {
  bool includeLocationFilter=false;


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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [

                    LabelWidgetContainer(label: "Branch",
                      child: FormButton(label: "All", function: () {  },),),

                    LabelWidgetContainer(label: "Category",
                      child: FormButton(label: "All", function: () {  },),),


                    LabelWidgetContainer(label: "Group",
                      child: FormButton(label: "Select Group", function: () {  },),),


                    LabelWidgetContainer(label: "Sub Group",
                      child: FormButton(label: "Select Sub Group", function: () {  },),),


                    Row(
                      children: [
                        CupertinoSwitch(value: includeLocationFilter,
                            onChanged: (bool val){
                          setState(() {
                            includeLocationFilter=val;
                          });
                            }),
                        const SizedBox(width: 8,),
                         Text(includeLocationFilter?"Exclude Location Filters": "Add Location Filters")
                      ],
                    ),


                    includeLocationFilter?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16,),

                            LabelWidgetContainer(label: "Country",
                              child: FormButton(label: "Select Country", function: () {  },),),

                            LabelWidgetContainer(label: "Region",
                              child: FormButton(label: "Select Region", function: () {  },),),

                            LabelWidgetContainer(label: "District",
                              child: FormButton(label: "Select District", function: () {  },),),
                          ],
                        ):Container(),

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
