import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class MyConnectionsPage extends StatefulWidget {
  const MyConnectionsPage({Key? key}) : super(key: key);

  @override
  State<MyConnectionsPage> createState() => _MyConnectionsPageState();
}

class _MyConnectionsPageState extends State<MyConnectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Connections"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(5, (index) {
            return Padding(padding: const EdgeInsets.symmetric(vertical: 8),
              child:GestureDetector(
                onTap: (){
                  displayCustomCupertinoDialog(context: context,
                      title: "Switch Account?",
                      msg: "Do you want to switch to your account on Sample Organization?",
                      actionsMap: {
                    "No":(){
                      Navigator.pop(context);
                    },
                        "Yes":(){
                          Navigator.pop(context);
                        }
                      });
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              defaultProfilePic(height: 55),
                              const SizedBox(width: 8,),
                              const Text("Organization Name"),
                            ],
                          ),
                        ),


                        const Icon(Icons.chevron_right,color: primaryColor,)
                      ],
                    ),
                  ),
                ),
              ) ,);
          }),
        ),
      ),
    );
  }
}
