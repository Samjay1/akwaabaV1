import 'package:akwaaba/components/school_manager_tutor_list_widget.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchoolManagerTutorsListPage extends StatefulWidget {
  const SchoolManagerTutorsListPage({Key? key}) : super(key: key);

  @override
  State<SchoolManagerTutorsListPage> createState() => _SchoolManagerTutorsListPageState();
}

class _SchoolManagerTutorsListPageState extends State<SchoolManagerTutorsListPage> {
  final TextEditingController _controllerSearch=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutors List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoSearchTextField(
              controller: _controllerSearch,
            ),

            const SizedBox(height: 16,),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                  itemCount: 14,
                  itemBuilder: (_,int index){
                return const SchoolManagerTutorListWidget();
              }),
            ),

            // Expanded(
            //   child: ListView(
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     children:List.generate(10, (index) {
            //       return const SchoolManagerTutorListWidget();
            //     }),
            //   ),
            // )

          ],
        ),
      ),
    );
  }
}
