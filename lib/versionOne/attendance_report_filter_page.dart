// import 'package:akwaaba/components/custom_elevated_button.dart';
// import 'package:akwaaba/components/form_button.dart';
// import 'package:akwaaba/components/label_widget_container.dart';
// import 'package:flutter/material.dart';
//
// class AttendanceReportFilterPage extends StatefulWidget {
//   const AttendanceReportFilterPage({Key? key}) : super(key: key);
//
//   @override
//   State<AttendanceReportFilterPage> createState() => _AttendanceReportFilterPageState();
// }
//
// class _AttendanceReportFilterPageState extends State<AttendanceReportFilterPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Filter Report"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               LabelWidgetContainer(label: "Branch",
//                   child: FormButton(label: "All",function: (){},)
//               ),
//
//               LabelWidgetContainer(label: "Member Category",
//                   child: FormButton(label: "All",function: (){},)
//               ),
//
//               LabelWidgetContainer(label: "Group",
//                   child: FormButton(label: "All",function: (){},)
//               ),
//
//               LabelWidgetContainer(label: "Sub Group",
//                   child: FormButton(label: "All",function: (){},)
//               ),
//
//               LabelWidgetContainer(label: "Member Type",
//                   child: FormButton(label: "All",function: (){},)
//               ),
//
//               const SizedBox(height: 36,),
//
//               CustomElevatedButton(label: "Apply Filter", function: (){
//                 Navigator.pop(context);
//               })
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
