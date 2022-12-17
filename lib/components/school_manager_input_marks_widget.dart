import 'package:akwaaba/screens/school_manager_enter_marks_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/dimens.dart';
import '../utils/widget_utils.dart';

class SchoolManagerInputMarksWidget extends StatefulWidget {
  const SchoolManagerInputMarksWidget({Key? key}) : super(key: key);

  @override
  State<SchoolManagerInputMarksWidget> createState() => _SchoolManagerInputMarksWidgetState();
}

class _SchoolManagerInputMarksWidgetState extends State<SchoolManagerInputMarksWidget> {
  final TextEditingController _controllerScore=TextEditingController();
  final TextEditingController _controllerRemarks=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          // margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultRadius)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  defaultProfilePic(height: 50),
                  const SizedBox(width: 12,),
                  const Expanded(child:
                  Text("Lord Asante Yeboah",style: TextStyle(fontSize: 18),)
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              //
              // Row(
              //   children: [
              //     Expanded(
              //       child: Row(
              //         children: const [
                        Text("Score:  12%"),
              const SizedBox(height: 4,),

              //         ],
              //       ),
              //     )
              //   ],
              // ),
              const Text("Remarks: Good performance ",maxLines: 1,overflow: TextOverflow.ellipsis,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text("Edit Scores"), onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>SchoolManagerEnterMarksPage()));
                  }),
                ],
              )
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           const Text("Score : "),
              //           TextFormField(controller: _controllerScore,
              //               maxLength: 3,maxLines: 1,keyboardType: TextInputType.number,)
              //         ],
              //       ),
              //     ),
              //     const SizedBox(width: 12,),
              //     Expanded(
              //       flex: 5,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           const Text("Remarks "),
              //           TextFormField(controller: _controllerRemarks,
              //             maxLength: 3,maxLines: 1,)
              //         ],
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
