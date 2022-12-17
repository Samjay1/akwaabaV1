import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectUsersWidget extends StatefulWidget {
  const ConnectUsersWidget({Key? key}) : super(key: key);

  @override
  State<ConnectUsersWidget> createState() => _ConnectUsersWidgetState();
}

class _ConnectUsersWidgetState extends State<ConnectUsersWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  defaultProfilePic(height: 50),
                  const SizedBox(width: 8,),
                  const Expanded(
                    child: Text("User John Doe",
                    style: TextStyle(
                      fontSize: 19,fontWeight: FontWeight.w500
                    ),),
                  ),

                  Row(
                    children: [

                      GestureDetector(
                        onTap: (){
                          showNormalToast("Phone icon tapped");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("images/icons/phone_ic.svg",
                            width: 18,height: 18,color: Colors.blueAccent,),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          showNormalToast("Whatsapp icon tapped");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("images/icons/whatsapp_ic.svg",
                            width: 18,height: 18,color: Colors.green,),
                        ),
                      ),

                    ],
                  )
                ],
              ),
              const SizedBox(height: 6,),
              const Text("User/Member",
              style: TextStyle(fontSize: 14,color: textColorLight),),
              const SizedBox(height: 6,),
              const Divider(height: 0,),


              const SizedBox(height:2 ,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 CustomElevatedButton(
                   label: "Reject",
                   textColor: Colors.white,
                   function: (){},
                   color: Colors.redAccent,
                 labelSize: 14,),

                  const SizedBox(width: 10,),

                  CustomElevatedButton(
                    label: "Accept",
                    textColor: Colors.white,
                    function: (){},
                    color: Colors.green,
                    labelSize: 14,)

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
