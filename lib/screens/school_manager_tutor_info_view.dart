import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_theme.dart';
import '../utils/widget_utils.dart';

class SchoolManagerTutorInfoView extends StatefulWidget {
  const SchoolManagerTutorInfoView({Key? key}) : super(key: key);

  @override
  State<SchoolManagerTutorInfoView> createState() => _SchoolManagerTutorInfoViewState();
}

class _SchoolManagerTutorInfoViewState extends State<SchoolManagerTutorInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:       const Text("Tutor Info"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            defaultProfilePic(height: 95),
            Text("Lord Asante",
            style: TextStyle(
              fontSize: 19,fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,),
            // Row(
            //   children: [
            //
            //     const SizedBox(width: 10,),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           const SizedBox(height: 12,),
            //
            //           Row(
            //             children: [
            //               Icon(Icons.phone,color: textColorLight,size: 15,),
            //               const SizedBox(width: 8,),
            //               Text("0205287971")
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //
            //   ],
            // ),

           // const SizedBox(height: 12,),

            const SizedBox(height: 36,),

            //Divider(),

            Text("Courses",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 8,),
            Text("Course A"),
            // Text("Course B"),
            // Text("Course C"),

            Divider(),

            const SizedBox(height: 12,),
            Text("Subjects",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 8,),
            Text("Subject Alpha"),
            Text("Subject Beta"),

            Divider(),

            const SizedBox(height: 12,),
            Text("Classes or Levels",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 8,),
            Text("Class/Level Baako"),
            Text("Claa/Level Mienu"),

            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.phone_circle,color: Colors.blue,
                    size: 36,),
                  ),
                ),

                const SizedBox(width: 12,),
                
                GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset("images/icons/whatsapp_ic.svg",
                    color: Colors.green,width: 30,height: 30,),
                  ),
                )
              ],
            )


          ],
        ),
      ),
    );
  }
}
