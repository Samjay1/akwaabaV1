import 'package:akwaaba/models/general/organization.dart';

class OrgMemberResponse {
  int? count;
  String? next;
  String? previous;
  List<Organization>? results;

  OrgMemberResponse({this.count, this.next, this.previous, this.results});

  OrgMemberResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Organization>[];
      json['results'].forEach((v) {
        results!.add(Organization.fromJson(v));
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
