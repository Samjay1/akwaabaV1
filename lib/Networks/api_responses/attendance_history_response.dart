// import 'package:akwaaba/models/admin/clocked_member.dart';

// class AttendanceHistoryResponse {
//   int? count;
//   String? next;
//   String? previous;
//   List<AttendanceHistory>? results;

//   AttendanceHistoryResponse({
//     this.count,
//     this.next,
//     this.previous,
//     this.results,
//   });

//   AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     next = json['next'];
//     previous = json['previous'];

//     if (json['data'] != null) {
//       results = <AttendanceHistory>[];
//       json['results'].forEach((v) {
//         results!.add(AttendanceHistory.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['count'] = count;
//     data['next'] = next;
//     data['previous'] = previous;
//     if (results != null) {
//       data['results'] = results!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class AttendanceHistory {
//   AttendanceRecord? attendanceRecord;
//   Validate? status;
//   String? onTime;
//   String? lateness;
//   String? overtime;
//   String? undertime;
//   String? breakOverstay;
//   String? totalAttendance;

//   AttendanceHistory(
//       {this.attendanceRecord,
//       this.status,
//       this.onTime,
//       this.lateness,
//       this.overtime,
//       this.undertime,
//       this.breakOverstay,
//       this.totalAttendance});

//   AttendanceHistory.fromJson(Map<String, dynamic> json) {
//     attendanceRecord = json['history'] != null
//         ? AttendanceRecord.fromJson(json['history'])
//         : null;
//     status = json['status'] != null ? Validate.fromJson(json['status']) : null;
//     onTime = json['onTime'];
//     lateness = json['lateness'];
//     overtime = json['overtime'];
//     undertime = json['undertime'];
//     breakOverstay = json['breakOverstay'];
//     totalAttendance = json['totalAttendance'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (attendanceRecord != null) {
//       data['history'] = attendanceRecord!.toJson();
//     }
//     if (status != null) {
//       data['status'] = status!.toJson();
//     }
//     data['onTime'] = onTime;
//     data['lateness'] = lateness;
//     data['overtime'] = overtime;
//     data['undertime'] = undertime;
//     data['breakOverstay'] = breakOverstay;
//     data['totalAttendance'] = totalAttendance;
//     return data;
//   }
// }

// class AttendanceRecord {
//   Member? member;
//   List<Meetings>? meetings;

//   AttendanceRecord({this.member, this.meetings});

//   AttendanceRecord.fromJson(Map<String, dynamic> json) {
//     member = json['member'] != null ? Member.fromJson(json['member']) : null;
//     if (json['meetings'] != null) {
//       meetings = <Meetings>[];
//       json['meetings'].forEach((v) {
//         meetings!.add(Meetings.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (member != null) {
//       data['member'] = member!.toJson();
//     }
//     if (meetings != null) {
//       data['meetings'] = meetings!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Meetings {
//   Meeting? meeting;
//   List<History>? history;
//   Validate? status;
//   String? onTime;
//   String? lateness;
//   String? overtime;
//   String? undertime;
//   String? breakOverstay;
//   String? totalAttendance;

//   Meetings(
//       {this.meeting,
//       this.history,
//       this.status,
//       this.onTime,
//       this.lateness,
//       this.overtime,
//       this.undertime,
//       this.breakOverstay,
//       this.totalAttendance});

//   Meetings.fromJson(Map<String, dynamic> json) {
//     meeting =
//         json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null;
//     if (json['history'] != null) {
//       history = <History>[];
//       json['history'].forEach((v) {
//         history!.add(History.fromJson(v));
//       });
//     }
//     status = json['status'] != null ? Validate.fromJson(json['status']) : null;
//     onTime = json['onTime'];
//     lateness = json['lateness'];
//     overtime = json['overtime'];
//     undertime = json['undertime'];
//     breakOverstay = json['breakOverstay'];
//     totalAttendance = json['totalAttendance'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (meeting != null) {
//       data['meeting'] = meeting!.toJson();
//     }
//     if (history != null) {
//       data['history'] = history!.map((v) => v.toJson()).toList();
//     }
//     if (status != null) {
//       data['status'] = status!.toJson();
//     }
//     data['onTime'] = onTime;
//     data['lateness'] = lateness;
//     data['overtime'] = overtime;
//     data['undertime'] = undertime;
//     data['breakOverstay'] = breakOverstay;
//     data['totalAttendance'] = totalAttendance;
//     return data;
//   }
// }

