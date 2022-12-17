import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberClockSelectionWidget extends StatefulWidget {
  final Map member;
  const MemberClockSelectionWidget(this.member,{Key? key}) : super(key: key);

  @override
  State<MemberClockSelectionWidget> createState() => _MemberClockSelectionWidgetState();
}

class _MemberClockSelectionWidgetState extends State<MemberClockSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
      child: Card(
       color: widget.member["status"]?Colors.orange.shade100:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: widget.member["status"]?3:0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
               Icon(
                  widget.member["status"]?
                      CupertinoIcons.check_mark_circled_solid:
                  CupertinoIcons.checkmark_alt_circle,
               color: widget.member["status"]?primaryColor:Colors.grey,),
              const SizedBox(width: 8,),
              defaultProfilePic(height: 50),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:  [
                    const Text("Rexford Amponsah",style: TextStyle(fontSize: 18),),

                    const SizedBox(height: 7,),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              LabelWidgetContainer(label: "Clock In",
                                  child: Text("12:00")),

                              const SizedBox(height: 9,),

                              LabelWidgetContainer(label: "Clock Out",
                                  child: Text("00:00")),

                              TextButton(onPressed: (){},
                                  child: Text("Set Time"))
                            ],
                          ),
                        ),

                        Icon(Icons.arrow_left,
                        size: 40,

                        color: Colors.green,),

                        Icon(Icons.arrow_right,
                          size: 40,
                          color: Colors.red,),

                        Expanded(
                          child: Column(
                            children: [
                              LabelWidgetContainer(label: "Start",
                                  child: Text("12:00")),

                              const SizedBox(height: 9,),

                              LabelWidgetContainer(label: "End ",
                                  child: Text("00:00")),

                              TextButton(onPressed: (){},
                                  child: Text("  "))
                            ],
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
