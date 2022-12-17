import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/material.dart';

import '../components/form_button.dart';
import '../components/msg_manager_scheduled_msg_widget.dart';
import '../utils/widget_utils.dart';

class PostMasterOutboxPage extends StatefulWidget {
  const PostMasterOutboxPage({Key? key}) : super(key: key);

  @override
  State<PostMasterOutboxPage> createState() => _PostMasterOutboxPageState();
}

class _PostMasterOutboxPageState extends State<PostMasterOutboxPage> {
  String? selectedServiceType;


  selectServiceType(){
    displayCustomDropDown(
        title: "Service Type ",
        options: ["SMS","Voice","Web SMS",
          "Email"], context: context,listItemsIsMap: false).then((value) {
      setState(() {
        selectedServiceType=value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Outbox"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

         LabelWidgetContainer(label: "Service Type",
                child: FormButton(label:selectedServiceType??"Select Service Type",
                  function: (){selectServiceType();},)),

            CustomElevatedButton(label: "Search", function: (){}),

            Divider(),
            const SizedBox(height: 16,),

            Expanded(child: ListView(
              physics: const BouncingScrollPhysics(),
              children: List.generate(20, (index) {
                return const MsgManagerScheduleMsgWidget();
              }),
            ))

      ],
        ),
      ),
    );
  }
}
