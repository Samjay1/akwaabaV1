class ClockInResponse {
  int? id;
  int? meetingEventId;
  int? memberId;
  int? accountType;
  bool? inOrOut;
  String? inTime;
  dynamic outTime;
  dynamic startBreak;
  dynamic endBreak;
  int? clockedBy;
  int? clockingMethod;
  int? validate;
  dynamic validationDate;
  int? validatedBy;
  String? date;
  String? message;

  ClockInResponse({
    this.id,
    this.meetingEventId,
    this.memberId,
    this.accountType,
    this.inOrOut,
    this.inTime,
    this.outTime,
    this.startBreak,
    this.endBreak,
    this.clockedBy,
    this.clockingMethod,
    this.validate,
    this.validationDate,
    this.validatedBy,
    this.date,
    this.message,
  });

  ClockInResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    memberId = json['memberId'];
    accountType = json['accountType'];
    inOrOut = json['inOrOut'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
    clockedBy = json['clockedBy'];
    clockingMethod = json['clockingMethod'];
    validate = json['validate'];
    validationDate = json['validationDate'];
    validatedBy = json['validatedBy'];
    date = json['date'];
    message = json['SUCCESS_RESPONSE_MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['meetingEventId'] = meetingEventId;
    data['memberId'] = memberId;
    data['accountType'] = accountType;
    data['inOrOut'] = inOrOut;
    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['startBreak'] = startBreak;
    data['endBreak'] = endBreak;
    data['clockedBy'] = clockedBy;
    data['clockingMethod'] = clockingMethod;
    data['validate'] = validate;
    data['validationDate'] = validationDate;
    data['validatedBy'] = validatedBy;
    data['date'] = date;
    data['SUCCESS_RESPONSE_MESSAGE'] = message;
    return data;
  }
}
