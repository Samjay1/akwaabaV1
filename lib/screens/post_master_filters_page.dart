import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostMasterFiltersPage extends StatefulWidget {
  const PostMasterFiltersPage({Key? key}) : super(key: key);

  @override
  State<PostMasterFiltersPage> createState() => _PostMasterFiltersPageState();
}

class _PostMasterFiltersPageState extends State<PostMasterFiltersPage> {
  int organizationOrMembersIndex=-1;
  String? selectedUserType;
  String? selectedAttendance;
  String? selectedConnectionType;
  String? selectedPaymentStatus;
  String? selectedDutyStatus;
  String? selectedApplicantStatus;
  String? selectedGender;
  int minAge=0;
  int maxAge=1000;
  final TextEditingController _controllerMinAge = TextEditingController();
  final TextEditingController _controllerMaxAge = TextEditingController();
  final TextEditingController _controllerSenderId = TextEditingController();
  final TextEditingController _controllerContacts = TextEditingController();
  Map? selectedDescription;
  bool _personalized=false;


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    _controllerMaxAge.dispose();
    _controllerMinAge.dispose();
  }

  List<Map>descriptions=[{"index":0,"title":"Database"},
    {"index":1,"title":"Attendance"},
    {"index":2,"title":"Location"},
    {"index":3,"title":"Connections"},
    {"index":4,"title":"Fees Manager"},
    {"index":5,"title":"Duty Tracker"},
    {"index":6,"title":"Akwaaba Forms"}
    ];

  
  selectUserType(){
    displayCustomDropDown(
        title: "User Type",
        options: ["All Users","Active Users","In Active Users",
      "Registrants"], context: context,listItemsIsMap: false).then((value) {
        setState(() {
          selectedUserType=value;
        });
    });
  }

  selectAttendanceStatus(){
    displayCustomDropDown(
        title: "Attendance Status",
        options: ["Attendees","Absentees","Late Comers ",
          "On Time","Overtime","Under time"], context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedAttendance=value;
      });
    });
  }

  selectPaymentStatus(){
    displayCustomDropDown(
        title: "Payment Status",
        options: ["Fully Paid","Partially Paid","Not Paid ",],
        context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedPaymentStatus=value;
      });
    });
  }

  selectDutyStatus(){
    displayCustomDropDown(
        title: "Duty Status",
        options: ["Done","Undone","Assigned ",
          "Unassigned"], context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedDutyStatus=value;
      });
    });
  }

  selectApplicantStatus(){
    displayCustomDropDown(
        title: "Applicant Status",
        options: ["All","Submitted","Not Submitted","Shortlisted","Not Shortlisted",
          ], context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedApplicantStatus=value;
      });
    });
  }

  selectConnectionType(){

  }

  selectDescription(){

    showCupertinoModalPopup(context: context,
        builder: (BuildContext context)=>CupertinoActionSheet(


          actions: descriptions.map((e) => CupertinoActionSheetAction(
              onPressed: (){
               setState(() {
                 selectedDescription=e;
               });
                Navigator.pop(context,e);

              }, child: Text(
              "${e["title"]}"
          ))).toList(),
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel"),
            onPressed: (){

              Navigator.pop(context);},
          ),
        )
    );

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
        title: const Text("Filter Recipient"),
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
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
                                            groupValue: organizationOrMembersIndex, onChanged: (int? value){
                                          setState(() {
                                            organizationOrMembersIndex=index;
                                          });
                                        }
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(index==0?"Members":"Organization"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),


                    const SizedBox(height: 24,),

                    LabelWidgetContainer(label: "Branch",
                        child: FormButton(label: "All", function: () {  },)),

                    LabelWidgetContainer(label: "Member Category",
                        child: FormButton(label: "All", function: () {  },)),

                    LabelWidgetContainer(label: "Group",
                        child: FormButton(label: "All", function: () {  },)),

                    LabelWidgetContainer(label: "Sub Group",
                        child: FormButton(label: " All", function: () {  },)),



                    LabelWidgetContainer(label: "Description",
                        child: FormButton(label: selectedDescription!=null?
                          selectedDescription!["title"]??"":"Select Description",
                          function: (){selectDescription();},) ),

                    selectedDescription!=null?
                    descriptionFilterOptions(
                        selectedDescriptionFilterIndex: selectedDescription!["index"]):
                        const SizedBox.shrink(),


                    LabelWidgetContainer(label: "Members",
                        child: FormButton(label: "All",function: (){},)),

                    LabelWidgetContainer(label: "Gender",
                        child: FormButton(label:
                        selectedGender??
                        "Select Gender",function: (){
                          selectGender();
                        },)),


                    LabelWidgetContainer(label: "Age Range:",
                        child:
                    Padding(
                      padding:  const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: LabelWidgetContainer(label: "From",
                                child: FormTextField(
                                  controller: _controllerMinAge,
                                  textInputType: TextInputType.number,
                                  maxLines: 1,maxLength: 3,
                                )),
                          ),

                          const SizedBox(width: 12,),

                          Expanded(
                            child: LabelWidgetContainer(label: "To",
                                child: FormTextField(
                                  controller: _controllerMinAge,
                                  textInputType: TextInputType.number,
                                  maxLines: 1,maxLength: 3,
                                )),
                          ),
                        ],
                      ),
                    )
                    ),

                    Row(
                      children: [

                        Expanded(
                          child: LabelWidgetContainer(label: "Start Date",
                              child: FormButton(label: "",function: (){},) ),
                        ),

                        const SizedBox(width: 12,),

                        Expanded(
                          child: LabelWidgetContainer(label: "End Date",
                              child: FormButton(label: "",function: (){},) ),
                        ),
                      ],
                    ),

                    const Text("Schedule"),

                    const SizedBox(height: 12,),

                    Row(
                      children: [
                        Expanded(
                          child: LabelWidgetContainer(label: "Date",
                              child: FormButton(label: "",function: (){},) ),
                        ),

                        const SizedBox(width: 12,),

                        Expanded(
                          child: LabelWidgetContainer(label: "Time",
                              child: FormButton(label: "",function: (){},) ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(child: Text("Personalized")),
                          const SizedBox(width: 24,),
                          CupertinoSwitch(value: _personalized, onChanged: (val){
                            setState(() {
                              _personalized=val;
                            });
                          }),
                        ],
                      ),
                    ),

                    LabelWidgetContainer(label: "Sender Id",
                        child: FormTextField(controller: _controllerSenderId,) ),

                    LabelWidgetContainer(label: "Enter Contacts",

                        child: FormTextField(controller: _controllerContacts,
                        hint: "Enter/paste contacts vertically",)),


                    LabelWidgetContainer(label: "Contact Groups",
                        child: FormButton(label: "Select Contact Group",
                          function: (){},)),

                    Row(
                      children: [
                        Text("Total Contacts: "),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 0,color: textColorLight),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Text("800"),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),

            CustomElevatedButton(label: 'Done',function:   (){
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }

  Widget descriptionFilterOptions({required int selectedDescriptionFilterIndex}){
    switch (selectedDescriptionFilterIndex){
      case 0:
        return   LabelWidgetContainer(label: "User Type",
            child: FormButton(label: selectedUserType??"Select User Type",
              function: (){selectUserType();},));
      case 1:
        return  LabelWidgetContainer(label: "Select Attendance Status Type",
            child: FormButton(label: selectedAttendance??"Select Attendance Status",
              function: (){selectAttendanceStatus();},));
      case 3:
        return  LabelWidgetContainer(label: "Connection Type ",
            child: FormButton(label: selectedConnectionType??"Select Connection Type",
              function: (){selectConnectionType();},));
      case 2:
        return  LabelWidgetContainer(label: "",
            child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Location Details"),
            const SizedBox(height: 16,),
            LabelWidgetContainer(label: "Country",
                child:FormButton(label: "Select Country",function: (){},)  ),
            LabelWidgetContainer(label: "Region",
                child:FormButton(label: "Select Region",function: (){},)  ),
            LabelWidgetContainer(label: "District",
                child:FormButton(label: "Select District",function: (){},)  ),
            LabelWidgetContainer(label: "Constituency",
                child:FormButton(label: "Select Constituency",function: (){},)  ),

            LabelWidgetContainer(label: "Electoral Area",
                child:FormButton(label: "Select Electoral Area",function: (){},)  ),

            LabelWidgetContainer(label: "Community",
                child:FormButton(label: "Select Community",function: (){},)  ),


          ],
        )
        );
      case 4:
        return  LabelWidgetContainer(label: "Payment Status",
            child: FormButton(label: selectedPaymentStatus??"Select Payment  Stratus",
              function: (){selectPaymentStatus();},));
      case 5:
        return  LabelWidgetContainer(label: "Duty Status ",
            child: FormButton(label: selectedDutyStatus??"Select Status Type",
              function: (){selectDutyStatus();},));
      case 6:
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabelWidgetContainer(label: "Questionnaire",
                child:
            FormButton(
              label: "Select Questionnaire",
              function: (){},
            )),

            LabelWidgetContainer(label: "Applicant Status ",
                child: FormButton(label: selectedApplicantStatus??"Select Applicant Status",
                  function: (){selectApplicantStatus();},)),
          ],
        );
      default:
        return Container();
    }
  }
}