// class Meeting {
//   int? id;
//   int? type;
//   int? memberType;
//   String? name;
//   int? clientId;
//   int? branchId;
//   int? memberCategoryId;
//   int? meetingSpan;
//   String? startTime;
//   String? closeTime;
//   String? latenessTime;
//   bool? isRecuring;
//   bool? hasBreakTime;
//   bool? hasDuty;
//   bool? hasOvertime;
//   String? virtualMeetingLink;
//   int? virtualMeetingType;
//   int? meetingLocation;
//   int? expectedMonthlyAttendance;
//   int? activeMonthlyAttendance;
//   String? agenda;
//   String? agendaFile;
//   int? updatedBy;
//   String? updateDate;
//   String? date;

//   Meeting(
//       {this.id,
//       this.type,
//       this.memberType,
//       this.name,
//       this.clientId,
//       this.branchId,
//       this.memberCategoryId,
//       this.meetingSpan,
//       this.startTime,
//       this.closeTime,
//       this.latenessTime,
//       this.isRecuring,
//       this.hasBreakTime,
//       this.hasDuty,
//       this.hasOvertime,
//       this.virtualMeetingLink,
//       this.virtualMeetingType,
//       this.meetingLocation,
//       this.expectedMonthlyAttendance,
//       this.activeMonthlyAttendance,
//       this.agenda,
//       this.agendaFile,
//       this.updatedBy,
//       this.updateDate,
//       this.date});

//   Meeting.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     type = json['type'];
//     memberType = json['memberType'];
//     name = json['name'];
//     clientId = json['clientId'];
//     branchId = json['branchId'];
//     memberCategoryId = json['memberCategoryId'];
//     meetingSpan = json['meetingSpan'];
//     startTime = json['startTime'];
//     closeTime = json['closeTime'];
//     latenessTime = json['latenessTime'];
//     isRecuring = json['isRecuring'];
//     hasBreakTime = json['hasBreakTime'];
//     hasDuty = json['hasDuty'];
//     hasOvertime = json['hasOvertime'];
//     virtualMeetingLink = json['virtualMeetingLink'];
//     virtualMeetingType = json['virtualMeetingType'];
//     meetingLocation = json['meetingLocation'];
//     expectedMonthlyAttendance = json['expectedMonthlyAttendance'];
//     activeMonthlyAttendance = json['activeMonthlyAttendance'];
//     agenda = json['agenda'];
//     agendaFile = json['agendaFile'];
//     updatedBy = json['updatedBy'];
//     updateDate = json['updateDate'];
//     date = json['date'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['type'] = type;
//     data['memberType'] = memberType;
//     data['name'] = name;
//     data['clientId'] = clientId;
//     data['branchId'] = branchId;
//     data['memberCategoryId'] = memberCategoryId;
//     data['meetingSpan'] = meetingSpan;
//     data['startTime'] = startTime;
//     data['closeTime'] = closeTime;
//     data['latenessTime'] = latenessTime;
//     data['isRecuring'] = isRecuring;
//     data['hasBreakTime'] = hasBreakTime;
//     data['hasDuty'] = hasDuty;
//     data['hasOvertime'] = hasOvertime;
//     data['virtualMeetingLink'] = virtualMeetingLink;
//     data['virtualMeetingType'] = virtualMeetingType;
//     data['meetingLocation'] = meetingLocation;
//     data['expectedMonthlyAttendance'] = expectedMonthlyAttendance;
//     data['activeMonthlyAttendance'] = activeMonthlyAttendance;
//     data['agenda'] = agenda;
//     data['agendaFile'] = agendaFile;
//     data['updatedBy'] = updatedBy;
//     data['updateDate'] = updateDate;
//     data['date'] = date;
//     return data;
//   }
// }

