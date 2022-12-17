import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_theme.dart';
import '../utils/widget_utils.dart';


class MemberClockTimeSelectionWidget extends StatefulWidget {
  const MemberClockTimeSelectionWidget({Key? key}) : super(key: key);

  @override
  State<MemberClockTimeSelectionWidget> createState() => _MemberClockTimeSelectionWidgetState();
}

class _MemberClockTimeSelectionWidgetState extends State<MemberClockTimeSelectionWidget> {
  DateTime? _selectedTime;
  DateTime now = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [

                  defaultProfilePic(height: 50),
                  const SizedBox(width: 8,),

                  const Text("Username Name",style: TextStyle(fontSize: 18),),

                  const SizedBox(width: 8,),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Icon(Icons.alarm,size: 20,color: primaryColor,),
                  const Text("Clocking Time: ",
                    style: TextStyle(color: textColorLight,fontSize: 15),
                    textAlign: TextAlign.end,),
                  const SizedBox(width: 8,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      onPressed: (){
                        displayTimeSelector(initialDate:_selectedTime?? DateTime.now(),
                            context: context).then((value) {
                          if(value!=null){
                            setState(() {
                              _selectedTime=value;
                            });
                          }
                        });
                      },
                      child: Text(
                        DateFormat("HH:mm").format(_selectedTime??now),
                        style: const TextStyle(color: textColorPrimary),))

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
