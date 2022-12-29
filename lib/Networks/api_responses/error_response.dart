class ErrorResponse {
  List<String>? nonFieldErrors;
  List<String>? loginErrors;
  List<String>? excuseErrors;

  ErrorResponse({
    this.nonFieldErrors,
    this.loginErrors,
    this.excuseErrors,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    nonFieldErrors = json['non_field_errors'].cast<String>();
    nonFieldErrors = json['login'].cast<String>();
    excuseErrors = json['excuse'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['non_field_errors'] = nonFieldErrors;
    data['login'] = loginErrors;
    data['excuse'] = excuseErrors;
    return data;
  }
}
