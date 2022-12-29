import 'package:akwaaba/screens/member_registration_page_organization.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../versionOne/member_registration_page_individual.dart';

class NewRegistrationModalSheetView extends StatefulWidget {
  const NewRegistrationModalSheetView({Key? key}) : super(key: key);

  @override
  State<NewRegistrationModalSheetView> createState() => _NewRegistrationModalSheetViewState();
}

class _NewRegistrationModalSheetViewState extends State<NewRegistrationModalSheetView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48,horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);//close the dialog
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const MemberRegistrationPageIndividual()));
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,horizontal: 8
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.person_add_alt_1,
                      color: primaryColor,
                      size: 50,),
                      SizedBox(height: 8,),
                      Text("New Individual")
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);//close the dialog
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                const MemberRegistrationPageOrganization()));
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24,horizontal: 8
                  ),
                  child: Column(
                    children: const [
                      Icon(CupertinoIcons.person_3_fill,
                        color: primaryColor,
                        size: 50,),
                      SizedBox(height: 8,),
                      Text("New Organization")
                    ],
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
