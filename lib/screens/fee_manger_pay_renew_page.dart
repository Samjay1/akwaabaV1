import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/fee_manager/clientTotal_model.dart';
import '../models/fee_manager/feeType_model.dart';
import '../providers/feeManager_provider.dart';
class FeeManagerPayOrRenewPage extends StatefulWidget {
  const FeeManagerPayOrRenewPage({Key? key}) : super(key: key);

  @override
  State<FeeManagerPayOrRenewPage> createState() => _FeeManagerPayOrRenewPageState();
}

class _FeeManagerPayOrRenewPageState extends State<FeeManagerPayOrRenewPage> {
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerSubFees = TextEditingController();
  final TextEditingController _controllerEnterAmount = TextEditingController();
  final TextEditingController _controllerRemarks = TextEditingController();
  final TextEditingController _controllerDiscount= TextEditingController();
  String? selectedDurationType;
  String? selectedAccountType;
  List<int>durationList=[];
  int? selectedDuration;
  int expiredDays=0;
  String? selectedPaymentStatus;
  List<String> feeTypes = [];
  String? selectedFeeType;
  List? feeTypesList;

  @override
  void initState() {
    super.initState();
    expiredDays=0;///get expired days from API call
  }


  proceedInvoiceOrPayment(){
    ///only use this if the user is not a client
    if(selectedAccountType==null){
      showErrorToast("Select Account Type");
      return;
    }

    if(selectedDurationType==null  ||selectedDuration==null){
      showErrorToast("Select Duration");
      return;
    }

    ///only use this if the user is not a client
    if(_controllerSubFees.text.trim().isEmpty){
      showErrorToast("Enter subscription fees");
      return;
    }

    ///only use this if the user is not a client
    if(selectedFeeType==null){
      showErrorToast("Select Fee Type");
      return;
    }

    ///only use this if the user is not a client
    if(_controllerEnterAmount.text.trim().isEmpty){
      showErrorToast("Select input amount");
      return;
    }
    ///only use this if the user is not a client
    if(selectedPaymentStatus==null){
      showErrorToast("Select Payment Status");
      return;
    }
    else{
      print('DATA: PAY STATUS $selectedPaymentStatus, AMOUNT ${_controllerEnterAmount.text.trim()},REMARKS ${_controllerRemarks.text.trim()}, DESC ${_controllerDescription.text.trim()}, FEETYPE $selectedFeeType , SUB FEES ${_controllerSubFees.text.trim()}, DURATION TYPE $selectedDurationType, DURA $selectedDuration, ACCOUNTTYPE $selectedAccountType');
    }


  }

  selectDurationType(){
    displayCustomDropDown(options: ["Days","Months"], context: context,
    listItemsIsMap: false).then((value) {
      setState(() {
        selectedDurationType=value;
        selectedDuration=null;

        durationList.clear();
        if(value.toString().compareTo("Days")==0){
          for (int i=1;i<=20;i++){
            durationList.add(i);
          }
        }else{
          for (int i=1;i<=24;i++){
            durationList.add(i);
          }
        }

      });
    });

  }

  selectAccountType(){
    displayCustomDropDown(options: ["Subscriber Fees","Non Subscriber Fees"], context: context,
        listItemsIsMap: false).then((value) {
      setState(() {
        selectedAccountType=value;
      });
    });
  }

  selectDuration(){
    // select number of days or months
    displayCustomDropDown(options: durationList,
        context: context,listItemsIsMap: false).then((value) {
          setState(() {
            selectedDuration=value;

          });
    });
  }


  selectPaymentStatus(){
    //whether full payment or part payment
    //client may later ask us to automatically detect whether payment is in full or part,
    //rather than users selecting it themselves.
    //when this happens, please remember to charge extra GHS 1,000.

    displayCustomDropDown(options: ["Full Payment","Part Payment"],
        listItemsIsMap: false,
        context: context).then((value) {
       setState(() {
         selectedPaymentStatus=value;
       });
    });
  }

