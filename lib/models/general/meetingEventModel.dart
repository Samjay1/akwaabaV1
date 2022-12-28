import 'package:akwaaba/Networks/api_responses/coordinates_response.dart';

class MeetingEventModel {
  int? id;
  int? type;
  int? memberType;
  String? name;
  int? clientId;
  int? branchId;
  int? memberCategoryId;
  int? meetingSpan;
  String? startTime;
  String? closeTime;
  String? latenessTime;
  bool? isRecuring;
  bool? hasBreakTime;
  bool? hasDuty;
  bool? hasOvertime;
  String? virtualMeetingLink;
  int? virtualMeetingType;
  int? meetingLocation;
  int? expectedMonthlyAttendance;
  int? activeMonthlyAttendance;
  String? agenda;
  String? agendaFile;
  int? updatedBy;
  String? updateDate;
  String? date;

  MeetingEventModel(
      {this.id,
      this.type,
      this.memberType,
      this.name,
      this.clientId,
      this.branchId,
      this.memberCategoryId,
      this.meetingSpan,
      this.startTime,
      this.closeTime,
      this.latenessTime,
      this.isRecuring,
      this.hasBreakTime,
      this.hasDuty,
      this.hasOvertime,
      this.virtualMeetingLink,
      this.virtualMeetingType,
      this.meetingLocation,
      this.expectedMonthlyAttendance,
      this.activeMonthlyAttendance,
      this.agenda,
      this.agendaFile,
      this.updatedBy,
      this.updateDate,
      this.date});

  MeetingEventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    memberType = json['memberType'];
    name = json['name'];
    // clientId =
    //     json['clientId'] != null ? ClientId.fromJson(json['clientId']) : null;
    // branchId =
    //     json['branchId'] != null ? BranchId.fromJson(json['branchId']) : null;
    // memberCategoryId = json['memberCategoryId'] != null
    //     ? MemberCategoryId.fromJson(json['memberCategoryId'])
    //     : null;
    clientId = json['clientId'];
    branchId = json['branchId'];
    memberCategoryId = json['memberCategoryId'];
    meetingSpan = json['meetingSpan'];
    startTime = json['startTime'];
    closeTime = json['closeTime'];
    latenessTime = json['latenessTime'];
    isRecuring = json['isRecuring'];
    hasBreakTime = json['hasBreakTime'];
    hasDuty = json['hasDuty'];
    hasOvertime = json['hasOvertime'];
    virtualMeetingLink = json['virtualMeetingLink'];
    virtualMeetingType = json['virtualMeetingType'];
    meetingLocation = json['meetingLocation'];
    expectedMonthlyAttendance = json['expectedMonthlyAttendance'];
    activeMonthlyAttendance = json['activeMonthlyAttendance'];
    agenda = json['agenda'];
    agendaFile = json['agendaFile'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['memberType'] = memberType;
    data['name'] = name;
    data['clientId'] = clientId!;
    data['branchId'] = branchId!;
    data['memberCategoryId'] = memberCategoryId!;
    data['meetingSpan'] = meetingSpan;
    data['startTime'] = startTime;
    data['closeTime'] = closeTime;
    data['latenessTime'] = latenessTime;
    data['isRecuring'] = isRecuring;
    data['hasBreakTime'] = hasBreakTime;
    data['hasDuty'] = hasDuty;
    data['hasOvertime'] = hasOvertime;
    data['virtualMeetingLink'] = virtualMeetingLink;
    data['virtualMeetingType'] = virtualMeetingType;
    data['meetingLocation'] = meetingLocation;
    data['expectedMonthlyAttendance'] = expectedMonthlyAttendance;
    data['activeMonthlyAttendance'] = activeMonthlyAttendance;
    data['agenda'] = agenda;
    data['agendaFile'] = agendaFile;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }
}
