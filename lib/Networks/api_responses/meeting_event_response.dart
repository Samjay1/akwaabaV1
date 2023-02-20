import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/models/general/organization.dart';

class MeetingEventResponse {
  int? count;
  String? next;
  String? previous;
  List<MeetingEventModel>? results;

  MeetingEventResponse({this.count, this.next, this.previous, this.results});

  MeetingEventResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <MeetingEventModel>[];
      json['results'].forEach((v) {
        results!.add(MeetingEventModel.fromJson(v));
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
