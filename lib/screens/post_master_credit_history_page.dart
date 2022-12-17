import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostMasterCreditHistoryPage extends StatefulWidget {
  const PostMasterCreditHistoryPage({Key? key}) : super(key: key);

  @override
  State<PostMasterCreditHistoryPage> createState() => _PostMasterCreditHistoryPageState();
}

class _PostMasterCreditHistoryPageState extends State<PostMasterCreditHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit History"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24,horizontal: 16
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children:List.generate(24,
                    (index) {
              return creditHistoryItemWidget();
                    }),
          ),
        ),
      ),
    );
  }

  Widget creditHistoryItemWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("SMS Topup"),
                  Text("12/10/2022 @ 3pm",
                  style: TextStyle(fontSize: 12),)
                ],
              )),
              Column(
                children: const [
                  Text("GHS 300",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                  Text("450 Credits",
                  style: TextStyle(fontSize: 14),)
                ],
              )
            ],
          ),
          const  SizedBox(height: 8,),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(onTap: (){
             // showNormalToast("Tapped");
              displayCustomDialog(context, creditHistoryPage());
            },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text("More Details",
                    style: TextStyle(
                      color: primaryColor,fontSize: 14
                    ),),
                    Icon(Icons.chevron_right,size: 14,color: primaryColor,)
                  ],
                )),
          )



        ],
      ),
    );
  }


  Widget creditHistoryPage(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          itemDetailsView(title: "Credit Type", value: "SMS"),
          itemDetailsView(title: "Amount ", value: "GHS 100"),
          itemDetailsView(title: "Total Credit ", value: "340"),
          itemDetailsView(title: "Date/Time ", value: "02/02/2022 @ 9pm"),
          itemDetailsView(title: "Branch ", value: "Main Branch"),
          itemDetailsView(title: "Purchased By: ", value: "Kofi Ansah"),
          itemDetailsView(title: "Date Expiring ", value: ""),
          itemDetailsView(title: "Credit Status", value: "Postpaid"),

          const SizedBox(height: 24,),
          CupertinoButton(child: const Text("Close"), onPressed: (){
            Navigator.pop(context);
          })
        ],
      ),
    );
  }

  Widget itemDetailsView({required String title, required String value}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0,color: Colors.grey.shade500), )
      ),
      child: Row(
        children: [
          Expanded(child: Text(title,
          style: const TextStyle(fontSize: 15),)),
          Text(value)
        ],
      ),
    );
  }
}
