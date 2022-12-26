import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AkwaabaModuleItemWidget extends StatefulWidget {
  final AkwaabaModuleItem akwaabaModuleItem;
  const AkwaabaModuleItemWidget(this.akwaabaModuleItem,{Key? key}) : super(key: key);

  @override
  State<AkwaabaModuleItemWidget> createState() => _AkwaabaModuleItemWidgetState();
}

class _AkwaabaModuleItemWidgetState extends State<AkwaabaModuleItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              enableFeedback: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)
              ),
              elevation: 9
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>
                WebViewPage(url: widget.akwaabaModuleItem.url,)));

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child:  Image.asset(widget.akwaabaModuleItem.iconPath!,width: 50,
                        height: 50,),
                    )



                  ],
                ),),
              const SizedBox(height: 8,),
              Expanded(
                flex: 5,
                child: Text(
                  widget.akwaabaModuleItem.moduleName!,textAlign: TextAlign.center,
                    style:const TextStyle(
                      fontFamily: "Lato",fontSize: 16,color: textColorPrimary
                    )

                ),
              ),
            ],
          )),
    );
  }

  menuTapped(){
    switch(widget.akwaabaModuleItem.id){
      case 1:
        //attendance report
      showNormalToast("Not implemented on current akwaaba app");
        break;
      case 2:
        //additional registrations questions\
      showNormalToast("Not implemented on current akwaaba app");
        break;
      case 3:
        //group meeting
      displayCustomDropDown(options: ["Create Meeting","Set Meeting Time","Assign Meeting Group"],
          context: context,listItemsIsMap: false).then((value) {});
        break;
      case 4:
        //general meeting
        displayCustomDropDown(options: ["Set Meeting Time","Set Meeting Days","Set Location"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 5:
        //communication
        displayCustomDropDown(options: ["Send App Message",
          "Send App Messages","Send SMS/Voice","Sent SMS/Voice"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 6:
        //clocking agents
        showNormalToast("Not implemented on current akwaaba app");
        break;
      case 7:
        //attendance status
        displayCustomDropDown(options: ["Create Status",
          "Assign Status",],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 8:
      //dues status
        displayCustomDropDown(options: ["Records",
          "Bulk Payment","Settings"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 9:
      //office manager
        displayCustomDropDown(options: ["Office Visitors",
          "Appointments","Reminders"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 10:
        //admin users
        showNormalToast("Not implemented on current akwaaba app");
        break;
      case 11:
        //file manager
        displayCustomDropDown(options: ["File Manager",
          "File Finder","File Archive"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 12:
        //account settings
        showNormalToast("Not implemented on current akwaaba app");
        break;
      case 13:
        //system tutorials
        displayCustomDropDown(options: ["Admin Tutorials",
          "Web App Tutorials","Mobile App Tutorials","Nstacom Tutorials"],
            context: context,listItemsIsMap: false).then((value) {});
        break;
      case 14:
        //terms and conditions
        showNormalToast("Not implemented on current akwaaba app");
        break;

    }
  }
}

class AkwaabaModuleItem {
  String? moduleName;
  String? iconPath;
  int? id;
  String? url;

  AkwaabaModuleItem({this.moduleName, this.iconPath, this.id,this.url});

  AkwaabaModuleItem.fromJson(Map<String, dynamic> json) {
    moduleName = json['module_name'];
    iconPath = json['icon_path'];
    id = json['id'];
    url=json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_name'] = this.moduleName;
    data['icon_path'] = this.iconPath;
    data['id'] = this.id;
    data["url"]=this.url;
    return data;
  }
}

