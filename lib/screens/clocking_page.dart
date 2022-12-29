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

class ClockingPage extends StatefulWidget {
  const ClockingPage({Key? key}) : super(key: key);

  @override
  State<ClockingPage> createState() => _ClockingPageState();
}

class _ClockingPageState extends State<ClockingPage> {
  List<Map> members = [
    {"status": false},
    {"status": false},
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

            CustomElevatedButton(label: "Filter", function: () {}),

            const SizedBox(
              height: 8,
            ),

            // CustomElevatedButton(label: "Filter", function: (){}),\

            const SizedBox(
              height: 24,
            ),
            LabelWidgetContainer(
                label: "Clocked In/Out",
                child: Row(
                  children: [
                    Text("Checked"),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child:
                            CustomOutlinedButton(label: "In", function: () {})),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child:
                            CustomOutlinedButton(label: "Out", function: () {}))
                  ],
                )),

            const SizedBox(
              height: 12,
            ),

            LabelWidgetContainer(
                label: "Break Time",
                child: Row(
                  children: [
                    Text(""),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child: CustomOutlinedButton(
                            label: "Start", function: () {})),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child:
                            CustomOutlinedButton(label: "End", function: () {}))
                  ],
                )),

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
                    child: MemberClockSelectionWidget(members[index]));
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
