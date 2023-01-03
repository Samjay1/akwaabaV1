import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/attendance/attendance.dart';

class ClockedMembersResponse {
  int? count;
  String? next;
  String? previous;
  List<Attendee>? results;

  ClockedMembersResponse({this.count, this.next, this.previous, this.results});

  ClockedMembersResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Attendee>[];
      json['results'].forEach((v) {
        results!.add(Attendee.fromJson(v));
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

class Attendee {
  AdditionalInfo? additionalInfo;
  Attendance? attendance;
  String? lastSeen;
  String? status;

  Attendee({this.additionalInfo, this.attendance, this.lastSeen, this.status});

  Attendee.fromJson(Map<String, dynamic> json) {
    additionalInfo = json['additionalInfo'] != null
        ? AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    attendance = json['attendance'] != null
        ? Attendance.fromJson(json['attendance'])
        : null;
    lastSeen = json['lastSeen'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (additionalInfo != null) {
      data['additionalInfo'] = additionalInfo!.toJson();
    }
    if (attendance != null) {
      data['attendance'] = attendance!.toJson();
    }
    data['lastSeen'] = lastSeen;
    data['status'] = status;
    return data;
  }
}

class AdditionalInfo {
  int? id;
  int? memberId;
  Member? memberInfo;
  String? phone;
  String? email;
  String? placeOfWork;
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;
  String? accountBio;
  String? businessHashtag;
  String? businessDescription;
  String? profession;
  String? website;
  String? postalAddress;
  String? digitalAddress;
  String? dateJoined;
  String? date;

  AdditionalInfo(
      {this.id,
      this.memberId,
      this.memberInfo,
      this.phone,
      this.email,
      this.placeOfWork,
      this.whatsapp,
      this.facebook,
      this.twitter,
      this.instagram,
      this.accountBio,
      this.businessHashtag,
      this.businessDescription,
      this.profession,
      this.website,
      this.postalAddress,
      this.digitalAddress,
      this.dateJoined,
      this.date});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    memberInfo =
        json['memberInfo'] != null ? Member.fromJson(json['memberInfo']) : null;
    phone = json['phone'];
    email = json['email'];
    placeOfWork = json['placeOfWork'];
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    accountBio = json['accountBio'];
    businessHashtag = json['businessHashtag'];
    businessDescription = json['businessDescription'];
    profession = json['profession'];
    website = json['website'];
    postalAddress = json['postalAddress'];
    digitalAddress = json['digitalAddress'];
    dateJoined = json['dateJoined'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['memberId'] = memberId;
    if (memberInfo != null) {
      data['memberInfo'] = memberInfo!.toJson();
    }
    data['phone'] = phone;
    data['email'] = email;
    data['placeOfWork'] = placeOfWork;
    data['whatsapp'] = whatsapp;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['accountBio'] = accountBio;
    data['businessHashtag'] = businessHashtag;
    data['businessDescription'] = businessDescription;
    data['profession'] = profession;
    data['website'] = website;
    data['postalAddress'] = postalAddress;
    data['digitalAddress'] = digitalAddress;
    data['dateJoined'] = dateJoined;
    data['date'] = date;
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

class MeetingEventId {
  int? id;
  int? type;
  int? memberType;
  String? name;
  ClientId? clientId;
  BranchInfo? branchId;
  CategoryInfo? memberCategoryId;
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
        json['branchId'] != null ? BranchInfo.fromJson(json['branchId']) : null;
    memberCategoryId = json['memberCategoryId'] != null
        ? CategoryInfo.fromJson(json['memberCategoryId'])
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
  dynamic? subscriptionInfo;
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
  String? profileResume;
  String? profileIdentification;
  bool? archived;
  BranchInfo? branchInfo;
  CategoryInfo? categoryInfo;

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
      this.editable,
      this.profileResume,
      this.profileIdentification,
      this.archived,
      this.branchInfo,
      this.categoryInfo});

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
