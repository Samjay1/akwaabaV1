import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/country.dart';
import 'package:akwaaba/models/general/region.dart';

import '../../Networks/api_responses/clocked_member_response.dart';

class Organization {
  int? id;
  int? clientId;
  String? organizationName;
  String? contactPersonName;
  OrganizationType? organizationType;
  bool? businessRegistered;
  String? organizationPhone;
  String? organizationEmail;
  int? contactPersonGender;
  String? contactPersonPhoto;
  String? dateOfIncorporation;
  String? logo;
  String? contactPersonPhone;
  String? contactPersonEmail;
  String? countryOfBusiness;
  String? stateProvince;
  int? region;
  int? district;
  int? constituency;
  int? electoralArea;
  String? community;
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
  Branch? branchInfo;
  CategoryInfo? categoryInfo;
  List<Country>? countryInfo;
  Region? regionInfo;
  Region? districtInfo;
  Region? constituencyInfo;
  Region? electoralareaInfo;
  dynamic certificates;
  String? identification;

  Organization(
      {this.id,
      this.clientId,
      this.organizationName,
      this.contactPersonName,
      this.organizationType,
      this.businessRegistered,
      this.organizationPhone,
      this.organizationEmail,
      this.contactPersonGender,
      this.contactPersonPhoto,
      this.dateOfIncorporation,
      this.logo,
      this.contactPersonPhone,
      this.contactPersonEmail,
      this.countryOfBusiness,
      this.stateProvince,
      this.region,
      this.district,
      this.constituency,
      this.electoralArea,
      this.community,
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
      this.branchInfo,
      this.categoryInfo,
      this.countryInfo,
      this.regionInfo,
      this.districtInfo,
      this.constituencyInfo,
      this.electoralareaInfo,
      this.certificates,
      this.identification});

  Organization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    organizationName = json['organizationName'];
    contactPersonName = json['contactPersonName'];
    organizationType = json['organizationType'] != null
        ? OrganizationType.fromJson(json['organizationType'])
        : null;
    businessRegistered = json['businessRegistered'];
    organizationPhone = json['organizationPhone'];
    organizationEmail = json['organizationEmail'];
    contactPersonGender = json['contactPersonGender'];
    contactPersonPhoto = json['contactPersonPhoto'];
    dateOfIncorporation = json['dateOfIncorporation'];
    logo = json['logo'];
    contactPersonPhone = json['contactPersonPhone'];
    contactPersonEmail = json['contactPersonEmail'];
    countryOfBusiness = json['countryOfBusiness'];
    stateProvince = json['stateProvince'];
    region = json['region'];
    district = json['district'];
    constituency = json['constituency'];
    electoralArea = json['electoralArea'];
    community = json['community'];
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
    branchInfo =
        json['branchInfo'] != null ? Branch.fromJson(json['branchInfo']) : null;
    categoryInfo = json['categoryInfo'] != null
        ? CategoryInfo.fromJson(json['categoryInfo'])
        : null;
    if (json['countryInfo'] != null) {
      countryInfo = <Country>[];
      json['countryInfo'].forEach((v) {
        countryInfo!.add(Country.fromJson(v));
      });
    }
    regionInfo =
        json['regionInfo'] != null ? Region.fromJson(json['regionInfo']) : null;
    districtInfo = json['districtInfo'] != null
        ? Region.fromJson(json['districtInfo'])
        : null;
    constituencyInfo = json['constituencyInfo'] != null
        ? Region.fromJson(json['constituencyInfo'])
        : null;
    electoralareaInfo = json['electoralareaInfo'] != null
        ? Region.fromJson(json['electoralareaInfo'])
        : null;
    certificates = json['certificates'];
    identification = json['identification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['organizationName'] = organizationName;
    data['contactPersonName'] = contactPersonName;
    if (organizationType != null) {
      data['organizationType'] = organizationType!.toJson();
    }
    data['businessRegistered'] = businessRegistered;
    data['organizationPhone'] = organizationPhone;
    data['organizationEmail'] = organizationEmail;
    data['contactPersonGender'] = contactPersonGender;
    data['contactPersonPhoto'] = contactPersonPhoto;
    data['dateOfIncorporation'] = dateOfIncorporation;
    data['logo'] = logo;
    data['contactPersonPhone'] = contactPersonPhone;
    data['contactPersonEmail'] = contactPersonEmail;
    data['countryOfBusiness'] = countryOfBusiness;
    data['stateProvince'] = stateProvince;
    data['region'] = region;
    data['district'] = district;
    data['constituency'] = constituency;
    data['electoralArea'] = electoralArea;
    data['community'] = community;
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
    if (branchInfo != null) {
      data['branchInfo'] = branchInfo!.toJson();
    }
    if (categoryInfo != null) {
      data['categoryInfo'] = categoryInfo!.toJson();
    }
    if (countryInfo != null) {
      data['countryInfo'] = countryInfo!.map((v) => v.toJson()).toList();
    }
    if (regionInfo != null) {
      data['regionInfo'] = regionInfo!.toJson();
    }
    if (districtInfo != null) {
      data['districtInfo'] = districtInfo!.toJson();
    }
    if (constituencyInfo != null) {
      data['constituencyInfo'] = constituencyInfo!.toJson();
    }
    if (electoralareaInfo != null) {
      data['electoralareaInfo'] = electoralareaInfo!.toJson();
    }
    data['certificates'] = certificates;
    data['identification'] = identification;
    return data;
  }
}

class OrganizationType {
  int? id;
  int? memberId;
  int? clientId;
  String? type;
  int? createdBy;
  int? updatedBy;
  String? updateDate;
  String? date;

  OrganizationType(
      {this.id,
      this.memberId,
      this.clientId,
      this.type,
      this.createdBy,
      this.updatedBy,
      this.updateDate,
      this.date});

  OrganizationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    clientId = json['clientId'];
    type = json['type'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['memberId'] = memberId;
    data['clientId'] = clientId;
    data['type'] = type;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is OrganizationType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
