import 'package:akwaaba/Networks/api_responses/clocked_member_response.dart';
import 'package:equatable/equatable.dart';

class Member extends Equatable {
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
  dynamic profileResume;
  dynamic profileIdentification;
  bool? archived;
  BranchInfo? branchInfo;
  CategoryInfo? categoryInfo;
  List<CountryInfo>? countryInfo;
  RegionInfo? regionInfo;
  DistrictInfo? districtInfo;
  ConstituencyInfo? constituencyInfo;
  ConstituencyInfo? electoralareaInfo;
  String? identification;
  bool? selected = false;

  Member({
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
    this.categoryInfo,
    this.countryInfo,
    this.regionInfo,
    this.districtInfo,
    this.constituencyInfo,
    this.electoralareaInfo,
    this.identification,
    this.selected,
  });

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
    if (json['countryInfo'] != null) {
      countryInfo = <CountryInfo>[];
      json['countryInfo'].forEach((v) {
        countryInfo!.add(CountryInfo.fromJson(v));
      });
    }
    regionInfo = json['regionInfo'] != null
        ? RegionInfo.fromJson(json['regionInfo'])
        : null;
    districtInfo = json['districtInfo'] != null
        ? DistrictInfo.fromJson(json['districtInfo'])
        : null;
    constituencyInfo = json['constituencyInfo'] != null
        ? ConstituencyInfo.fromJson(json['constituencyInfo'])
        : null;
    electoralareaInfo = json['electoralareaInfo'] != null
        ? ConstituencyInfo.fromJson(json['electoralareaInfo'])
        : null;
    identification = json['identification'];
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
    data['identification'] = identification;
    return data;
  }

  @override
  List<Object?> get props {
    return [
      id,
      //clockingId,
      //clientId,
      firstname,
      surname,
      //middlename,
      // gender,
      // profilePicture,
      phone,
      email,
      dateOfBirth,
      // religion,
      // nationality,
      // countryOfResidence,
      // stateProvince,
      // region,
      // district,
      // constituency,
      // electoralArea,
      // community,
      // hometown,
      // houseNoDigitalAddress,
      // digitalAddress,
      // level,
      // status,
      // accountType,
      // memberType,
      // date,
      // lastLogin,
      // referenceId,
      // branchId,
      // editable,
      // profileResume,
      // profileIdentification,
      // archived,
      // branchInfo,
      // categoryInfo,
      //selected,
    ];
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

class RegionInfo {
  int? id;
  String? location;

  RegionInfo({this.id, this.location});

  RegionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    return data;
  }
}

class DistrictInfo {
  int? id;
  RegionInfo? regionId;
  String? location;

  DistrictInfo({this.id, this.regionId, this.location});

  DistrictInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId =
        json['regionId'] != null ? RegionInfo.fromJson(json['regionId']) : null;
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (regionId != null) {
      data['regionId'] = regionId!.toJson();
    }
    data['location'] = location;
    return data;
  }
}

class ConstituencyInfo {
  int? id;
  RegionInfo? regionId;
  DistrictInfo? districtId;
  String? location;

  ConstituencyInfo({this.id, this.regionId, this.districtId, this.location});

  ConstituencyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId =
        json['regionId'] != null ? RegionInfo.fromJson(json['regionId']) : null;
    districtId = json['districtId'] != null
        ? DistrictInfo.fromJson(json['districtId'])
        : null;
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (regionId != null) {
      data['regionId'] = regionId!.toJson();
    }
    if (districtId != null) {
      data['districtId'] = districtId!.toJson();
    }
    data['location'] = location;
    return data;
  }
}
