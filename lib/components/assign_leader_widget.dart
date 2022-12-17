import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AssignLeaderWidget extends StatefulWidget {
  final Map leader;
  const AssignLeaderWidget(this.leader,{Key? key}) : super(key: key);

  @override
  State<AssignLeaderWidget> createState() => _AssignLeaderWidgetState();
}

class _AssignLeaderWidgetState extends State<AssignLeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: widget.leader["status"]?Colors.orange.shade100:Colors.white,
        elevation: widget.leader["status"]?3:0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                   Icon(
                    widget.leader["status"]?
                    Icons.check_circle:
                    Icons.check_circle_outline,
                  color:  widget.leader["status"]?primaryColor:Colors.grey
                  ,size: 20,),
                  const SizedBox(width: 3,),
                  defaultProfilePic(height: 45),
                  const SizedBox(width: 9,),
                  Text("Kwame Amponsah")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
