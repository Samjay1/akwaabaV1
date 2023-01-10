class MemberType {
  String? id;
  String? type;

  MemberType(
      this.id,
      this.type);

  factory MemberType.fromJson(Map<String, dynamic> json) {
    return MemberType(
        json['id'],
        json['type']
    );
  }

}