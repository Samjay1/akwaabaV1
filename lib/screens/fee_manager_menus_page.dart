import 'package:akwaaba/components/message_manager_menu_widget.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/screens/webview_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/client_provider.dart';
import 'fee_manager_payment_history_page.dart';
import 'fee_manger_pay_renew_page.dart';

class FeeManagerMenusPage extends StatefulWidget {
  const FeeManagerMenusPage({Key? key}) : super(key: key);

  @override
  State<FeeManagerMenusPage> createState() => _FeeManagerMenusPageState();
}

class _FeeManagerMenusPageState extends State<FeeManagerMenusPage> {

  var isAdmin;
  var clientToken;
  @override
  void initState() {
    // TODO: implement initState
     isAdmin = Provider.of<GeneralProvider>(context,listen: false).userIsAdmin? 'admin':'member';
     clientToken = Provider.of<ClientProvider>(context,listen: false).clientToken;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    print('isAdmin $isAdmin, clientToken $clientToken');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee Manager"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              MessageManagerMenuWidget(menuName: "Pay or Renew",
                  function: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        WebViewPage(
                            url: 'https://fees.akwaabasoftware.com/api/dashboard/role=$isAdmin/token=$clientToken/',
                            title: 'Pay or Renew')));
                  }),
    MessageManagerMenuWidget(menuName: "My Payment History",
                  function: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        const FeeManagerPaymentHistoryPage()));
                  }),

              MessageManagerMenuWidget(menuName: "Admin Dashboard",
                  function: (){
                   // showNormalToast("Display Webview");
                   Navigator.push(context, MaterialPageRoute(builder: (_)=> WebViewPage(url:'https://fees.akwaabasoftware.com/api/dashboard/role=$isAdmin/token=$clientToken/', title: 'Admin Dashboard')));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
