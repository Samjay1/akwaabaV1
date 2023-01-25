class Country {
  int? id;
  String? name;
  String? short;
  String? code;

  Country(this.id, this.name, this.short, this.code);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json['id'], json['name'], json['short'], json['code']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short'] = short;
    data['code'] = code;

    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Country && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
