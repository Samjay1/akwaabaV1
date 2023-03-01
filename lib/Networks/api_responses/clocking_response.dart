class ClockingResponse {
  int? id;
  int? meetingEventId;
  int? memberId;
  int? accountType;
  bool? inOrOut;
  String? justification;
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
  List<dynamic>? nonFieldErrors;

  ClockingResponse({
    this.id,
    this.meetingEventId,
    this.memberId,
    this.accountType,
    this.inOrOut,
    this.justification,
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
    this.nonFieldErrors,
  });

  ClockingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    memberId = json['memberId'];
    accountType = json['accountType'];
    inOrOut = json['inOrOut'];
    justification = json['justification'];
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
    nonFieldErrors = json['non_field_errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['meetingEventId'] = meetingEventId;
    data['memberId'] = memberId;
    data['accountType'] = accountType;
    data['inOrOut'] = inOrOut;
    data['justification'] = justification;
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
    data['non_field_errors'] = nonFieldErrors;
    return data;
  }
}
