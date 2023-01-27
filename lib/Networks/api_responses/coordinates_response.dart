import 'package:akwaaba/models/general/meetingEventModel.dart';

import '../../models/attendance/account_category.dart';

class CoordinatesResponse {
  int? count;
  dynamic next;
  dynamic previous;
  List<Results>? results;

  CoordinatesResponse({this.count, this.next, this.previous, this.results});

  CoordinatesResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
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

class Results {
  int? id;
  MeetingEventModel? meetingEventId;
  String? latitude;
  String? longitude;
  double? radius;
  int? updatedBy;
  String? updateDate;
  String? date;

  Results(
      {this.id,
      this.meetingEventId,
      this.latitude,
      this.longitude,
      this.radius,
      this.updatedBy,
      this.updateDate,
      this.date});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'] != null
        ? MeetingEventModel.fromJson(json['meetingEventId'])
        : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (meetingEventId != null) {
      data['meetingEventId'] = meetingEventId!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }
}
