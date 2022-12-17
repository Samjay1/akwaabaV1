import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';


class MyConnectionItemWidget extends StatefulWidget {
  const MyConnectionItemWidget({Key? key}) : super(key: key);

  @override
  State<MyConnectionItemWidget> createState() => _MyConnectionItemWidgetState();
}

class _MyConnectionItemWidgetState extends State<MyConnectionItemWidget> {

  displaySwitchDialog(){
    displayCustomCupertinoDialog(context: context,
        title: "Switch Account?",
        msg: "Do you want to switch to this account?\n You would gain full access to this account"
            "\n Feel free to switch back at any time.",
        actionsMap: {
      "No":(){
        Navigator.pop(context);
      },"Switch":(){}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: (){

        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                defaultProfilePic(height: 55),
                const Expanded(child: Text("James John Doe",
                style: TextStyle(
                  fontSize: 17,fontWeight: FontWeight.w500
                ),)),
                const Icon(Icons.chevron_right,size: 17,color: primaryColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
