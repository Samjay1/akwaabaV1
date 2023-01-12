import 'package:akwaaba/models/general/user.dart';

class MemberProfile {
  String? expiry;
  String? token;
  User? user;
  List<dynamic>? nonFieldErrors;

  MemberProfile({
    required this.expiry,
    this.token,
    this.user,
    this.nonFieldErrors,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      expiry: json['expiry'],
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      nonFieldErrors: json['non_field_errors'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiry'] = expiry;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
