import 'package:flutter/material.dart';

import '../components/info_widget.dart';
import '../utils/app_theme.dart';
import '../utils/widget_utils.dart';

class InfoCenterPostViewPage extends StatefulWidget {
  const InfoCenterPostViewPage({Key? key}) : super(key: key);

  @override
  State<InfoCenterPostViewPage> createState() => _InfoCenterPostViewPageState();
}

class _InfoCenterPostViewPageState extends State<InfoCenterPostViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column
            (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  defaultProfilePic(height: 50),
                  Column(
                    children: const [
                      Text("Tema General Hospital",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),

                    ],
                  )
                ],
              ),
              const SizedBox(height: 6,),
              const Text("Memo: Attendance Clocking App",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              const SizedBox(height: 12,),
              const Text("$loremIpsum",
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: textColorLight,fontSize: 15
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
