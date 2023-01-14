import 'package:akwaaba/components/member_widget.dart';
import 'package:akwaaba/screens/filter_members_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
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
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const FilterMembersPage()));
                }, icon: const Icon(Icons.filter_alt,color: primaryColor,))
              ],
            ),

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
}
