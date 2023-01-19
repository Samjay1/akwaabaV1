import 'package:akwaaba/models/general/region.dart';

class District {
  int? id;
  Region? region;
  String? location;

  District(this.id, this.region, this.location);

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
        json['id'],
        json['regionId'] != null ? Region.fromJson(json['regionId']) : null,
        json['location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = location;
    if (region != null) {
      data['regionId'] = region!.toJson();
    }
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is District && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
