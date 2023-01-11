class ClientAccountInfo {
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

  ClientAccountInfo(
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

  ClientAccountInfo.fromJson(Map<String, dynamic> json) {
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
