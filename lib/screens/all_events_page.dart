
import 'package:akwaaba/components/meeting_event_widget.dart';
import 'package:akwaaba/screens/all_events_filter_page.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_elevated_button.dart';
import '../components/form_button.dart';
import '../components/label_widget_container.dart';
import '../models/meeting_event_item.dart';
import '../providers/member_provider.dart';
import '../utils/app_theme.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({Key? key}) : super(key: key);

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  DateTime? startYear;
  DateTime? endYear;//start and end year | month for filter range
  bool showFilteredResults=false;
  final TextEditingController _controllerSearch = TextEditingController();
  List<MeetingEventItem>events=[
    MeetingEventItem("Tues Office Work", "16 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Wed Office Work", "17 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Thurs Office Work", "18 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Frid Office Work", "19 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Office Retreat", "20 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Tues Office Work", "16 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Wed Office Work", "17 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Thurs Office Work", "18 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Frid Office Work", "19 Aug 2022", "8:00AM", "5:00PM"),
    MeetingEventItem("Office Retreat", "20 Aug 2022", "8:00AM", "5:00PM")
  ];
  int listType=0;//0= events, 1 = meetings
  int selectedEventType=-1;
  SharedPreferences? prefs;
  var memberToken;

  selectStartPeriod(){

    displayDateSelector(context: context,
      initialDate:startYear ?? DateTime.now(),
      minimumDate: DateTime(DateTime.now().year - 50, 1),
      maxDate: DateTime.now(),

    ).then((value) {
      setState(() {
        startYear = value;
      });
    });
  }

  selectEndPeriod(){
    displayDateSelector(context: context,
        initialDate:endYear ?? DateTime.now(),
        minimumDate: DateTime(DateTime.now().year - 50, 1),
        maxDate: DateTime.now()

    ).then((value) {
      setState(() {
        endYear = value;
      });
    });

  }


  void loadMeetingEventsByUserType() async{
      prefs = await SharedPreferences.getInstance();
      memberToken = prefs?.getString('memberToken');

      print('HOMEPAGE TOKEN ${memberToken}');
      // print('HOMEPAGE member id ${memberProfile.id}');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<MemberProvider>(context, listen: false).callUpcomingMeetingEventList(memberToken: memberToken, context: context);
      });
  }

  @override
  initState(){
    super.initState();
    loadMeetingEventsByUserType();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            CupertinoSearchTextField(controller: _controllerSearch,),

            const SizedBox(height: 16,),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.0,color:Colors.grey.shade400)
              ),
              child: Row(
                children:
                List.generate(2,
                        (index) {
                  return Expanded(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                                activeColor: primaryColor,
                                value: index,
                                groupValue: selectedEventType, onChanged: (int? value){
                                  setState(() {
                                    selectedEventType=index;
                                  });
                                }
                                ),
                            const SizedBox(width: 5,),
                            Text(index==0?"Events":"Meetings"),
                          ],
                        ),
                      ],
                    ),
                  );
                        }),
              ),
            ),

            const SizedBox(height: 24,),

            Row(
              children: [
                Expanded(
                  child:

                  LabelWidgetContainer(label: "Start Date",
                    child: FormButton(label:startYear!=null?DateFormat("dd MMM yyyy").format(startYear!):
                    "Start Period" , function: (){ selectStartPeriod();},
                      iconData: Icons.calendar_month_outlined,),),

                ),
                const SizedBox(width: 18,),

                Expanded(
                  child:

                  LabelWidgetContainer(label: "End Period",
                    child:   FormButton(label:endYear!=null?DateFormat("dd MMM yyyy").format(endYear!):
                    "End Period" , function: (){ selectEndPeriod();},
                      iconData: Icons.calendar_month_outlined,),),

                ),

              ],
            ),

            CustomElevatedButton(label: "Apply Filter", function: (){

            }),

            const SizedBox(height: 24,),


            //const SizedBox(height: 24,),

          // ListView(
          //   shrinkWrap: true,
          //
          //   physics: const NeverScrollableScrollPhysics(),
          //   children:List.generate(events.length, (index) {
          //   return  MeetingEventWidget(events[index]);
          // }),),

            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: Consumer<MemberProvider>(
                builder: (context, data, child){
                  return data.upcomingMeetingEventList != null ?  ListView.builder(
                      itemCount: data.upcomingMeetingEventList.length,
                      itemBuilder: (context, index){
                        var item = data?.upcomingMeetingEventList[index];
                        debugPrint('MEETING LIST ${item.memberType}');
                        return upcomingEvents(name: item.name, date: item.updateDate, startTime: item.startTime, closeTime: item.closeTime);
                      }
                  ): const Center(child: CircularProgressIndicator());
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget upcomingEvents({name, date, startTime,closeTime}){
    var months = ['','Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
    DateTime formatedDate = DateTime.parse(date.toString());
    var month = formatedDate.month;
    var day = formatedDate.day;
    var year = formatedDate.year;
    return MeetingEventWidget(
        MeetingEventItem(name, "$day, ${months[month]} $year", startTime, closeTime)
    );
  }

}
