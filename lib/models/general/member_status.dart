class MemberStatus {
  int? id;
  String? name;
  int? memberId;

  MemberStatus({
    this.id,
    this.name,
    this.memberId,
  });

  MemberStatus.fromJson(Map<String, dynamic> json) {
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
      other != null && other is MemberStatus && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
