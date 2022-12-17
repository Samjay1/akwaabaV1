import 'package:akwaaba/components/school_manager_menu_widget.dart';
import 'package:flutter/material.dart';

class SchoolManagerMenusPage extends StatefulWidget {
  const SchoolManagerMenusPage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerMenusPage> createState() => _SchoolManagerMenusPageState();
}

class _SchoolManagerMenusPageState extends State<SchoolManagerMenusPage> {
  bool _isSchoolManagerAdmin=true;


  @override
  void initState() {
    super.initState();
    _isSchoolManagerAdmin=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("School Manager"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: _isSchoolManagerAdmin?
          Column(
            children: const [
              SchoolManagerMenuWidget(menuDetails: {"name":"Tutor Dashboard","id":6}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Enter Scores/Marks","id":7}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Exams Report","id":2}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Class Score","id":3}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Student Assignment","id":9}),
              SchoolManagerMenuWidget(menuDetails: {"name":"View Tutors","id":4}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Admin Login","id":10}),
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  const [
              SchoolManagerMenuWidget(menuDetails: {"name":"Student Dashboard","id":1}),
              SchoolManagerMenuWidget(menuDetails: {"name":"View Exams Report","id":2}),
              SchoolManagerMenuWidget(menuDetails: {"name":"View Class Score","id":3}),
              SchoolManagerMenuWidget(menuDetails: {"name":"View Tutors","id":4}),
              SchoolManagerMenuWidget(menuDetails: {"name":"Class Assignment","id":5})
            ],
          ),
        ),
      ),
    );
  }
}
