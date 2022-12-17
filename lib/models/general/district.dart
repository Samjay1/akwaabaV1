class District {
  String? id;
  String? location;

  District(
      this.id,
      this.location);

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
        json['id'],
        json['location']
    );
  }

}