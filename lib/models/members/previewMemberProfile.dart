import 'package:akwaaba/models/admin/clocked_member.dart';

class PreviewMemberProfile {
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
  String? date;
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
  bool? editable;
  String? profileResume;
  String? profileIdentification;
  int? branchId;
  dynamic branchInfo;
  dynamic categoryInfo;
  String? identification;
  String? referenceId;
  int? updatedBy;
  String? updateDate;
  UpdatedByInfo? updatedByInfo;

  PreviewMemberProfile(
    this.id,
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
    this.date,
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
    this.editable,
    this.profileResume,
    this.profileIdentification,
    this.branchId,
    this.branchInfo,
    this.categoryInfo,
    this.identification,
    this.referenceId,
    this.updatedBy,
    this.updateDate,
    this.updatedByInfo,
  );

  factory PreviewMemberProfile.fromJson(Map<String, dynamic> json) {
    return PreviewMemberProfile(
      json['id'],
      json['clientId'],
      json['firstname'],
      json['middlename'],
      json['surname'],
      json['gender'],
      json['profilePicture'],
      json['phone'],
      json['email'],
      json['dateOfBirth'],
      json['religion'],
      json['date'],
      json['nationality'],
      json['countryOfResidence'],
      json['stateProvince'],
      json['region'],
      json['district'],
      json['constituency'],
      json['electoralArea'],
      json['community'],
      json['hometown'],
      json['houseNoDigitalAddress'],
      json['digitalAddress'],
      json['level'],
      json['status'],
      json['accountType'],
      json['memberType'],
      json['editable'],
      json['profileResume'],
      json['profileIdentification'],
      json['branchId'],
      json['branchInfo'],
      json['categoryInfo'],
      json['identification'],
      json['referenceId'],
      json['updatedBy'],
      json['updateDate'],
      json['updatedByInfo'] != null
          ? UpdatedByInfo.fromJson(json['updatedByInfo'])
          : null,
    );
  }
}
