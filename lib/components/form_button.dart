import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FormButton extends StatefulWidget {
  final String label;
  final Color textColor;
  final VoidCallback function;
  final IconData? iconData;
  final IconData? suffixIconData;
  final bool isCompulsory;
  final bool enableEdit;


   FormButton({
    required this.label,
    required this.function, this.iconData ,
        this.textColor=textColorPrimary,
        this.isCompulsory=false,
        this.enableEdit=true,
     this.suffixIconData
        });

  @override
  _FormButtonState createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 24,left: 1,right: 1),
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.0,color:Colors.grey.shade400 )
              )
          ),
          onPressed: widget.function,
          child: Row(
            children: [
              widget.iconData!=null?
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(widget.iconData,color: primaryColor,size: 20,),
              ):
              Container(),
              Expanded(
                  child: Text(widget.label,
                    style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                    ),)
              ),
              Icon(
                widget.suffixIconData ?? CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey.shade500,
                size: 16,)

            ],
          )),
    );

  }
}
