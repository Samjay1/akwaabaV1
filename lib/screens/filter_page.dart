import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_theme.dart';
import '../utils/widget_utils.dart';

class FilterPage extends StatefulWidget {
  final bool isMemberUser;
  const FilterPage({required this.isMemberUser,Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool includeLocationFilter=false;
  bool includeStatusFilter = false;
  int disabilityOption = -1;

  int selectedUserType=-1;
  String? selectedGender;
  DateTime? startYear;
  DateTime? endYear;
  int? minAge;
  int? maxAge;
  List<int>ages=[10,11,12,13,14,15];

  selectStartPeriod(){

    displayDateSelector(context: context,
      initialDate:startYear ?? DateTime.now(),
      minimumDate: DateTime(DateTime.now().year - 50, 1),
      maxDate: DateTime.now(),

    ).then((value) {
      setState(() {
        startYear = value;
      });
    });
  }

  selectEndPeriod(){
    displayDateSelector(context: context,
        initialDate:endYear ?? DateTime.now(),
        minimumDate: DateTime(DateTime.now().year - 50, 1),
        maxDate: DateTime.now()

    ).then((value) {
      setState(() {
        endYear = value;
      });
    });

  }

  selectAge({required bool isSelectingMaxAge}){
    displayCustomDropDown(options: ages,listItemsIsMap: false,
        context: context).then((value) {
      if(value!=null){
        setState(() {
          if(isSelectingMaxAge){
            maxAge=value;
          }else{
            minAge=value;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ages=[];
    for(int i=1;i<=104;i++){
      ages.add(i);
    }
  }

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

                    LabelWidgetContainer(
                      label: "Pick Registration Date Range ",
                      child: Row(

                        children: [
                          Expanded(
                            child:

                            LabelWidgetContainer(label: "Start Date",
                              child: FormButton(label:startYear!=null?DateFormat("dd MMM yyyy").format(startYear!):
                              "Start Period" , function: (){ selectStartPeriod();},
                                iconData: Icons.calendar_month_outlined,),),

                          ),
                          const SizedBox(width: 18,),

                          Expanded(
                            child:

                            LabelWidgetContainer(label: "End Period",
                              child:   FormButton(label:endYear!=null?DateFormat("dd MMM yyyy").format(endYear!):
                              "End Period" , function: (){ selectEndPeriod();},
                                iconData: Icons.calendar_month_outlined,),),

                          ),

                        ],
                      ),
                    ),
                    //
                    LabelWidgetContainer(label: "Pick Age Bracket",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: FormButton(label: "${minAge??""}", function:
                                (){selectAge(isSelectingMaxAge: false);})),
                            const SizedBox(width: 16,),
                            const Text("To",textAlign: TextAlign.center,),
                            const SizedBox(width: 16,),
                            Expanded(child: FormButton(label: "${maxAge??""}", function:
                                (){selectAge(isSelectingMaxAge: true);})),
                          ],
                        )),

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

                    Row(
                      children: [
                        CupertinoSwitch(value: includeStatusFilter,
                            onChanged: (bool val){
                              setState(() {
                                includeStatusFilter=val;
                              });
                            }),
                        const SizedBox(width: 8,),
                        Text(includeStatusFilter?"Exclude Status Filters": "Add Status Filters")
                      ],
                    ),

                    includeStatusFilter?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 18,),
                        widget.isMemberUser? Row(
                          children: [
                            const Expanded(child: Text("Do you have a disability?")),
                            Row(
                              children: List.generate(2, (index) {
                                return Row(
                                  children: [
                                    Radio(
                                        activeColor: primaryColor,
                                        value: index,
                                        groupValue: disabilityOption,
                                        onChanged: (int? value) {
                                          setState(() {
                                            disabilityOption = value!;
                                          });
                                        }),
                                    Text(index == 0 ? "Yes" : "No")
                                  ],
                                );
                              }),
                            )
                          ],
                        ):
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Select Registration Status?"),
                            Row(
                              children: List.generate(2, (index) {
                                return Row(
                                  children: [
                                    Radio(
                                        activeColor: primaryColor,
                                        value: index,
                                        groupValue: disabilityOption,
                                        onChanged: (int? value) {
                                          setState(() {
                                            disabilityOption = value!;
                                          });
                                        }),
                                    Text(index == 0 ? "Register" : "Unregistered")
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                        const SizedBox(height: 16,),

                        widget.isMemberUser?LabelWidgetContainer(label: "Marital Status",
                          child: FormButton(label: "Select Marital Status", function: () {  },),): Container(),

                        LabelWidgetContainer(label: "Occupation",
                          child: FormButton(label: "Select Occupation", function: () {  },),),

                        LabelWidgetContainer(label: "Profession",
                          child: FormButton(label: "Select Profession", function: () {  },),),

                        LabelWidgetContainer(label: "Education",
                          child: FormButton(label: "Select Education", function: () {  },),),
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
