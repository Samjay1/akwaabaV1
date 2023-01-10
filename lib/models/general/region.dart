class Region {
  int? id;
  String? location;

  Region(
      this.id,
      this.location);

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
        json['id'],
        json['location']
    );
  }

}
