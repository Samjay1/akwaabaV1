class Occupation {
  int? id;
  String? name;
  String? memberId;

  Occupation({
    this.id,
    this.name,
    this.memberId,
  });

  Occupation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['memberId'] = memberId;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Occupation && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
