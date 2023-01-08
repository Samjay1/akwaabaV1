class ClientAccountInfo {
  var id;
  var name;
  var accountType;
  var country;
  var stateProvince;
  var applicantFirstname;
  var applicantSurname;
  var applicantEmail;
  var applicantDesignationRole;
  var region;
  var district;
  var constituency;
  var community;
  var subscriptionDuration;
  var subscriptionDate;
  var subscriptionFee;
  var logo;
  var status;
  var archive;
  var website;
  var creationDate;

  var accountCategory;
  var accountCategoryClientId;

  var subscriptionInfo;

  var firstName;
  var surName;
  var profilePicture;
  var phone;
  var email;
  var accountId;
  var branchID;
  var branchName;

  var clientToken;

  ClientAccountInfo(
    this.id,
    this.name,
    this.accountType,
    this.country,
    this.stateProvince,
    this.applicantFirstname,
    this.applicantSurname,
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
    this.website,
    this.creationDate,
    this.accountCategory,
    this.accountCategoryClientId,
    this.subscriptionInfo,
    this.firstName,
    this.surName,
    this.profilePicture,
    this.phone,
    this.email,
    this.accountId,
    this.branchID,
    this.branchName,
    this.clientToken,
  );

  factory ClientAccountInfo.fromJson(Map<String, dynamic> json,
      Map<String, dynamic> userjson, var branchName, var clientToken) {
    return ClientAccountInfo(
        json['id'],
        json['name'],
        json['accountType'],
        json['country'],
        json['stateProvince'],
        json['applicantFirstname'],
        json['applicantSurname'],
        json['applicantEmail'],
        json['applicantDesignationRole'],
        json['region'],
        json['district'],
        json['constituency'],
        json['community'],
        json['subscriptionDuration'],
        json['subscriptionDate'],
        json['subscriptionFee'],
        json['logo'],
        json['status'],
        json['archive'],
        json['website'],
        json['creationDate'],
        json['accountCategory']['category'],
        json['accountCategory']['clientId'],
        json['subscriptionInfo'],
        userjson['firstname'],
        userjson['surname'],
        userjson['profilePicture'],
        userjson['phone'],
        userjson['email'],
        userjson['accountID'],
        userjson['branchId'],
        branchName,
        clientToken);
  }

  factory ClientAccountInfo.fromMap(Map<String, dynamic> json) {
    return ClientAccountInfo(
        json['id'],
        json['name'],
        json['accountType'],
        json['country'],
        json['stateProvince'],
        json['applicantFirstname'],
        json['applicantSurname'],
        json['applicantEmail'],
        json['applicantDesignationRole'],
        json['region'],
        json['district'],
        json['constituency'],
        json['community'],
        json['subscriptionDuration'],
        json['subscriptionDate'],
        json['subscriptionFee'],
        json['logo'],
        json['status'],
        json['archive'],
        json['website'],
        json['creationDate'],
        json['accountCategory']['category'],
        json['accountCategory']['clientId'],
        json['subscriptionInfo'],
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null);
  }
}
