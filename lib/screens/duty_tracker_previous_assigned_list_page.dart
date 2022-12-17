import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/models/duty_tracker_date_range_filter_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/duty_report_item_widget.dart';
import '../utils/app_theme.dart';

class DutyTrackerPreviousAssignedListPage extends StatefulWidget {
  const DutyTrackerPreviousAssignedListPage({Key? key}) : super(key: key);

  @override
  State<DutyTrackerPreviousAssignedListPage> createState() => _DutyTrackerPreviousAssignedListPageState();
}

class _DutyTrackerPreviousAssignedListPageState extends State<DutyTrackerPreviousAssignedListPage> {
  final TextEditingController _controllerRating = TextEditingController();
  int reportingOptionIndex=0;

  viewFilterModal(){
    showModalBottomSheet(context: context,
        builder: (_){
      return Wrap(
        children: const [
          DutyTrackerDateRangeFilterView()
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Duties"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              filterView(),

              const SizedBox(height: 16,),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(6, (index) => const DutyReportItemWidget()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget filterView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const CupertinoSearchTextField(),

        const SizedBox(height: 12,),

        FormButton(label: "My Dashboard", function: (){}),

        MoreFiltersButton(),

      ],
    );
  }
  Widget MoreFiltersButton(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.white,
          title: const Text(
            "More Filters ",
            style: TextStyle(fontSize: 16.0,

                color: textColorPrimary
            ),
          ),
          children: <Widget>[
            moreFilteringView()
          ],
        ),
      ),
    );
  }

  Widget moreFilteringView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: LabelWidgetContainer(label: "Start Date",
                  child: FormButton(
                    label: "Select Date",
                    function: (){},
                  )),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: LabelWidgetContainer(label: "End Date",
                  child: FormButton(
                    label: "Select Date",
                    function: (){},
                  )),
            )
          ],
        ),

        LabelWidgetContainer(label: "Rating",
            child: FormTextField(controller: _controllerRating,)
        ),
        
        LabelWidgetContainer(label: "Reporting",
            child: Container(
               margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
               // color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textColorLight,width: 0)
              ),
              child: Row(
                children: List.generate(2, (index) {
                  return
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                            activeColor: primaryColor,
                            value: index, groupValue: reportingOptionIndex,
                            onChanged: (int? option){
                          setState(() {
                            reportingOptionIndex=option!;
                          });
                            }),
                        Text(index==0?"Done":"UnDone")
                      ],
                    ),
                  );
                }),
              ),
            )),
        
        const SizedBox(height: 12,),
        CustomElevatedButton(label: "Filter", function: (){}),
        const SizedBox(height: 12,),
      ],
    );
  }
}
