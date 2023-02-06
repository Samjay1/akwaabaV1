//import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
//import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';

//import '../../Networks/api_responses/meeting_attendance_response.dart';

class Attendance {
  int? id;
  MeetingEventId? meetingEventId;
  Member? memberId;
  int? accountType;
  bool? inOrOut;
  dynamic justification;
  String? inTime;
  String? outTime;
  String? startBreak;
  String? endBreak;
  int? clockedBy;

  ClockedByInfo? clockedByInfo;
  int? clockingMethod;
  dynamic validate;
  dynamic validationDate;
  int? validatedBy;
  String? date;
  String? clockingMethodName;
  String? message;

  Attendance({
    this.id,
    this.meetingEventId,
    this.memberId,
    this.accountType,
    this.inOrOut,
    this.inTime,
    this.outTime,
    this.startBreak,
    this.endBreak,
    this.clockedBy,
    this.clockedByInfo,
    this.clockingMethod,
    this.validate,
    this.validationDate,
    this.validatedBy,
    this.date,
    this.clockingMethodName,
    this.message,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'] != null
        ? MeetingEventId.fromJson(json['meetingEventId'])
        : null;
    memberId =
        json['memberId'] != null ? Member.fromJson(json['memberId']) : null;
    accountType = json['accountType'];
    inOrOut = json['inOrOut'];
    justification = json['justification'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
    clockedBy = json['clockedBy'];
    clockedByInfo = json['clockedByInfo'] != null
        ? ClockedByInfo.fromJson(json['clockedByInfo'])
        : null;
    clockingMethod = json['clockingMethod'];
    validate =
        json['validate']; //!= null ? dynamic.fromJson(json['validate']) : null;
    validationDate = json['validationDate'];
    validatedBy = json['validatedBy'];
    date = json['date'];
    clockingMethodName = json['clockingMethodName'];
    message = json['SUCCESS_RESPONSE_MESSAGE'];
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
    data['justification'] = justification;
    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['startBreak'] = startBreak;
    data['endBreak'] = endBreak;
    data['clockedBy'] = clockedBy;
    if (this.clockedByInfo != null) {
      data['clockedByInfo'] = this.clockedByInfo!.toJson();
    }
    data['clockingMethod'] = clockingMethod;
    if (validate != null) {
      data['validate'] = validate!.toJson();
    }
    data['validationDate'] = validationDate;
    data['validatedBy'] = validatedBy;
    data['date'] = date;
    data['clockingMethodName'] = clockingMethodName;
    data['SUCCESS_RESPONSE_MESSAGE'] = message;
    return data;
  }
}

class ClockedByInfo {
  int? id;
  String? firstname;
  String? surname;
  int? gender;
  String? profilePicture;
  String? dateOfBirth;
  String? phone;
  String? email;
  int? role;
  int? accountId;
  int? branchId;
  int? level;
  int? status;
  int? lastUpdatedBy;
  String? date;
  String? lastLogin;

  ClockedByInfo(
      {this.id,
      this.firstname,
      this.surname,
      this.gender,
      this.profilePicture,
      this.dateOfBirth,
      this.phone,
      this.email,
      this.role,
      this.accountId,
      this.branchId,
      this.level,
      this.status,
      this.lastUpdatedBy,
      this.date,
      this.lastLogin});

  ClockedByInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    surname = json['surname'];
    gender = json['gender'];
    profilePicture = json['profilePicture'];
    dateOfBirth = json['dateOfBirth'];
    phone = json['phone'];
    email = json['email'];
    role = json['role'];
    accountId = json['accountId'];
    branchId = json['branchId'];
    level = json['level'];
    status = json['status'];
    lastUpdatedBy = json['lastUpdatedBy'];
    date = json['date'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['surname'] = this.surname;
    data['gender'] = this.gender;
    data['profilePicture'] = this.profilePicture;
    data['dateOfBirth'] = this.dateOfBirth;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['role'] = this.role;
    data['accountId'] = this.accountId;
    data['branchId'] = this.branchId;
    data['level'] = this.level;
    data['status'] = this.status;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['date'] = this.date;
    data['last_login'] = this.lastLogin;
    return data;
  }
}
