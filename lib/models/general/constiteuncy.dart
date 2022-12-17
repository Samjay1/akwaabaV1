class Constituency {
  String? id;
  String? location;

  Constituency(
      this.id,
      this.location);

  factory Constituency.fromJson(Map<String, dynamic> json) {
    return Constituency(
        json['id'],
        json['location']
    );
  }

}