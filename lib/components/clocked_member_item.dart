import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_elevated_button.dart';
import 'custom_outlined_button.dart';

class ClockedMemberItem extends StatefulWidget {
  final Map member;
  const ClockedMemberItem(this.member,{Key? key}) : super(key: key);

  @override
  State<ClockedMemberItem> createState() => _ClockedMemberItemState();
}

class _ClockedMemberItemState extends State<ClockedMemberItem> {
  final TextEditingController startBreakcontroller = TextEditingController();
  final TextEditingController endBreakcontroller = TextEditingController();

  DateTime? _selectedTime;
  DateTime now = DateTime.now();

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Friday Work Duties",style: TextStyle(fontSize: 15),),
                        CustomOutlinedButton(label: "IN",mycolor:Colors.green, radius: 5, function: () {}),
                      ],
                    ),
                    Row(
                      children: const [
                        Text('IN : 7:30AM'),
                        SizedBox(width: 7,),
                        Text('OUT : 00:00')
                      ],
                    ),
                    const Divider(height:2, color: Colors.orange,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomElevatedButton(label: "Start Break",color:Colors.green, radius: 5, function: () {
                          displayTimeSelector(initialDate:_selectedTime?? DateTime.now(),
                              context: context).then((value) {
                            if(value!=null){
                              setState(() {
                                _selectedTime=value;
                              });
                            }
                          }).whenComplete(() => {
                            showModalBottomSheet(context: context, builder: (context){
                              return  FractionallySizedBox(
                                  heightFactor: 0.4,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20,),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child:  Text('Time ${DateFormat.jm().format(_selectedTime!)}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomElevatedButton(label: "Cancel",color:Colors.red, radius: 5, function: () {
                                            Navigator.pop(context);
                                          }),
                                          CustomElevatedButton(label: "Set Time",color:Colors.green, radius: 5, function: () {
                                            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Time has been Set')));
                                            Navigator.pop(context);
                                          })
                                        ],
                                      ),

                                    ],
                                  )
                              );

                            })

                          });
                        }),
                        CustomElevatedButton(label: "End Break",color:Colors.red, radius: 5, function: () {
                          displayTimeSelector(initialDate:_selectedTime?? DateTime.now(),
                              context: context).then((value) {
                            if(value!=null){
                              setState(() {
                                _selectedTime=value;
                              });
                            }
                          }).whenComplete(() => {
                            showModalBottomSheet(context: context, builder: (context){
                              return  FractionallySizedBox(
                                heightFactor: 0.4,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20,),
                                   Container(
                                     padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
                                     decoration: BoxDecoration(
                                       color: Colors.orange,
                                       borderRadius: BorderRadius.circular(5)
                                     ),
                                     child:  Text('Time ${DateFormat.jm().format(_selectedTime!)}',
                                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),
                                   ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomElevatedButton(label: "Cancel",color:Colors.red, radius: 5, function: () {
                                          Navigator.pop(context);
                                        }),
                                        CustomElevatedButton(label: "Set Time",color:Colors.green, radius: 5, function: () {
                                          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Time has been Set')));
                                          Navigator.pop(context);
                                        })
                                      ],
                                    ),

                                  ],
                                )
                              );

                              })

                          });
                        }),
                      ]
                    )

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
