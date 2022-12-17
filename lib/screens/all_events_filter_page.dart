// import 'package:akwaaba/components/custom_elevated_button.dart';
// import 'package:akwaaba/components/form_button.dart';
// import 'package:akwaaba/components/label_widget_container.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../utils/app_theme.dart';
// import '../utils/widget_utils.dart';
//
// class AllEventsFilterPage extends StatefulWidget {
//   const AllEventsFilterPage({Key? key}) : super(key: key);
//
//   @override
//   State<AllEventsFilterPage> createState() => _AllEventsFilterPageState();
// }
//
// class _AllEventsFilterPageState extends State<AllEventsFilterPage> {
//   DateTime? startYear;
//   DateTime? endYear;//start and end year | month for filter range
//   int listType=0;//0= events, 1 = meetings
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Filter Events"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//
//
//               //event or meeting options
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                           elevation:listType==0? 5:0,
//                           backgroundColor:listType==0? primaryColor:Colors.white,
//                         foregroundColor:listType==0? Colors.white:primaryColor
//                       ),
//                       onPressed: () {
//                         setState(() {
//                             listType=0;
//                             debugPrint("List type A:$listType");
//                         });
//
//                       },
//                       child:const Text("Events") ,
//                     )
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                           elevation:listType==1? 5:0,
//                           backgroundColor:listType==1? primaryColor:Colors.white,
//                           foregroundColor:listType==1? Colors.white:primaryColor
//                       ),
//                       onPressed: () {
//                         setState(() {
//                             listType=1;
//
//                             debugPrint("List type B:$listType");
//                         });
//
//                       },
//                       child:const Text("Meetings") ,
//                     )
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 24,),
//
//               Row(
//
//                 children: [
//                   Expanded(
//                     child:
//
//                       LabelWidgetContainer(label: "Start Date",
//                       child: FormButton(label:startYear!=null?DateFormat("dd MMM yyyy").format(startYear!):
//                       "Start Period" , function: (){ selectStartPeriod();},
//                         iconData: Icons.calendar_month_outlined,),),
//
//                   ),
//                   const SizedBox(width: 18,),
//
//                   Expanded(
//                     child:
//
//                         LabelWidgetContainer(label: "End Period",
//                           child:   FormButton(label:endYear!=null?DateFormat("dd MMM yyyy").format(endYear!):
//                           "End Period" , function: (){ selectEndPeriod();},
//                             iconData: Icons.calendar_month_outlined,),),
//
//                   ),
//
//                 ],
//               ),
//
//               const SizedBox(height: 36,),
//
//               CustomElevatedButton(label: "Apply Filter", function: (){
//                applyFilter();
//               })
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   selectStartPeriod(){
//
//     displayDateSelector(context: context,
//       initialDate:startYear ?? DateTime.now(),
//       minimumDate: DateTime(DateTime.now().year - 50, 1),
//       maxDate: DateTime.now(),
//
//     ).then((value) {
//       setState(() {
//         startYear = value;
//       });
//     });
//   }
//
//   selectEndPeriod(){
//     displayDateSelector(context: context,
//         initialDate:endYear ?? DateTime.now(),
//         minimumDate: DateTime(DateTime.now().year - 50, 1),
//         maxDate: DateTime.now()
//
//     ).then((value) {
//       setState(() {
//         endYear = value;
//       });
//     });
//
//   }
//
//   applyFilter(){
//     //make sure end dates comes after start date
//     if(startYear!=null && endYear!=null){
//       if(startYear!.isAfter(endYear!)){
//         showErrorSnackBar(context, "Start Date cannot be after end date");
//         return;
//
//       }
//       Navigator.pop(context);
//     }else{
//       showErrorSnackBar(context, "Please check your start and end dates");
//     }
//
//   }
// }
