import 'package:akwaaba/models/general/group.dart';

class SubGroup {
  int? id;
  int? clientId;
  Group? groupId;
  int? branchId;
  int? memberCategoryId;
  String? subgroup;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  SubGroup(
      {this.id,
      this.clientId,
      this.groupId,
      this.branchId,
      this.memberCategoryId,
      this.subgroup,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  SubGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    groupId = json['groupId'] != null ? Group.fromJson(json['groupId']) : null;
    branchId = json['branchId'];
    memberCategoryId = json['memberCategoryId'];
    subgroup = json['subgroup'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    if (groupId != null) {
      data['groupId'] = groupId!.toJson();
    }
    data['branchId'] = branchId;
    data['memberCategoryId'] = memberCategoryId;
    data['subgroup'] = subgroup;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is SubGroup && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
