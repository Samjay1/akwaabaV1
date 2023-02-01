import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/client_account_info.dart';
import 'package:akwaaba/models/general/leave_status.dart';

class AbsentLeave {
  int? id;
  int? clientId;
  ClientAccountInfo? clientInfo;
  int? memberId;
  Member? member;
  LeaveStatus? statusId;
  int? createdBy;
  dynamic createdByInfo;
  int? updatedBy;
  dynamic updatedByInfo;
  State? state;
  State? term;
  String? fromDate;
  String? toDate;
  String? reason;
  int? totalDays;
  int? totalDaysLeft;
  //MemberAdditionalInfo? memberAdditionalInfo;
  String? date;
  String? updateDate;

  AbsentLeave(
      {this.id,
      this.clientId,
      this.clientInfo,
      this.memberId,
      this.member,
      this.statusId,
      this.createdBy,
      this.createdByInfo,
      this.updatedBy,
      this.updatedByInfo,
      this.state,
      this.term,
      this.fromDate,
      this.toDate,
      this.reason,
      this.totalDays,
      this.totalDaysLeft,
      // this.memberAdditionalInfo,
      this.date,
      this.updateDate});

  AbsentLeave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    clientInfo = json['clientInfo'] != null
        ? ClientAccountInfo.fromJson(json['clientInfo'])
        : null;
    memberId = json['memberId'];
    member =
        json['memberInfo'] != null ? Member.fromJson(json['memberInfo']) : null;
    statusId = json['statusId'] != null
        ? LeaveStatus.fromJson(json['statusId'])
        : null;
    createdBy = json['createdBy'];
    createdByInfo = json['createdByInfo'];
    updatedBy = json['updatedBy'];
    updatedByInfo = json['updatedByInfo'];
    state = json['state'] != null ? State.fromJson(json['state']) : null;
    term = json['term'] != null ? State.fromJson(json['term']) : null;
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    reason = json['reason'];
    totalDays = json['totalDays'];
    totalDaysLeft = json['totalDaysLeft'];
    // memberAdditionalInfo = json['memberAdditionalInfo'] != null
    //     ? MemberAdditionalInfo.fromJson(json['memberAdditionalInfo'])
    //     : null;
    date = json['date'];
    updateDate = json['updateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    if (clientInfo != null) {
      data['clientInfo'] = clientInfo!.toJson();
    }
    data['memberId'] = memberId;
    if (member != null) {
      data['memberInfo'] = member!.toJson();
    }
    if (statusId != null) {
      data['statusId'] = statusId!.toJson();
    }
    data['createdBy'] = createdBy;
    data['createdByInfo'] = createdByInfo;
    data['updatedBy'] = updatedBy;
    data['updatedByInfo'] = updatedByInfo;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (term != null) {
      data['term'] = term!.toJson();
    }
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['reason'] = reason;
    data['totalDays'] = totalDays;
    data['totalDaysLeft'] = totalDaysLeft;
    // if (memberAdditionalInfo != null) {
    //   data['memberAdditionalInfo'] = memberAdditionalInfo!.toJson();
    // }
    data['date'] = date;
    data['updateDate'] = updateDate;
    return data;
  }
}

class State {
  int? id;
  String? name;

  State({this.id, this.name});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
