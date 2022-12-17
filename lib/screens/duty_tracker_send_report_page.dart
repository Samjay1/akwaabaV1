import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DutyTrackerSendReportPage extends StatefulWidget {
  const DutyTrackerSendReportPage({Key? key}) : super(key: key);

  @override
  State<DutyTrackerSendReportPage> createState() => _DutyTrackerSendReportPageState();
}

class _DutyTrackerSendReportPageState extends State<DutyTrackerSendReportPage> {
  final TextEditingController _controllerWorkDesc = TextEditingController();
  final TextEditingController _controllerOTWorkDesc = TextEditingController();
  int _radioGroupValWork=0;
  int _radioGroupValOvertime=0;
  double _currentSliderValue = 0.0;
  String? _sliderStatus;
  var numberFormat = NumberFormat("###", "en_US");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                     Align(
                       alignment: Alignment.topLeft,
                       child: Text("Share details of work done today",
                    style: Theme.of(context).textTheme.headline4,),
                     ),
                    const SizedBox(height: 12,),

                   LabelWidgetContainer(label: "Did you do any work today?",
                       child: Container(
                         margin: const EdgeInsets.symmetric(horizontal: 1),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(defaultRadius),
                           border: Border.all(color:Colors.grey.shade400 ,width: 0)
                         ),
                         child: Row(
                           children: [
                             for (int i = 1; i <= 2; i++)
                               Expanded(
                                 child: ListTile(
                                   title: Text(
                                     i==1?"Yes":"No",
                                     style: Theme.of(context).textTheme.subtitle1,
                                   ),
                                   leading: Radio(
                                     value: i,
                                     groupValue: _radioGroupValWork,
                                     activeColor: primaryColor,
                                     onChanged:  (int? value) {
                                       setState(() {
                                         _radioGroupValWork = value!;
                                       });
                                     },
                                   ),
                                 ),
                               ),
                           ],
                         ),
                       )),

                   const SizedBox(height: 24,),
                   
                   LabelWidgetContainer(label: "Details of work done",
                       child:  FormTextField(controller: _controllerWorkDesc,
                         minLines: 6,maxLines: 14,label: "",textInputType: TextInputType.multiline,
                         textInputAction: TextInputAction.newline,
                       )),
                    
                    LabelWidgetContainer(label: "Rate the Percentage of the work you have done today ",
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("${numberFormat.format(_currentSliderValue)}%"),
                            CupertinoSlider(
                              key: const Key('slider'),
                              value: _currentSliderValue,
                              // This allows the slider to jump between divisions.
                              // If null, the slide movement is continuous.
                              // divisions: 20,
                              // The maximum slider value
                              max: 100,
                              activeColor: primaryColorLight,
                              thumbColor: primaryColorDark,
                              // This is called when sliding is started.
                              onChangeStart: (double value) {
                                setState(() {
                                  _sliderStatus = 'Sliding';
                                });
                              },
                              // This is called when sliding has ended.
                              onChangeEnd: (double value) {
                                setState(() {
                                  _sliderStatus = 'Finished sliding';
                                });
                              },
                              // This is called when slider value is changed.
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                          ],
                        )),


                    const SizedBox(height: 8,),

                    LabelWidgetContainer(label: "File Attachment",
                        child: FormButton(label: "Pick File",function: (){},
                        iconData: Icons.attach_file,)),

                    const SizedBox(height: 24,),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Share details of overtime work done today",
                        style: Theme.of(context).textTheme.headline4,),
                    ),
                    const SizedBox(height: 8,),

                    LabelWidgetContainer(label: "Did you do overtime today?",
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(defaultRadius),
                              border: Border.all(color:Colors.grey.shade400 ,width: 0)
                          ),
                          child: Row(
                            children: [
                              for (int i = 1; i <= 2; i++)
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      i==1?"Yes":"No",
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    leading: Radio(
                                      value: i,
                                      groupValue: _radioGroupValOvertime,
                                      activeColor: primaryColor,
                                      onChanged:  (int? value) {
                                        setState(() {
                                          _radioGroupValOvertime = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 24,),

                    const SizedBox(height: 12,),
                    LabelWidgetContainer(label: "Details of work done",
                        child:  FormTextField(controller: _controllerOTWorkDesc,
                          minLines: 5,maxLines: 13,label: "",textInputType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        )),

                    LabelWidgetContainer(label: "File Attachment",
                        child: FormButton(label: "Pick File",function: (){},
                          iconData: Icons.attach_file,)),

                  ],
                ),
              ),
            ),

            CustomElevatedButton(label: "Send ", function: (){})
          ],
        ),
      ),
    );
  }
}
