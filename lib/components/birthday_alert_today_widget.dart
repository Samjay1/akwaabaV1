import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/dialogs_modals/send_bday_msg_modal.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthdayAlertItemTodayWidget extends StatefulWidget {
  const BirthdayAlertItemTodayWidget({Key? key}) : super(key: key);

  @override
  State<BirthdayAlertItemTodayWidget> createState() => _BirthdayAlertItemTodayWidgetState();
}

class _BirthdayAlertItemTodayWidgetState extends State<BirthdayAlertItemTodayWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  defaultProfilePic(height: 50),
                  const SizedBox(width: 8,),
                  const Text("Steward Peters",)
                ],
              ),

              const SizedBox(height: 8,),
              OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),

                    ),

                  ),
                  onPressed: (){
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context){
                      return Wrap(
                        children: const [
                          SendBirthdayMessageView()
                        ],
                      );
                        });
                  },
                  icon: const Icon(CupertinoIcons.chat_bubble,color: primaryColor,
                  size: 16,),
                  label: const Text("Send a wish",style: TextStyle(color: primaryColor,
                  fontSize: 12)))
            ],
          ),
        ),
      ),
    );
  }
}
