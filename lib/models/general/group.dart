class Group {
  int? id;
  int? clientId;
  String? group;
  int? branchId;
  int? memberCategoryId;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  Group(
      {this.id,
      this.clientId,
      this.group,
      this.branchId,
      this.memberCategoryId,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    group = json['group'];
    branchId = json['branchId'];
    memberCategoryId = json['memberCategoryId'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['group'] = group;
    data['branchId'] = branchId;
    data['memberCategoryId'] = memberCategoryId;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is Group && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