  selectFeeType(dataList){
    displayCustomDropDown(options: dataList, context: context,
        listItemsIsMap: false).then((value) {
      setState(() {
        selectedFeeType=value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<FeeProvider>(context,listen:false).getClientBill(context: context,clientId: 180);
    ClientTotalModel outstandingBill =  Provider.of<FeeProvider>(context,listen:false).getterClientBill;

    Provider.of<FeeProvider>(context,listen:false).getFeeTypes(context: context,clientId: 180);
    List<FeeType> feetypes = Provider.of<FeeProvider>(context,listen:false).getFeeTypesList;
    feeTypesList = feetypes.map((value) => value.feeType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay or Renew Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child:
              Consumer<GeneralProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.userIsAdmin?
                  adminAccountRenewalView(outstandingBill: outstandingBill.total_arrears, feeTypesList:feeTypesList):clientAccountRenewalView();
                },)
           ,
            ),
            
            CustomElevatedButton(label: "Proceed Invoice/Payment", function: (){
              proceedInvoiceOrPayment();
            })
          ],
        ),
      ),
    );
  }

  Widget renewSummaryView(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 3),
        child: Row(

          children: [
            Expanded(child: renewSummaryItemWidget(title: "Renew",
                value: selectedDuration??"")),

             Expanded(child: renewSummaryItemWidget(title: "Expired", value: expiredDays)),
             Expanded(child: renewSummaryItemWidget(title: "Remaining",
                 value:selectedDuration!=null? "${ selectedDuration!-expiredDays}":""))
          ],
        ),
      ),
    );
  }

  Widget renewSummaryItemWidget({required String title,
  required value}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title,
        style: const TextStyle(fontSize: 14),),

        Text("$value",
          style: const TextStyle(fontSize: 17),),
      ],
    );
  }


  Widget clientAccountRenewalView(){
    return SingleChildScrollView(
      child: Column(
        children: [

          LabelWidgetContainer(label: "Modules",
              child: FormButton(
                label: "Select Module",
                function: (){},
              )),

          LabelWidgetContainer(label: " Duration  Type",
              child:
              FormButton(label:selectedDurationType??"Select Duration ",function: (){
                selectDurationType();
              },)
          ),


          selectedDurationType!=null?
          LabelWidgetContainer(label: selectedDurationType!.compareTo("Days")==0?
          "Number of Days":"Number of Months",
              child: FormButton(
                label: selectedDuration!=null?"$selectedDuration" : "Select Number of ${selectedDurationType!.compareTo("Days")==0?
                "Days":"Months"}",
                function: (){
                  selectDuration();
                },
              )):
          const SizedBox.shrink(),

          renewSummaryView(),



          LabelWidgetContainer(label: "Subscription Fees",
              child: FormTextField(
                controller: _controllerSubFees,
                minLines: 1, maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
              )),

          LabelWidgetContainer(label: "Discount",
              child:FormTextField(
                controller: _controllerDiscount,
                maxLines: 1,minLines: 1,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
              )

          ),
        ],
      ),
    );
  }


  Widget adminAccountRenewalView( {required var outstandingBill, var feeTypesList}){

    return    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabelWidgetContainer(label: "Account Type",
              child:
              FormButton(label:selectedAccountType?? "Select Account Type",
                function: (){selectAccountType();},)
          ),

          LabelWidgetContainer(label: "Fees Description",

              child:FormTextField(
                controller: _controllerDescription,
                minLines: 4, maxLines: 8,
                textInputAction: TextInputAction.newline,
                textInputType: TextInputType.multiline,
              )

          ),

          LabelWidgetContainer(label: " Duration  Type",
              child:
              FormButton(label:selectedDurationType??"Select Duration ",function: (){
                selectDurationType();
              },)
          ),


          selectedDurationType!=null?
          LabelWidgetContainer(label: selectedDurationType!.compareTo("Days")==0?
          "Number of Days":"Number of Months",
              child: FormButton(
                label: selectedDuration!=null?"$selectedDuration" : "Select Number of ${selectedDurationType!.compareTo("Days")==0?
                "Days":"Months"}",
                function: (){
                  selectDuration();
                },
              )):
          const SizedBox.shrink(),

          renewSummaryView(),



          LabelWidgetContainer(label: "Subscription Fees",
              child: FormTextField(
                controller: _controllerSubFees,
                minLines: 1, maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
              )),

          LabelWidgetContainer(label: "Fee Type",
              child: FormButton(
                label: selectedFeeType!=null?'${selectedFeeType}':"Select Fee Type",
                function: (){
                  selectFeeType(feeTypesList);
                },
              )
          ),

          Row(
            children: [
              const Text("Outstanding Bill:   "),
              Text(" GHS $outstandingBill", style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 19),),
            ],
          ),

          const SizedBox(height: 18,),

          LabelWidgetContainer(label: "Amount",

              child:FormTextField(controller: _controllerEnterAmount,
                maxLines: 1,maxLength: 6,textInputType: TextInputType.number,)
          ),

          LabelWidgetContainer(label: "Status",
              child:
              FormButton(label:selectedPaymentStatus?? "Select Status",
                function: (){
                  selectPaymentStatus();
                },)
          ),

          LabelWidgetContainer(label: "Remarks",
              child:FormTextField(
                controller: _controllerRemarks,
                maxLines: 6,minLines: 4,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              )

          ),


        ],
      ),
    );
  }
}
