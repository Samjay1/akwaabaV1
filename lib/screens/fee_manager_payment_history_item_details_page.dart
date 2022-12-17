import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class FeeManagerPaymentHistoryItemDetailsPage extends StatefulWidget {
  final String fullName;
  final String feeType;
  final String amountPaid;
  final String assignedFee;
  final String assignedDuration;
  final String arrears;
  final String date;

  const FeeManagerPaymentHistoryItemDetailsPage({Key? key,
    required this.fullName,
    required this.feeType,
    required this.amountPaid,
    required this.assignedFee,
    required this.assignedDuration,
    required this.arrears,
    required this.date
  }) : super(key: key);

  @override
  State<FeeManagerPaymentHistoryItemDetailsPage> createState() => _FeeManagerPaymentHistoryItemDetailsPageState();
}

class _FeeManagerPaymentHistoryItemDetailsPageState extends State<FeeManagerPaymentHistoryItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Membership Fees",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600
              ),),

              const SizedBox(height: 24,),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Fees Type",
                    style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w700),),
                    const SizedBox(height: 12,),
                    rowBorderView(title: "Fee Type", info: "${widget.feeType}"),
                    rowBorderView(title: "Assigned Fee", info: "GHS ${widget.assignedFee}"),
                    rowBorderView(title: "Assigned Duration", info: "${widget.assignedDuration}"),
                  ],
                ),
              ),

              const SizedBox(height: 12,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Payment Details",
                      style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w700),),
                    const SizedBox(height: 12,),
                    rowBorderView(title: "Amount Paid", info: "GHS ${widget.amountPaid}"),
                    rowBorderView(title: " ", info: "${widget.date}"),
                    rowBorderView(title: "Amount in Arrears ", info: "GHS ${widget.arrears}"),
                  ],
                ),
              )

            ],
          ),
        ),
      ),

    );
  }

  Widget rowBorderView({
    required String title, required String info,
  }){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title"),
              Text("$info"),
            ],
          ),
          Divider(height: 0,color: textColorLight,),
        ],
      ),
    );
  }
}
