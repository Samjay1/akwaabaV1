import 'package:akwaaba/Networks/feeManagerApi.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/fee_manager_history_item_widget.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/models/fee_manager/feeDescription_model.dart';
import 'package:akwaaba/models/fee_manager/feeType_model.dart';
import 'package:akwaaba/providers/feeManager_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/widget_utils.dart';


class FeeManagerPaymentHistoryPage extends StatefulWidget {
  const FeeManagerPaymentHistoryPage({Key? key}) : super(key: key);

  @override
  State<FeeManagerPaymentHistoryPage> createState() => _FeeManagerPaymentHistoryPageState();
}

class _FeeManagerPaymentHistoryPageState extends State<FeeManagerPaymentHistoryPage> {

  // String _selectedDate = '';
  // String _dateCount = '';
  // String _range = '';
  // String _rangeCount = '';
  DateTime? startYear;
  DateTime? endYear;//start and end year | month for filter range
  String? selectedFeeDesc;
  String? selectedFeeType;

  List? feeTypesList;
  List? feeDescList;

  // pickDateRange() async {
  //   showModalBottomSheet(context: context, builder: (_){
  //     return Wrap(children: [
  //       SfDateRangePicker(
  //         onSelectionChanged: _onSelectionChanged,
  //         selectionMode: DateRangePickerSelectionMode.range,
  //       ),
  //     ],);
  //   });
  // }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   /// The argument value will return the changed date as [DateTime] when the
  //   /// widget [SfDateRangeSelectionMode] set as single.
  //   ///
  //   /// The argument value will return the changed dates as [List<DateTime>]
  //   /// when the widget [SfDateRangeSelectionMode] set as multiple.
  //   ///
  //   /// The argument value will return the changed range as [PickerDateRange]
  //   /// when the widget [SfDateRangeSelectionMode] set as range.
  //   ///
  //   /// The argument value will return the changed ranges as
  //   /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
  //   /// multi range.
  //   setState(() {
  //     if (args.value is PickerDateRange) {
  //       _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
  //       // ignore: lines_longer_than_80_chars
  //           ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
  //     } else if (args.value is DateTime) {
  //       _selectedDate = args.value.toString();
  //     } else if (args.value is List<DateTime>) {
  //       _dateCount = args.value.length.toString();
  //     } else {
  //       _rangeCount = args.value.length.toString();
  //     }
  //   });
  // }

  selectFeeType(dataList){
    displayCustomDropDown(options: dataList, context: context,
        listItemsIsMap: false).then((value) {
      setState(() {
        selectedFeeType=value;
      });
    });
  }

  selectFeeDesc(dataList){
    displayCustomDropDown(options: dataList, context: context,
        listItemsIsMap: false).then((value) {
      setState(() {
        selectedFeeDesc=value;
      });
    });
  }

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


  @override
  void initState(){
    // TODO: implement initState
    super.initState();

  }

  String DeefeeTypesList(id, feeTypes) {
    return feeTypes.map((value) => value.id == id ? value.feeType : '');
  }

  @override
  Widget build(BuildContext context){

    Provider.of<FeeProvider>(context,listen:false).getPaymentHistory(context: context,clientId: 180);
    Provider.of<FeeProvider>(context,listen:false).getFeeTypes(context: context,clientId: 180);
    Provider.of<FeeProvider>(context,listen:false).getFeeDesc(context: context,clientId: 180);
    // List<FeeType> feetypes = Provider.of<FeeProvider>(context,listen:false).getFeeTypesList;
    // List<FeeDescription> feedesc = Provider.of<FeeProvider>(context,listen:false).getFeeDescList;

    // feeTypesList = feetypes.map((value) => value.feeType).toList();
    // feeDescList = feedesc.map((value) => value.feeDescription).toList();
    // var feeTypeData = DeefeeTypesList(feeTypesList)

    // print('FEE type LIST: $feeTypesList');
    // print(feetypes[0].feeType.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Consumer<FeeProvider>(
                builder: (context,data,child){
                  return  LabelWidgetContainer(label: "Fee Type",
                      child: FormButton(
                        label: selectedFeeType!=null?'${selectedFeeType}':"Select Fee Type",
                        function: (){
                          var feetypes = data.getFeeTypesList;
                          var feeTypesList_test = feetypes.map((value) => value.feeType).toList();
                          selectFeeType(feeTypesList_test);
                        },
                      )
                  );
                },
              ),

              Consumer<FeeProvider>(
                builder: (context,data,child){
                  return  LabelWidgetContainer(label:"Payment Description",
                      child: FormButton(
                        label: selectedFeeDesc!=null?'$selectedFeeDesc':"Select Payment Description",
                        function: (){
                          var feedesc = data.getFeeDescList;
                          var feeDesList_test = feedesc.map((value) => value.feeDescription).toList();
                          selectFeeDesc(feeDesList_test);
                        },
                      )
                  );
                },
              ),

              LabelWidgetContainer(label: "Date Range ",
                  child:
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(

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
                  ),
              ),

              CustomElevatedButton(label: "Filter",
                  function: (){
                    Provider.of<FeeProvider>(context,listen:false).getFilterPaymentHistory(context: context,
                        clientId: 180,
                        feeType: selectedFeeType  == null? 'none' : selectedFeeType,
                        feeDesc: selectedFeeDesc  == null? 'none' : selectedFeeDesc,
                      startDate: startYear == null? 'none' : startYear,
                      endDate: endYear == null? 'none' : endYear
                    );

                  }),

              const SizedBox(height: 24,),

              paymentHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Remove this later
  Widget paymentHistoryList9(){
    return Column(
      children: List.generate(6, (index) {
        return const FeeManagerHistoryItemWidget(
          fullName: 'Lord Asante Fordjour',
          feeType: 'Membership Fees',
          amountPaid: '234',
          assignedFee: '2',
          assignedDuration: 'ds',
          arrears: '3',
          date: '23-10-2022',
        );
      }),
    );
  }

  Widget paymentHistoryList(){
    return Consumer<FeeProvider>(
        builder: (context, data, child){
          // print('****** ${data.paymentHistoryList[0].member} FOUND');
          print('****** ${data.paymentHistoryList.length} length FOUND');
          var items = data.paymentHistoryList;
          return data.paymentHistoryList.length != 0 ?
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,

                  itemBuilder: (context, index) {
                    return index >=0 ?  FeeManagerHistoryItemWidget(
                        fullName: '${items[index].member}',
                        feeType: '${items[index].feeType}',
                        amountPaid: '${items[index].amountPaid}',
                        assignedFee: '${items[index].arrears}',
                        assignedDuration: '${items[index].assignedDuration}',
                        arrears: '${items[index].arrears}',
                        date: '${items[index].dateCreated}',
                    ):
                    const  Text('No Payment History');
                  },
                )
              )
              : Center(
              child: Column(
                children: const [
                  Text('No Payment History'),
                  CircularProgressIndicator(),
                ],
              )
          );
        },
    );
  }
}
