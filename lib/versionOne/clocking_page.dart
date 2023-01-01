import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/custom_outlined_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/components/member_clock_selection_widget.dart';
import 'package:akwaaba/screens/clocking_options_page.dart';
import 'package:akwaaba/screens/filter_members_page.dart';
import 'package:akwaaba/screens/filter_options_for_clocking_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/clocked_member_item.dart';
import '../components/clocking_member_item.dart';
import '../components/form_textfield.dart';

class ClockingPage extends StatefulWidget {
  const ClockingPage({Key? key}) : super(key: key);

  @override
  State<ClockingPage> createState() => _ClockingPageState();
}

class _ClockingPageState extends State<ClockingPage> {

  final TextEditingController _controllerMinAge = TextEditingController();
  final TextEditingController _controllerMaxAge = TextEditingController();

  List<Map> members = [
    {"status": true},
    {"status": true},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
    {"status": false},
  ];
  bool itemHasBeenSelected =
      false; //at least 1 member has been selected, so show options menu
  List<Map> selectedMembersList = [];
  DateTime? generalClockTime;
  bool checkAll = false;


  bool clockingListState = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            filterButton(),

            const SizedBox(
              height: 24,
            ),

            // Row(
            //   children: [
            //const Expanded(child:
            CupertinoSearchTextField(),
            //),
            // IconButton(onPressed: (){
            //   Navigator.push(context, MaterialPageRoute(builder: (_)
            //   =>const FilterPageClocking()));
            // },
            //     icon: const Icon(Icons.filter_alt,color: primaryColor,))
            //   ],
            // ),

            const SizedBox(
              height: 12,
            ),

            const CupertinoSearchTextField(
              placeholder: "Enter ID",
            ),

            const SizedBox(
              height: 8,
            ),

            Text("Age Bracket"),
            const SizedBox(height: 12,),

            Row(
              children: [
                Expanded(
                  child: LabelWidgetContainer(
                    label: "Minimum Age",
                    child: FormTextField(
                      controller: _controllerMinAge,
                    ),
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: LabelWidgetContainer(
                    label: "Maximum Age",
                    child: FormTextField(
                      controller: _controllerMaxAge,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            CustomElevatedButton(label: "Filter", function: () {}),

            const SizedBox(
              height: 8,
            ),

            Divider(height:2, color: Colors.orange,),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //REFRESING BUTTON
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Text('Refresh', style:TextStyle(color:Colors.white)),
                  )
                ),
                //POST CLOCK DATE BUTTON
                GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Text('Post Clock Date', style:TextStyle(color:Colors.white)),
                    )
                ),
                //POST CLOCK TIME BUTTON
                GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Text('Post Clock Time', style:TextStyle(color:Colors.white)),
                    )
                )
              ],
            ),// CustomElevatedButton(label: "Filter", function: (){}),\
            const SizedBox(
              height: 8,
            ),
            Divider(height:2, color: Colors.orange,),


            const SizedBox(
              height: 24,
            ),
            LabelWidgetContainer(
                label: "Clocked In/Out",
                child: Row(
                  children: [
                    Text("Bulk Clock"),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child:
                            CustomOutlinedButton(label: "In",mycolor:Colors.green, radius: 5, function: () {})),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child:
                        CustomOutlinedButton(label: "Out",mycolor:Colors.red, radius: 5, function: () {})),
                  ],
                )),

            const SizedBox(
              height: 12,
            ),

            LabelWidgetContainer(
                label: "Break Time",
                child: Row(
                  children: [
                    Text("Bulk Break"),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child:
                        CustomElevatedButton(label: "Start", radius: 5, function: () {})),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child:
                        CustomElevatedButton(label: "End",color:Colors.blue, radius: 5, function: () {})),
                  ],
                )),



            const SizedBox(
              height: 8,
            ),
            Divider(height:2, color: Colors.orange,),
            const SizedBox(
              height: 8,
            ),
            Row(
            children: [

              Expanded(
                  child:
                  CustomElevatedButton(label: "Clocking List", radius: 5, function: () {
                    setState(() {
                      clockingListState = true;
                      checkAll = false;
                      debugPrint('     clockingListState = $clockingListState');
                    });
                  })),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child:
                  CustomElevatedButton(label: "Clocked List",color:Colors.green, radius: 5, function: () {

                    setState(() {
                      clockingListState = false;
                      checkAll = false;
                      debugPrint('     clockingListState = $clockingListState');
                    });
                  })),
            ],
          ),

            Row(
              children: [
                Checkbox(
                    activeColor: primaryColor,
                    shape: const CircleBorder(),
                    value: checkAll,
                    onChanged: (val) {
                      setState(() {
                        checkAll = val!;
                        for (Map map in members) {
                          map["status"] = checkAll;
                        }
                      });
                    }),
                Text("Check All")
              ],
            ),


            Divider(height:2, color: Colors.orange,),

            clockingListState? Column(
              children: List.generate(members.length, (index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (members[index]["status"]) {
                          //remove it
                          members[index]["status"] = false;
                          selectedMembersList.remove(members[index]);
                        } else {
                          members[index]["status"] = true;
                          selectedMembersList.add(members[index]);
                        }
                        if (selectedMembersList.isNotEmpty) {
                          itemHasBeenSelected = true;
                        } else {
                          itemHasBeenSelected = false;
                        }
                      });
                    },
                    child: ClockingMemberItem(members[index]));
              }),
            ):
            Column(
              children: List.generate(members.length, (index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (members[index]["status"]) {
                          //remove it
                          members[index]["status"] = false;
                          selectedMembersList.remove(members[index]);
                        } else {
                          members[index]["status"] = true;
                          selectedMembersList.add(members[index]);
                        }
                        if (selectedMembersList.isNotEmpty) {
                          itemHasBeenSelected = true;
                        } else {
                          itemHasBeenSelected = false;
                        }
                      });
                    },
                    child: ClockedMemberItem(members[index]));
              }),
            ),
            // itemHasBeenSelected?
            //     Container(
            //
            //       padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
            //       child: CustomElevatedButton(label: "Proceed to Clock",
            //       function: (){
            //         displayCustomCupertinoDialog(context: context,
            //             title: "Proceed to Clock", msg: "100 members have been selected,"
            //                 " do you want to clock them all now?",
            //             actionsMap: {"No":(){Navigator.pop(context);},
            //               "Yes":(){
            //               Navigator.pop(context);
            //               Navigator.push(context, MaterialPageRoute(builder: (_)=>
            //               const ClockingOptionsPage()));
            //               }});
            //       },),
            //     )
            //     :const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget filterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "More Filters ",
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: textColorPrimary),
          ),
          children: <Widget>[filterOptionsListView()],
        ),
      ),
    );
  }

  Widget filterOptionsListView() {
    return Column(
      children: [
        LabelWidgetContainer(
          label: "Branch",
          child: FormButton(
            label: "All",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Member Category",
          child: FormButton(
            label: "All",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Group",
          child: FormButton(
            label: "Select Group",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
          label: "Sub Group",
          child: FormButton(
            label: "Select Sub Group",
            function: () {},
          ),
        ),
        LabelWidgetContainer(
            label: "Meeting Type",
            child: FormButton(
              label: "Select Meeting Type",
              function: () {},
            )),
        LabelWidgetContainer(
            label: "Date",
            child: FormButton(
              label: "Select Date",
              function: () {},
            )),
        LabelWidgetContainer(
            label: "Set Mass Time",
            child: FormButton(
                label: generalClockTime != null
                    ? DateFormat("hh:mm").format(generalClockTime!)
                    : "Select time",
                function: () {})),
      ],
    );
  }
}
