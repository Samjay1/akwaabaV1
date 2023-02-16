class AssignedFee {
  int? id;
  String? clientId;
  String? memberId;
  String? branch;
  String? memberCategory;
  String? group;
  String? subgroup;
  String? member;
  String? donationName;
  String? usercode;
  int? totalInvoice;
  String? installRange;
  int? installPeriod;
  dynamic installAmount;
  int? expirationBill;
  String? setPayDate;
  String? startDate;
  String? endDate;
  int? amountByDays;
  bool? deactivate;
  dynamic accountStatus;
  String? invoiceType;
  bool? auto;
  String? dateCreated;
  int? feeType;
  int? feeDescription;

  AssignedFee(
      {this.id,
      this.clientId,
      this.memberId,
      this.branch,
      this.memberCategory,
      this.group,
      this.subgroup,
      this.member,
      this.donationName,
      this.usercode,
      this.totalInvoice,
      this.installRange,
      this.installPeriod,
      this.installAmount,
      this.expirationBill,
      this.setPayDate,
      this.startDate,
      this.endDate,
      this.amountByDays,
      this.deactivate,
      this.accountStatus,
      this.invoiceType,
      this.auto,
      this.dateCreated,
      this.feeType,
      this.feeDescription});

  AssignedFee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    memberId = json['member_id'];
    branch = json['branch'];
    memberCategory = json['member_category'];
    group = json['group'];
    subgroup = json['subgroup'];
    member = json['member'];
    donationName = json['donation_name'];
    usercode = json['usercode'];
    totalInvoice = json['total_invoice'];
    installRange = json['install_range'];
    installPeriod = json['install_period'];
    installAmount = json['install_amount'];
    expirationBill = json['expiration_bill'];
    setPayDate = json['set_pay_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    amountByDays = json['amount_by_days'];
    deactivate = json['deactivate'];
    accountStatus = json['account_status'];
    invoiceType = json['invoice_type'];
    auto = json['auto'];
    dateCreated = json['date_created'];
    feeType = json['fee_type'];
    feeDescription = json['fee_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['member_id'] = memberId;
    data['branch'] = branch;
    data['member_category'] = memberCategory;
    data['group'] = group;
    data['subgroup'] = subgroup;
    data['member'] = member;
    data['donation_name'] = donationName;
    data['usercode'] = usercode;
    data['total_invoice'] = totalInvoice;
    data['install_range'] = installRange;
    data['install_period'] = installPeriod;
    data['install_amount'] = installAmount;
    data['expiration_bill'] = expirationBill;
    data['set_pay_date'] = setPayDate;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['amount_by_days'] = amountByDays;
    data['deactivate'] = deactivate;
    data['account_status'] = accountStatus;
    data['invoice_type'] = invoiceType;
    data['auto'] = auto;
    data['date_created'] = dateCreated;
    data['fee_type'] = feeType;
    data['fee_description'] = feeDescription;
    return data;
  }
}
