import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/school_manager_input_marks_widget.dart';
import 'package:akwaaba/screens/school_manager_exam_marks_filter.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchoolManagerEnterMarksPage extends StatefulWidget {
  const SchoolManagerEnterMarksPage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerEnterMarksPage> createState() => _SchoolManagerEnterMarksPageState();
}

class _SchoolManagerEnterMarksPageState extends State<SchoolManagerEnterMarksPage> {
  bool _showFilteredList=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class/Exam Marks"),
      ),
      body: Padding(

        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 24,),

              const Text("Filter students to input their marks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),

              const SizedBox(height: 12,),
              CupertinoButton(
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                    child: Row(
                      children: const [
                        Icon(Icons.filter_alt_outlined,color: textColorPrimary,),
                        SizedBox(width: 8,),
                        Text("Filter Students",
                        style: TextStyle(color: textColorPrimary),),
                      ],
                    ),
                  ), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>const
                SchoolManagerExamMarksFilter())).then((value) {
                  if(value){
                    setState(() {
                      _showFilteredList=true;
                    });

                  }
                });
              }),
              const SizedBox(height: 12,),

              _showFilteredList?
                  studentsListView():Container(),

              


            ],
          ),
        ),

      ),
    );
  }

  Widget studentsListView(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:
      List.generate(10, (index) {
        return const SchoolManagerInputMarksWidget();
      })
    );
  }
}
