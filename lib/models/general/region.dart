class Region {
  int? id;
  String? location;

  Region(this.id, this.location);

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(json['id'], json['location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;

    return data;
  }
}
