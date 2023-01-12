class MemberType {
  int? id;
  String? category;

  MemberType(
      this.id,
      this.category);

  factory MemberType.fromJson(Map<String, dynamic> json) {
    return MemberType(
        json['id'],
        json['category']
    );
  }

}