import 'package:akwaaba/components/member_widget.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/filter_page.dart';

class MembersPage extends StatefulWidget {
  final bool isMemberuser;
  const MembersPage({required this.isMemberuser,Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMemberuser?"Members":'Organisations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    controller: _controllerSearch,
                  ),
                ),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> FilterPage(isMemberUser:widget.isMemberuser)));
                }, icon: const Icon(Icons.filter_alt,color: primaryColor,)),

              ],
            ),

            filteredSummaryView(isMemberUsers: widget.isMemberuser),
            const SizedBox(height: 8,),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:List.generate(20, (index) {
                  return MemberWidget();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filteredSummaryView({required bool isMemberUsers}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Total",
                  style: TextStyle(fontSize: 12),),
                Text("300")
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(isMemberUsers?"Males":'Registered',
                  style: TextStyle(fontSize: 12),),
                Text("30")
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(isMemberUsers?"Females":'Unregistered',
                  style: TextStyle(fontSize: 12),),
                Text("30")
              ],
            ),
          )
        ],
      ),
    );
  }
}
