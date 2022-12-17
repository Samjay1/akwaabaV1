import 'package:akwaaba/screens/school_manager_class_score.dart';
import 'package:akwaaba/screens/school_manager_exams_report.dart';
import 'package:akwaaba/screens/school_manager_tutors_list_page.dart';
import 'package:akwaaba/screens/school_manger_enter_marks_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchoolManagerMenuWidget extends StatefulWidget {
  final Map menuDetails;
  const SchoolManagerMenuWidget({required this.menuDetails,Key? key}) :
        super(key: key);

  @override
  State<SchoolManagerMenuWidget> createState() => _SchoolManagerMenuWidgetState();
}

class _SchoolManagerMenuWidgetState extends State<SchoolManagerMenuWidget> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: (){
          switch (widget.menuDetails["id"]){
            case 1:
              showErrorSnackBar(context, "We're yet to be provided with url for webview");
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const
              SchoolManagerExamsReportPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const
              SchoolManagerClassScorePage()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (_)=>SchoolManagerTutorsListPage()));
              break;
            case 5:
              showErrorSnackBar(context, "We're yet to be provided with url for webview");
              break;
            case 6:
            case 9:
              showErrorSnackBar(context, "We're yet to be provided with url for webview");
              break;
            case 7:

              Navigator.push(context, MaterialPageRoute(builder: (_)=>const
              SchoolManagerEnterMarksPage()));


          }
        },

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
              decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius),
                      bottomLeft:Radius.circular(defaultRadius) )
              ),
              child: const Icon(Icons.circle,color: Colors.white,size: 16,),
            ),
            const SizedBox(width: 8,),
            Expanded(child: Text("${widget.menuDetails["name"]}")),
            const Icon(Icons.chevron_right,color: primaryColor,)
          ],
        ),
      ),
    );
  }
}
