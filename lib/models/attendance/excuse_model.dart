class ExcuseModel {
  int? id;
  int? clockingId;
  String? excuse;
  int? enteredBy;
  String? date;
  String? message;
  List<dynamic>? nonFieldErrors;

  ExcuseModel({
    this.id,
    this.clockingId,
    this.excuse,
    this.enteredBy,
    this.date,
    this.message,
    this.nonFieldErrors,
  });

  ExcuseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clockingId = json['clockingId'];
    excuse = json['excuse'];
    enteredBy = json['enteredBy'];
    date = json['date'];
    message = json['SUCCESS_RESPONSE_MESSAGE'];
    nonFieldErrors = json['non_field_errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clockingId'] = clockingId;
    data['excuse'] = excuse;
    data['enteredBy'] = enteredBy;
    data['date'] = date;
    data['SUCCESS_RESPONSE_MESSAGE'] = message;
    data['non_field_errors'] = nonFieldErrors;

    return data;
  }
}