// class History {
//   int? id;
//   int? meetingEventId;
//   int? memberId;
//   int? accountType;
//   bool? inOrOut;
//   String? inTime;
//   String? outTime;
//   String? startBreak;
//   String? endBreak;
//   int? clockedBy;
//   int? clockingMethod;
//   Validate? validate;
//   String? validationDate;
//   int? validatedBy;
//   String? date;
//   String? clockingMethodName;

//   History(
//       {this.id,
//       this.meetingEventId,
//       this.memberId,
//       this.accountType,
//       this.inOrOut,
//       this.inTime,
//       this.outTime,
//       this.startBreak,
//       this.endBreak,
//       this.clockedBy,
//       this.clockingMethod,
//       this.validate,
//       this.validationDate,
//       this.validatedBy,
//       this.date,
//       this.clockingMethodName});

//   History.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     meetingEventId = json['meetingEventId'];
//     memberId = json['memberId'];
//     accountType = json['accountType'];
//     inOrOut = json['inOrOut'];
//     inTime = json['inTime'];
//     outTime = json['outTime'];
//     startBreak = json['startBreak'];
//     endBreak = json['endBreak'];
//     clockedBy = json['clockedBy'];
//     clockingMethod = json['clockingMethod'];
//     validate =
//         json['validate'] != null ? Validate.fromJson(json['validate']) : null;
//     validationDate = json['validationDate'];
//     validatedBy = json['validatedBy'];
//     date = json['date'];
//     clockingMethodName = json['clockingMethodName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['meetingEventId'] = meetingEventId;
//     data['memberId'] = memberId;
//     data['accountType'] = accountType;
//     data['inOrOut'] = inOrOut;
//     data['inTime'] = inTime;
//     data['outTime'] = outTime;
//     data['startBreak'] = startBreak;
//     data['endBreak'] = endBreak;
//     data['clockedBy'] = clockedBy;
//     data['clockingMethod'] = clockingMethod;
//     if (validate != null) {
//       data['validate'] = validate!.toJson();
//     }
//     data['validationDate'] = validationDate;
//     data['validatedBy'] = validatedBy;
//     data['date'] = date;
//     data['clockingMethodName'] = clockingMethodName;
//     return data;
//   }
// }

// class Validate {
//   int? id;
//   String? name;

//   Validate({this.id, this.name});

//   Validate.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     return data;
//   }
// }

class AttendanceHistoryResponse {
  int? count;
  String? next;
  String? previous;
  List<AttendanceHistory>? results;

  AttendanceHistoryResponse(
      {this.count, this.next, this.previous, this.results});

  AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <AttendanceHistory>[];
      json['results'].forEach((v) {
        results!.add(AttendanceHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceHistory {
  AttendanceRecord? attendanceRecord;
  Validate? status;
  String? onTime;
  String? lateness;
  String? overtime;
  String? undertime;
  String? breakOverstay;
  String? productiveHours;
  String? totalAttendance;

  AttendanceHistory({
    this.attendanceRecord,
    this.status,
    this.onTime,
    this.lateness,
    this.overtime,
    this.undertime,
    this.breakOverstay,
    this.productiveHours,
    this.totalAttendance,
  });

  AttendanceHistory.fromJson(Map<String, dynamic> json) {
    attendanceRecord = json['history'] != null
        ? AttendanceRecord.fromJson(json['history'])
        : null;
    status = json['status'] != null ? Validate.fromJson(json['status']) : null;
    onTime = json['onTime'];
    lateness = json['lateness'];
    overtime = json['overtime'];
    undertime = json['undertime'];
    breakOverstay = json['breakOverstay'];
    productiveHours = json['productiveHours'];
    totalAttendance = json['totalAttendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attendanceRecord != null) {
      data['history'] = attendanceRecord!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['onTime'] = onTime;
    data['lateness'] = lateness;
    data['overtime'] = overtime;
    data['undertime'] = undertime;
    data['breakOverstay'] = breakOverstay;
    data['productiveHours'] = productiveHours;
    data['totalAttendance'] = totalAttendance;
    return data;
  }
}

class AttendanceRecord {
  Member? member;
  List<Meetings>? meetings;

  AttendanceRecord({this.member, this.meetings});

  AttendanceRecord.fromJson(Map<String, dynamic> json) {
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    if (json['meetings'] != null) {
      meetings = <Meetings>[];
      json['meetings'].forEach((v) {
        meetings!.add(Meetings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (meetings != null) {
      data['meetings'] = meetings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Member {
  int? id;
  int? clientId;
  String? firstname;
  String? middlename;
  String? surname;
  int? gender;
  String? profilePicture;
  String? phone;
  String? email;
  String? dateOfBirth;
  int? religion;
  String? nationality;
  String? countryOfResidence;
  String? stateProvince;
  int? region;
  int? district;
  int? constituency;
  int? electoralArea;
  String? community;
  String? hometown;
  String? houseNoDigitalAddress;
  String? digitalAddress;
  int? level;
  int? status;
  int? accountType;
  int? memberType;
  String? date;
  String? lastLogin;
  String? referenceId;
  int? branchId;
  bool? editable;
  String? profileResume;
  String? profileIdentification;
  bool? archived;
  BranchInfo? branchInfo;
  CategoryInfo? categoryInfo;

  Member(
      {this.id,
      this.clientId,
      this.firstname,
      this.middlename,
      this.surname,
      this.gender,
      this.profilePicture,
      this.phone,
      this.email,
      this.dateOfBirth,
      this.religion,
      this.nationality,
      this.countryOfResidence,
      this.stateProvince,
      this.region,
      this.district,
      this.constituency,
      this.electoralArea,
      this.community,
      this.hometown,
      this.houseNoDigitalAddress,
      this.digitalAddress,
      this.level,
      this.status,
      this.accountType,
      this.memberType,
      this.date,
      this.lastLogin,
      this.referenceId,
      this.branchId,
      this.editable,
      this.profileResume,
      this.profileIdentification,
      this.archived,
      this.branchInfo,
      this.categoryInfo});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    surname = json['surname'];
    gender = json['gender'];
    profilePicture = json['profilePicture'];
    phone = json['phone'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    religion = json['religion'];
    nationality = json['nationality'];
    countryOfResidence = json['countryOfResidence'];
    stateProvince = json['stateProvince'];
    region = json['region'];
    district = json['district'];
    constituency = json['constituency'];
    electoralArea = json['electoralArea'];
    community = json['community'];
    hometown = json['hometown'];
    houseNoDigitalAddress = json['houseNoDigitalAddress'];
    digitalAddress = json['digitalAddress'];
    level = json['level'];
    status = json['status'];
    accountType = json['accountType'];
    memberType = json['memberType'];
    date = json['date'];
    lastLogin = json['last_login'];
    referenceId = json['referenceId'];
    branchId = json['branchId'];
    editable = json['editable'];
    profileResume = json['profileResume'];
    profileIdentification = json['profileIdentification'];
    archived = json['archived'];
    branchInfo = json['branchInfo'] != null
        ? BranchInfo.fromJson(json['branchInfo'])
        : null;
    categoryInfo = json['categoryInfo'] != null
        ? CategoryInfo.fromJson(json['categoryInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['firstname'] = firstname;
    data['middlename'] = middlename;
    data['surname'] = surname;
    data['gender'] = gender;
    data['profilePicture'] = profilePicture;
    data['phone'] = phone;
    data['email'] = email;
    data['dateOfBirth'] = dateOfBirth;
    data['religion'] = religion;
    data['nationality'] = nationality;
    data['countryOfResidence'] = countryOfResidence;
    data['stateProvince'] = stateProvince;
    data['region'] = region;
    data['district'] = district;
    data['constituency'] = constituency;
    data['electoralArea'] = electoralArea;
    data['community'] = community;
    data['hometown'] = hometown;
    data['houseNoDigitalAddress'] = houseNoDigitalAddress;
    data['digitalAddress'] = digitalAddress;
    data['level'] = level;
    data['status'] = status;
    data['accountType'] = accountType;
    data['memberType'] = memberType;
    data['date'] = date;
    data['last_login'] = lastLogin;
    data['referenceId'] = referenceId;
    data['branchId'] = branchId;
    data['editable'] = editable;
    data['profileResume'] = profileResume;
    data['profileIdentification'] = profileIdentification;
    data['archived'] = archived;
    if (branchInfo != null) {
      data['branchInfo'] = branchInfo!.toJson();
    }
    if (categoryInfo != null) {
      data['categoryInfo'] = categoryInfo!.toJson();
    }
    return data;
  }
}

class BranchInfo {
  int? id;
  String? name;
  int? accountId;
  int? createdBy;
  String? creationDate;
  int? updatedBy;
  String? updateDate;

  BranchInfo(
      {this.id,
      this.name,
      this.accountId,
      this.createdBy,
      this.creationDate,
      this.updatedBy,
      this.updateDate});

  BranchInfo.fromJson(Map<String, dynamic> json) {
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
}

class CategoryInfo {
  int? id;
  int? clientId;
  String? category;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  CategoryInfo(
      {this.id,
      this.clientId,
      this.category,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
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

class Meetings {
  Meeting? meeting;
  List<History>? history;
  Validate? status;
  String? onTime;
  String? lateness;
  String? overtime;
  String? undertime;
  String? breakOverstay;
  String? totalAttendance;

  Meetings(
      {this.meeting,
      this.history,
      this.status,
      this.onTime,
      this.lateness,
      this.overtime,
      this.undertime,
      this.breakOverstay,
      this.totalAttendance});

  Meetings.fromJson(Map<String, dynamic> json) {
    meeting =
        json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null;
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    status = json['status'] != null ? Validate.fromJson(json['status']) : null;
    onTime = json['onTime'];
    lateness = json['lateness'];
    overtime = json['overtime'];
    undertime = json['undertime'];
    breakOverstay = json['breakOverstay'];
    totalAttendance = json['totalAttendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meeting != null) {
      data['meeting'] = meeting!.toJson();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['onTime'] = onTime;
    data['lateness'] = lateness;
    data['overtime'] = overtime;
    data['undertime'] = undertime;
    data['breakOverstay'] = breakOverstay;
    data['totalAttendance'] = totalAttendance;
    return data;
  }
}

class Meeting {
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

  Meeting(
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

  Meeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    memberType = json['memberType'];
    name = json['name'];
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
    data['clientId'] = clientId;
    data['branchId'] = branchId;
    data['memberCategoryId'] = memberCategoryId;
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

class History {
  int? id;
  int? meetingEventId;
  int? memberId;
  int? accountType;
  bool? inOrOut;
  String? inTime;
  String? outTime;
  String? startBreak;
  String? endBreak;
  int? clockedBy;
  int? clockingMethod;
  Validate? validate;
  String? validationDate;
  int? validatedBy;
  String? date;
  String? clockingMethodName;

  History(
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

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    memberId = json['memberId'];
    accountType = json['accountType'];
    inOrOut = json['inOrOut'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
    clockedBy = json['clockedBy'];
    clockingMethod = json['clockingMethod'];
    validate =
        json['validate'] != null ? Validate.fromJson(json['validate']) : null;
    validationDate = json['validationDate'];
    validatedBy = json['validatedBy'];
    date = json['date'];
    clockingMethodName = json['clockingMethodName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['meetingEventId'] = this.meetingEventId;
    data['memberId'] = this.memberId;
    data['accountType'] = this.accountType;
    data['inOrOut'] = this.inOrOut;
    data['inTime'] = this.inTime;
    data['outTime'] = this.outTime;
    data['startBreak'] = this.startBreak;
    data['endBreak'] = this.endBreak;
    data['clockedBy'] = this.clockedBy;
    data['clockingMethod'] = this.clockingMethod;
    if (this.validate != null) {
      data['validate'] = this.validate!.toJson();
    }
    data['validationDate'] = this.validationDate;
    data['validatedBy'] = this.validatedBy;
    data['date'] = this.date;
    data['clockingMethodName'] = this.clockingMethodName;
    return data;
  }
}

class Validate {
  int? id;
  String? name;

  Validate({this.id, this.name});

  Validate.fromJson(Map<String, dynamic> json) {
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
