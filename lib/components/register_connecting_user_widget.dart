import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class RegisterConnectingUserWidget extends StatefulWidget {
  const RegisterConnectingUserWidget({Key? key}) : super(key: key);

  @override
  State<RegisterConnectingUserWidget> createState() =>
      _RegisterConnectingUserWidgetState();
}

class _RegisterConnectingUserWidgetState extends State<RegisterConnectingUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),

        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              defaultProfilePic(height: 45),
              const SizedBox(width: 6,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("John Mahama Mills"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){},
                            child: const Text("Select Connection Status",
                            style: TextStyle(color: textColorPrimary),)),
                        TextButton(onPressed: (){}, child: const Text("Remove",
                        style: TextStyle(color: Colors.red),))
                      ],
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
