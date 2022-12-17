import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../components/akwaaba_module_item_widget.dart';

class AkwaabaModules extends StatefulWidget {
  const AkwaabaModules({Key? key}) : super(key: key);

  @override
  State<AkwaabaModules> createState() => _AkwaabaModulesState();
}

class _AkwaabaModulesState extends State<AkwaabaModules> {

  List<AkwaabaModuleItem>menus=[
    AkwaabaModuleItem(moduleName: "Database Manager",
        iconPath: "images/icons/database_manager.png",
    url: "https://client.akwaabasoftware.com/login",
    id: 1),
    AkwaabaModuleItem(moduleName: "Attendance Manager",iconPath: "images/icons/database_manager.png",
        id: 1,url: "https://clockin.akwaabasoftware.com"),

    AkwaabaModuleItem(moduleName: "Fees Manager",iconPath: "images/icons/fees_manager.png",
        id: 1,url: "https://files.akwaabasoftware.com"),

    AkwaabaModuleItem(moduleName: "School Manager",iconPath: "images/icons/school_manager.png",
        url: "https://edu.akwaabasoftware.com", id: 1),

    AkwaabaModuleItem(moduleName: "Files Manager",iconPath: "images/icons/files_manager.png",
        id: 1,url: "https://files.akwaabasoftware.com"),

    AkwaabaModuleItem(moduleName: "Staff Duty Tracker ",iconPath: "images/icons/staff_duty_tracker.png",
        id: 1,url: "https://duty.akwaabasoftware.com"),

    AkwaabaModuleItem(moduleName: "Finance Manager",iconPath: "images/icons/finance_manager.png",
        url: "https://finance.akwaabasoftware.com",
        id: 1),
    AkwaabaModuleItem(moduleName: "Messenger Manager",iconPath: "images/icons/messenger.png",
        url: "https://messenger.akwaabasoftware.com",id: 1),


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Akwaaba Modules"),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  [


              GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero ,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                children: List.generate(menus.length, (index) =>
                    AkwaabaModuleItemWidget(menus[index])),),
            ],
          ),
        ),
      ),
    );
  }
}
