
class MemberModel {
  var clientID;
  var memberID;
  var feeType;
  var member;
  var outstandingBill;
  var assignedDuration;
  var amountPaid;
  var arrears;
  var paymentStatus;
  var dateCreated;

  MemberModel(
      this.clientID,
      this.memberID,
      this.feeType,
      this.member,
      this.outstandingBill,
      this.assignedDuration,
      this.amountPaid,
      this.arrears,
      this.paymentStatus,
      this.dateCreated
      );

  factory MemberModel.fromJson(Map<String, dynamic> json){
    return MemberModel(
        json['client_id'],
        json['member_id'],
        json['fee_type'],
        json['member'],
        json['outstanding_bill'],
        json['assigned_duration'],
        json['amount_paid'],
        json['arrears'],
        json['payment_status'],
        json['date_created']
    );
  }
}