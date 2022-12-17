import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LabelWidgetContainer extends StatelessWidget {
  final String? label;
  final Widget child;
  final bool setCompulsory;


  const LabelWidgetContainer({
    required this.label,
    required this.child,
    this.setCompulsory=false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  [
          RichText(
            text: TextSpan(
                text: label,
                style:
                const TextStyle(
                    color: textColorPrimary, fontSize: 13),
                children: <TextSpan>[
                  TextSpan(text:setCompulsory? ' * ':"",
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 13),

                  )
                ]
            ),
          ),

          const SizedBox(height: 3.0,),
          child
        ],
      ),
    );
  }

}
