class AccountType {
  int? id;
  String? name;

  AccountType({
    this.id,
    this.name,
  });

  AccountType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is AccountType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
