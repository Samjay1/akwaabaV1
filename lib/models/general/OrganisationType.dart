class OrganisationType {
  int? id;
  String? type;

  OrganisationType(
      this.id,
      this.type);

  factory OrganisationType.fromJson(Map<String, dynamic> json) {
    return OrganisationType(
        json['id'],
        json['type']
    );
  }
}