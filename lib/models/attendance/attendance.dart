//import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
//import 'package:akwaaba/Networks/api_responses/meeting_attendance_response.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';

import '../general/meetingEventModel.dart';

//import '../../Networks/api_responses/meeting_attendance_response.dart';

class Attendance {
  int? id;
  //MeetingEventId? meetingEventId;
  MeetingEventModel? meetingEventId;
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
  ClockedByInfo? validatedByInfo;
  int? clockingMethod;
  dynamic validate;
  dynamic validationDate;
  int? validatedBy;
  String? date;
  String? clockingMethodName;
  String? message;
  String? identification;

  Attendance({
    this.id,
    this.meetingEventId,
    this.memberId,
    this.accountType,
    this.inOrOut,
    this.justification,
    this.inTime,
    this.outTime,
    this.startBreak,
    this.endBreak,
    this.clockedBy,
    this.clockedByInfo,
    this.validatedByInfo,
    this.clockingMethod,
    this.validate,
    this.validationDate,
    this.validatedBy,
    this.date,
    this.clockingMethodName,
    this.message,
    this.identification,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'] != null
        ? MeetingEventModel.fromJson(json['meetingEventId'])
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
    validatedByInfo = json['validatedByInfo'] != null
        ? ClockedByInfo.fromJson(json['validatedByInfo'])
        : null;
    clockingMethod = json['clockingMethod'];
    validate =
        json['validate']; //!= null ? dynamic.fromJson(json['validate']) : null;
    validationDate = json['validationDate'];
    validatedBy = json['validatedBy'];
    date = json['date'];
    clockingMethodName = json['clockingMethodName'];
    message = json['SUCCESS_RESPONSE_MESSAGE'];
    identification = json['identification'];
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
    if (clockedByInfo != null) {
      data['clockedByInfo'] = clockedByInfo!.toJson();
    }
    if (validatedByInfo != null) {
      data['validatedByInfo'] = validatedByInfo!.toJson();
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
    data['identification'] = identification;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['surname'] = surname;
    data['gender'] = gender;
    data['profilePicture'] = profilePicture;
    data['dateOfBirth'] = dateOfBirth;
    data['phone'] = phone;
    data['email'] = email;
    data['role'] = role;
    data['accountId'] = accountId;
    data['branchId'] = branchId;
    data['level'] = level;
    data['status'] = status;
    data['lastUpdatedBy'] = lastUpdatedBy;
    data['date'] = date;
    data['last_login'] = lastLogin;
    return data;
  }
}
