class ElectoralArea {
  int? id;
  String? location;

  ElectoralArea(
      this.id,
      this.location);

  factory ElectoralArea.fromJson(Map<String, dynamic> json) {
    return ElectoralArea(
        json['id'],
        json['location']
    );
  }

}