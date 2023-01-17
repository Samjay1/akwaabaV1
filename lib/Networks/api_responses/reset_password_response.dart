class ResetPasswordResponse {
  bool? success;
  String? msg;
  dynamic data;
  List<dynamic>? nonFieldErrors;

  ResetPasswordResponse(
      {this.success, this.msg, this.data, this.nonFieldErrors});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'];
    nonFieldErrors = json['non_field_errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['non_field_errors'] = nonFieldErrors;
    return data;
  }
}
