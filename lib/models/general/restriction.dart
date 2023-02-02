class Restriction {
  int? id;
  String? restriction;
  String? date;

  Restriction({this.id, this.restriction, this.date});

  Restriction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restriction = json['restriction'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restriction'] = restriction;
    data['date'] = date;
    return data;
  }
}
