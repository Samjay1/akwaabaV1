//import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
//import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';

//import '../../Networks/api_responses/meeting_attendance_response.dart';

class Attendance {
  int? id;
  MeetingEventId? meetingEventId;
  //MemberId? memberId;
  Member? memberId;
  int? accountType;
  bool? inOrOut;
  String? inTime;
  String? outTime;
  String? startBreak;
  String? endBreak;
  int? clockedBy;
  int? clockingMethod;
  dynamic validate;
  dynamic validationDate;
  int? validatedBy;
  String? date;
  String? clockingMethodName;

  Attendance(
      {this.id,
      this.meetingEventId,
      this.memberId,
      this.accountType,
      this.inOrOut,
      this.inTime,
      this.outTime,
      this.startBreak,
      this.endBreak,
      this.clockedBy,
      this.clockingMethod,
      this.validate,
      this.validationDate,
      this.validatedBy,
      this.date,
      this.clockingMethodName});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'] != null
        ? MeetingEventId.fromJson(json['meetingEventId'])
        : null;
    memberId =
        json['memberId'] != null ? Member.fromJson(json['memberId']) : null;
    accountType = json['accountType'];
    inOrOut = json['inOrOut'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
    clockedBy = json['clockedBy'];
    clockingMethod = json['clockingMethod'];
    validate =
        json['validate']; //!= null ? dynamic.fromJson(json['validate']) : null;
    validationDate = json['validationDate'];
    validatedBy = json['validatedBy'];
    date = json['date'];
    clockingMethodName = json['clockingMethodName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (meetingEventId != null) {
      data['meetingEventId'] = meetingEventId!.toJson();
    }
    if (memberId != null) {
      data['memberId'] = memberId!.toJson();
    }
    data['accountType'] = accountType;
    data['inOrOut'] = inOrOut;
    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['startBreak'] = startBreak;
    data['endBreak'] = endBreak;
    data['clockedBy'] = clockedBy;
    data['clockingMethod'] = clockingMethod;
    if (validate != null) {
      data['validate'] = validate!.toJson();
    }
    data['validationDate'] = validationDate;
    data['validatedBy'] = validatedBy;
    data['date'] = date;
    data['clockingMethodName'] = clockingMethodName;
    return data;
  }
}
