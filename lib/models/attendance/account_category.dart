class AccountCategory {
  int? id;
  int? clientId;
  String? category;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  AccountCategory(
      {this.id,
      this.clientId,
      this.category,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  AccountCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    category = json['category'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['category'] = category;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }
}
