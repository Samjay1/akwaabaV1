import 'package:akwaaba/screens/school_manager_tutor_info_view.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class SchoolManagerTutorListWidget extends StatefulWidget {
  const SchoolManagerTutorListWidget({Key? key}) : super(key: key);

  @override
  State<SchoolManagerTutorListWidget> createState() => _SchoolManagerTutorListWidgetState();
}

class _SchoolManagerTutorListWidgetState extends State<SchoolManagerTutorListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>
            const SchoolManagerTutorInfoView()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            defaultProfilePic(height: 50),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:  [
                  SizedBox(height: 8,),
                  Text("Kwame Doe"),
                  SizedBox(height: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Info Studies"),
                  Text("View Info",
                    style: TextStyle(color: primaryColor,fontSize: 15),)
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
