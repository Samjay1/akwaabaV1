import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/member_widget.dart';
import '../utils/app_theme.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({Key? key}) : super(key: key);

  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  int selectedUserType=-1;
  String? selectedGender;
  DateTime? startYear;
  DateTime? endYear;
  int? minAge;
  int? maxAge;
  List<int>ages=[];
  int disabilityStatusRadioId=-1;


  @override
  void initState() {
    super.initState();
    ages=[];
    for(int i=1;i<=104;i++){
      ages.add(i);
    }
  }

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

  selectGender(){
    displayCustomDropDown(options: ["Male","Female"],
        context: context,listItemsIsMap: false).then((value) {
          if(value!=null){
            setState(() {
              selectedGender=value;
            });
          }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Users"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              filterButton(),
             filteredSummaryView(),
             usersList(),
             // filterOptionsListForIndividualMembers(),
            ],
          ),
        ),
      ),
    );
  }

  Widget filteredSummaryView(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Total",
                style: TextStyle(fontSize: 12),),
                Text("300")
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("Males",
                  style: TextStyle(fontSize: 12),),
                Text("30")
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("Females",
                  style: TextStyle(fontSize: 12),),
                Text("30")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget filterButton(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: backgroundColor,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "Filter Options",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            filterOptionsListForIndividualMembers()
          ],
        ),
      ),
    );
  }

  Widget filterOptionsListForIndividualMembers(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 0.0,color:Colors.grey.shade400)
          ),
          child: Row(
            children:
            List.generate(2,
                    (index) {
                  return Expanded(
                    child: Row(

                      children: [
                        Row(
                          children: [
                            Radio(
                                activeColor: primaryColor,
                                value: index,
                                groupValue: selectedUserType, onChanged: (int? value){
                              setState(() {
                                selectedUserType=index;
                              });
                            }
                            ),
                            const SizedBox(width: 5,),
                            Text(index==0?"Individuals":"Organization"),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),

        const SizedBox(height: 16,),

        LabelWidgetContainer(label: "Branch",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "Category",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "Group",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "Sub Group",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "Gender",
            child:FormButton(label: selectedGender??"Select Gender",function: (){selectGender();},)
        ),

        LabelWidgetContainer(label: "Country",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "Region ",
            child:FormButton(label: "",function: (){},)
        ),

        LabelWidgetContainer(label: "District",
            child:FormButton(label: "",function: (){},)
        ),


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

        LabelWidgetContainer(label: "Select Disability Status",
            child: Row(
              children: List.generate(2, (index) {
                return Expanded(
                  child: Row(
                    children: [
                      Radio(
                          activeColor: primaryColor,
                          value: index, groupValue: disabilityStatusRadioId,
                          onChanged: (int? val){
                        setState(() {
                          disabilityStatusRadioId=val!;
                        });
                          }),
                      Text(index==0?"Yes":"No")
                    ],
                  ),
                );
              }),

            )),

        LabelWidgetContainer(label: "Marital Status",
            child:
        FormButton(label: "",function: (){},),
        ),

        LabelWidgetContainer(label: "Occupation",
          child:
          FormButton(label: "",function: (){},),
        ),

        LabelWidgetContainer(label: "Profession",
          child:
          FormButton(label: "",function: (){},),
        ),

        LabelWidgetContainer(label: "Education",
          child:
          FormButton(label: "",function: (){},),
        ),

        CupertinoSearchTextField(
          placeholder: "Search by ID",
        ),

        const SizedBox(height: 16,),

        CupertinoSearchTextField(
          placeholder: "Search by Name",
        ),

        const SizedBox(height: 16,),
        CustomElevatedButton(label: "Filter", function: (){})
      ],
    );
  }


  Widget filterOptionsListForOrgMembers(){
    return Column(
      children: [
        LabelWidgetContainer(label: "Legal Status",
            child: FormButton(
              label: "",
              function: (){},
            )),

        LabelWidgetContainer(label: "Organization Type",
            child: FormButton(
              label: "",
              function: (){},
            )),

        const CupertinoSearchTextField(
          placeholder: "Search by ID",
        ),

        const SizedBox(height: 16,),

        const CupertinoSearchTextField(
          placeholder: "Search by Name",
        ),

        const SizedBox(height: 16,),

        CustomElevatedButton(label: "Filter", function: (){})
      ],
    );
  }

  Widget usersList(){
    return  ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children:List.generate(20, (index) {
        return const MemberWidget();
      }),
    );
  }
}
