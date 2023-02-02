import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/region.dart';

class Constituency {
  int? id;
  String? location;
  Region? regionId;
  District? districtId;

  Constituency(
    this.id,
    this.location,
    this.regionId,
    this.districtId,
  );

  factory Constituency.fromJson(Map<String, dynamic> json) {
    return Constituency(
      json['id'],
      json['location'],
      json['regionId'] != null ? Region.fromJson(json['regionId']) : null,
      json['districtId'] != null ? District.fromJson(json['districtId']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id!;
    data['location'] = location!;
    if (districtId != null) {
      data['districtId'] = districtId!.toJson();
    }
    if (regionId != null) {
      data['regionId'] = regionId!.toJson();
    }
    return data;
  }
}
