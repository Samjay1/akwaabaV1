import 'package:akwaaba/components/activation_approval_item_widget.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectUsersPage extends StatefulWidget {
  const ConnectUsersPage({Key? key}) : super(key: key);

  @override
  State<ConnectUsersPage> createState() => _ConnectUsersPageState();
}

class _ConnectUsersPageState extends State<ConnectUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Users"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              
              filterButton(),
              const SizedBox(height: 16,),
              
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(10, (index) => const
                ConnectUsersWidget()),
              ),

            ],

          ),
        ),
      ),
    );
  }


  Widget filterButton(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "Filter Options ",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            filterOptionsList()
          ],
        ),
      ),
    );
  }


  Widget filterOptionsList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelWidgetContainer(label: "Branch", child:
        FormButton(label: "Select Branch",function: (){},)
        ),

        LabelWidgetContainer(label: "Category", child:
        FormButton(label: "Select Category",function: (){},)
        ),

        LabelWidgetContainer(label: "Group", child:
        FormButton(label: "Select Group",function: (){},)
        ),

        LabelWidgetContainer(label: "Sub Group", child:
        FormButton(label: "Select Sub Group",function: (){},)
        ),

        LabelWidgetContainer(label: "Member", child:
        FormButton(label: "Select Member",function: (){},)
        ),

        LabelWidgetContainer(
          label: "ID",
          child: CupertinoSearchTextField(
            placeholder: "Enter Id or Ref. Number",
          ),
        ),
        const SizedBox(height: 12,),

        CustomElevatedButton(label: "Filter", function: (){})
      ],
    );
  }
}
