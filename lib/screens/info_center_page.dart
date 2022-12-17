import 'package:akwaaba/components/info_widget.dart';
import 'package:akwaaba/screens/new_post_page.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class InfoCenterPage extends StatefulWidget {
  const InfoCenterPage({Key? key}) : super(key: key);

  @override
  State<InfoCenterPage> createState() => _InfoCenterPageState();
}

class _InfoCenterPageState extends State<InfoCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: const Text("Info Center"),
      ),

      //only show the floating actions button is user is suepr admin,
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>NewPostPage()));
      },
          label: const Text("New Post"),
      backgroundColor: primaryColor,),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: List.generate(5, (index) => InfoWidget()),
        ),
      ),


    );
  }
}
