import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../screens/fee_manager_payment_history_item_details_page.dart';

class FeeManagerHistoryItemWidget extends StatefulWidget {
  final String fullName;
  final String feeType;
  final String amountPaid;
  final String assignedFee;
  final String assignedDuration;
  final String arrears;
  final String date;

  const FeeManagerHistoryItemWidget({Key? key,
    required this.fullName,
    required this.feeType,
    required this.amountPaid,
    required this.assignedFee,
    required this.assignedDuration,
    required this.arrears,
    required this.date
  }) : super(key: key);

  @override
  State<FeeManagerHistoryItemWidget> createState() => _FeeManagerHistoryItemWidgetState();
}

class _FeeManagerHistoryItemWidgetState extends State<FeeManagerHistoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>
              FeeManagerPaymentHistoryItemDetailsPage(
                fullName: '${widget.fullName}',
                feeType: '${widget.feeType}',
                amountPaid: '${widget.amountPaid}',
                assignedFee: '${widget.assignedFee}',
                assignedDuration: '${widget.assignedDuration}',
                arrears: '${widget.arrears}',
                date: '${widget.date}',
              )
          ));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          elevation: 3,

          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
            child: Row(
              children: [
                defaultProfilePic(height: 55),
                const SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("${widget.fullName}",
                      style: TextStyle(
                        fontSize: 17,color: textColorDark,
                        fontWeight: FontWeight.w600
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${widget.feeType}"),
                          Text("Paid: GHS ${widget.amountPaid}",
                          style: TextStyle(fontWeight: FontWeight.w600),)
                        ],
                      )
                    ],
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
