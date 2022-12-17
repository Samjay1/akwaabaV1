import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactLeaderListWidget extends StatelessWidget {
  const ContactLeaderListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      // padding: EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12)
      // ),
      child:
      Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              defaultProfilePic(height: 45),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Michael Dankwa",
                    style: TextStyle(fontWeight: FontWeight.w700),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Main Branch",
                        style: TextStyle(color:textColorLight,fontSize: 14),),

                        Text("Category: Leader",
                        style: TextStyle(color:textColorLight,fontSize: 14),)
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [

                            InkWell(
                              onTap: (){
                                showNormalToast("Whatsapp tapped");
                              },
                              child: SvgPicture.asset("images/icons/whatsapp_ic.svg",
                                height: 17,width: 17,color: Colors.green,),
                            ),

                            const SizedBox(width: 24,),

                            InkWell(
                              onTap: (){
                                showNormalToast("Phone tapped");
                              },
                              child: SvgPicture.asset("images/icons/phone_ic.svg",
                                height: 17,width: 17,color: Colors.blueAccent,),
                            ),


                          ],
                        ),

                        TextButton(onPressed: (){
                          showNormalToast("Remove leader");
                        }, child:  const Text("Remove Leader",
                          style: TextStyle(fontSize: 12),)),




                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
