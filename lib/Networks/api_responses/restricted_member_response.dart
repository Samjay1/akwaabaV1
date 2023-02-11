import 'package:akwaaba/models/general/restricted_member.dart';

class RestrictedMemberResponse {
  int? count;
  String? next;
  String? previous;
  List<RestrictedMember>? results;

  RestrictedMemberResponse(
      {this.count, this.next, this.previous, this.results});

  RestrictedMemberResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <RestrictedMember>[];
      json['results'].forEach((v) {
        results!.add(RestrictedMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
