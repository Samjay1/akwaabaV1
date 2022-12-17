import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/material.dart';

class MsgManagerScheduleMsgWidget extends StatefulWidget {
  final bool showCancelButton;
  const MsgManagerScheduleMsgWidget({this.showCancelButton=false, Key? key}) : super(key: key);

  @override
  State<MsgManagerScheduleMsgWidget> createState() => _MsgManagerScheduleMsgWidgetState();
}

class _MsgManagerScheduleMsgWidgetState extends State<MsgManagerScheduleMsgWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Message Subject is here!!!"),
          const SizedBox(height: 12,),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Text("230 ",
                    style: TextStyle(color: textColorPrimary,fontSize: 15),),
                    Text("Contacts",
                    style: TextStyle(color: textColorLight,fontSize: 13),)

                  ],
                ),
              ),  Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("460 ",
                      style: TextStyle(color: textColorPrimary,fontSize: 15),),
                    Text("Messages",
                      style: TextStyle(color: textColorLight,fontSize: 13),)

                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 12,),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.person,color: primaryColor,size: 15,),
                    Text("  Kofi Ansah | Sender ID 019202",style: TextStyle(
                      fontSize: 15,color: textColorLight
                    ),)
                  ],
                ),
              ),

              const Text("02/03/22@9pm",style: TextStyle(
                fontSize: 13,color: textColorLight
              ),)
            ],
          ),

          const SizedBox(height: 12,),

          const Text("Branch: Kasoa Branch",
          style: TextStyle(
            fontSize: 13
          ),),

          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(onPressed: (){},
          //       child: Text("Cancel",
          //       style: TextStyle(fontSize: 14,color: Colors.red),)),
          // )


        ],
      ),
    );
  }
}
