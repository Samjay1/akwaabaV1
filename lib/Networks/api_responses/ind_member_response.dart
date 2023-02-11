import 'package:akwaaba/models/admin/clocked_member.dart';

class IndMemberResponse {
  int? count;
  String? next;
  String? previous;
  List<Member>? results;

  IndMemberResponse({this.count, this.next, this.previous, this.results});

  IndMemberResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Member>[];
      json['results'].forEach((v) {
        results!.add(Member.fromJson(v));
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
