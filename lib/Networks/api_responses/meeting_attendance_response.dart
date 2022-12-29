import 'package:akwaaba/models/general/meetingEventModel.dart';

class MeetingAttendanceResponse {
  int? count;
  String? next;
  dynamic previous;
  List<Results>? results;

  MeetingAttendanceResponse(
      {this.count, this.next, this.previous, this.results});

  MeetingAttendanceResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
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

class Results {
  int? id;
  MeetingEventId? meetingEventId;
  MemberId? memberId;
  int? accountType;
  bool? inOrOut;
  dynamic inTime;
  dynamic outTime;
  dynamic startBreak;
  dynamic endBreak;
  int? clockedBy;
  int? clockingMethod;
  Validate? validate;
  dynamic validationDate;
  int? validatedBy;
  String? date;
  String? clockingMethodName;

  Results(
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

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'] != null
        ? MeetingEventId.fromJson(json['meetingEventId'])
        : null;
    memberId =
        json['memberId'] != null ? MemberId.fromJson(json['memberId']) : null;
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

class MeetingEventId {
  int? id;
  int? type;
  int? memberType;
  String? name;
  ClientId? clientId;
  BranchId? branchId;
  MemberCategoryId? memberCategoryId;
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

  MeetingEventId(
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

  MeetingEventId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    memberType = json['memberType'];
    name = json['name'];
    clientId =
        json['clientId'] != null ? ClientId.fromJson(json['clientId']) : null;
    branchId =
        json['branchId'] != null ? BranchId.fromJson(json['branchId']) : null;
    memberCategoryId = json['memberCategoryId'] != null
        ? MemberCategoryId.fromJson(json['memberCategoryId'])
        : null;
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
    if (clientId != null) {
      data['clientId'] = clientId!.toJson();
    }
    if (branchId != null) {
      data['branchId'] = branchId!.toJson();
    }
    if (memberCategoryId != null) {
      data['memberCategoryId'] = memberCategoryId!.toJson();
    }
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

class ClientId {
  int? id;
  String? name;
  int? accountType;
  String? country;
  String? stateProvince;
  String? applicantFirstname;
  String? applicantSurname;
  int? applicantGender;
  String? applicantPhone;
  String? applicantEmail;
  int? applicantDesignationRole;
  int? region;
  int? district;
  int? constituency;
  String? community;
  String? subscriptionDuration;
  String? subscriptionDate;
  String? subscriptionFee;
  String? logo;
  int? status;
  int? archive;
  AccountCategory? accountCategory;
  String? website;
  String? creationDate;
  int? updatedBy;
  String? updateDate;
  dynamic subscriptionInfo;
  List<CountryInfo>? countryInfo;

  ClientId(
      {this.id,
      this.name,
      this.accountType,
      this.country,
      this.stateProvince,
      this.applicantFirstname,
      this.applicantSurname,
      this.applicantGender,
      this.applicantPhone,
      this.applicantEmail,
      this.applicantDesignationRole,
      this.region,
      this.district,
      this.constituency,
      this.community,
      this.subscriptionDuration,
      this.subscriptionDate,
      this.subscriptionFee,
      this.logo,
      this.status,
      this.archive,
      this.accountCategory,
      this.website,
      this.creationDate,
      this.updatedBy,
      this.updateDate,
      this.subscriptionInfo,
      this.countryInfo});

  ClientId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountType = json['accountType'];
    country = json['country'];
    stateProvince = json['stateProvince'];
    applicantFirstname = json['applicantFirstname'];
    applicantSurname = json['applicantSurname'];
    applicantGender = json['applicantGender'];
    applicantPhone = json['applicantPhone'];
    applicantEmail = json['applicantEmail'];
    applicantDesignationRole = json['applicantDesignationRole'];
    region = json['region'];
    district = json['district'];
    constituency = json['constituency'];
    community = json['community'];
    subscriptionDuration = json['subscriptionDuration'];
    subscriptionDate = json['subscriptionDate'];
    subscriptionFee = json['subscriptionFee'];
    logo = json['logo'];
    status = json['status'];
    archive = json['archive'];
    accountCategory = json['accountCategory'] != null
        ? AccountCategory.fromJson(json['accountCategory'])
        : null;
    website = json['website'];
    creationDate = json['creationDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    subscriptionInfo = json['subscriptionInfo'];
    if (json['countryInfo'] != null) {
      countryInfo = <CountryInfo>[];
      json['countryInfo'].forEach((v) {
        countryInfo!.add(CountryInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['accountType'] = accountType;
    data['country'] = country;
    data['stateProvince'] = stateProvince;
    data['applicantFirstname'] = applicantFirstname;
    data['applicantSurname'] = applicantSurname;
    data['applicantGender'] = applicantGender;
    data['applicantPhone'] = applicantPhone;
    data['applicantEmail'] = applicantEmail;
    data['applicantDesignationRole'] = applicantDesignationRole;
    data['region'] = region;
    data['district'] = district;
    data['constituency'] = constituency;
    data['community'] = community;
    data['subscriptionDuration'] = subscriptionDuration;
    data['subscriptionDate'] = subscriptionDate;
    data['subscriptionFee'] = subscriptionFee;
    data['logo'] = logo;
    data['status'] = status;
    data['archive'] = archive;
    if (accountCategory != null) {
      data['accountCategory'] = accountCategory!.toJson();
    }
    data['website'] = website;
    data['creationDate'] = creationDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['subscriptionInfo'] = subscriptionInfo;
    if (countryInfo != null) {
      data['countryInfo'] = countryInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccountCategory {
  int? id;
  int? clientId;
  String? category;
  int? createdBy;
  int? updatedBy;
  Null? updateDate;
  Null? date;

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

class CountryInfo {
  int? id;
  String? name;
  String? short;
  String? code;

  CountryInfo({this.id, this.name, this.short, this.code});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    short = json['short'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short'] = short;
    data['code'] = code;
    return data;
  }
}

class BranchId {
  int? id;
  String? name;
  int? accountId;
  int? createdBy;
  String? creationDate;
  int? updatedBy;
  String? updateDate;

  BranchId(
      {this.id,
      this.name,
      this.accountId,
      this.createdBy,
      this.creationDate,
      this.updatedBy,
      this.updateDate});

  BranchId.fromJson(Map<String, dynamic> json) {
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

class MemberCategoryId {
  int? id;
  int? clientId;
  String? category;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  MemberCategoryId(
      {this.id,
      this.clientId,
      this.category,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  MemberCategoryId.fromJson(Map<String, dynamic> json) {
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

class MemberId {
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

  MemberId(
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
      this.editable});

  MemberId.fromJson(Map<String, dynamic> json) {
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
