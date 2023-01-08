class Branch {
  int? id;
  String? name;
  int? accountId;
  int? createdBy;
  String? creationDate;
  int? updatedBy;
  String? updateDate;

  Branch(
      {this.id,
      this.name,
      this.accountId,
      this.createdBy,
      this.creationDate,
      this.updatedBy,
      this.updateDate});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountId = json['accountId'];
    createdBy = json['createdBy'];
    creationDate = json['creationDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['accountId'] = accountId;
    data['createdBy'] = createdBy;
    data['creationDate'] = creationDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Branch && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
