import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/register_connecting_user_widget.dart';
import 'package:akwaaba/versionOne/member_registration_page_individual.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterConnectingUsersPage extends StatefulWidget {
  const RegisterConnectingUsersPage({Key? key}) : super(key: key);

  @override
  State<RegisterConnectingUsersPage> createState() => _RegisterConnectingUsersPageState();
}

class _RegisterConnectingUsersPageState extends State<RegisterConnectingUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Connecting Users"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:   [
                    const CupertinoSearchTextField(
                      placeholder: "Enter User Name",
                    ),
                    const SizedBox(height: 8,),
                    const Text("Or",textAlign: TextAlign.center,
                    style: TextStyle(color: textColorLight,fontSize: 15),),
                    const SizedBox(height: 8,),

                    const CupertinoSearchTextField(
                      placeholder: "Enter User Name",
                    ),
                    const SizedBox(height: 12,),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                       color: primaryColor,
                        child: const Text("Search",
                        style: TextStyle(color: Colors.black),),
                        onPressed: (){}),

                    const SizedBox(height: 24,),

                    usersListView(),
                  ],
                ),
              ),
            ),

            CustomElevatedButton(label: "Proceed Registration", function: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MemberRegistrationPageIndividual()));
            })
          ],
        ),
      ),
    );
  }

  Widget usersListView(){
    return ListView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 14,
        itemBuilder: (_,int index){
          return const RegisterConnectingUserWidget();
        });
  }



}
