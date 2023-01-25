class ClientStat {
  Type? type;
  Statistics? statistics;
  String? expirationDate;

  ClientStat({this.type, this.statistics, this.expirationDate});

  ClientStat.fromJson(Map<String, dynamic> json) {
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    statistics = json['statistics'] != null
        ? Statistics.fromJson(json['statistics'])
        : null;
    expirationDate = json['expiration_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (statistics != null) {
      data['statistics'] = statistics!.toJson();
    }
    data['expiration_date'] = expirationDate;
    return data;
  }
}

class Type {
  int? id;
  String? name;

  Type({this.id, this.name});

  Type.fromJson(Map<String, dynamic> json) {
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

class Statistics {
  int? allMembers;
  int? allMales;
  int? allFemales;
  int? allOrganizations;
  int? allAdmins;
  int? allArchived;
  CurrentBranch? currentBranch;
  double? subscriptionAmount;

  Statistics(
      {this.allMembers,
      this.allMales,
      this.allFemales,
      this.allOrganizations,
      this.allAdmins,
      this.allArchived,
      this.currentBranch,
      this.subscriptionAmount});

  Statistics.fromJson(Map<String, dynamic> json) {
    allMembers = json['all_members'];
    allMales = json['all_males'];
    allFemales = json['all_females'];
    allOrganizations = json['all_organizations'];
    allAdmins = json['all_admins'];
    allArchived = json['all_archived'];
    currentBranch = json['current_branch'] != null
        ? CurrentBranch.fromJson(json['current_branch'])
        : null;
    subscriptionAmount = json['subscription_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all_members'] = allMembers;
    data['all_males'] = allMales;
    data['all_females'] = allFemales;
    data['all_organizations'] = allOrganizations;
    data['all_admins'] = allAdmins;
    data['all_archived'] = allArchived;
    if (currentBranch != null) {
      data['current_branch'] = currentBranch!.toJson();
    }
    data['subscription_amount'] = subscriptionAmount;
    return data;
  }
}

class CurrentBranch {
  int? allMembers;
  int? allMales;
  int? allFemales;
  int? allOrganizations;
  int? allAdmins;
  int? allArchived;
  Type? branch;

  CurrentBranch(
      {this.allMembers,
      this.allMales,
      this.allFemales,
      this.allOrganizations,
      this.allAdmins,
      this.allArchived,
      this.branch});

  CurrentBranch.fromJson(Map<String, dynamic> json) {
    allMembers = json['all_members'];
    allMales = json['all_males'];
    allFemales = json['all_females'];
    allOrganizations = json['all_organizations'];
    allAdmins = json['all_admins'];
    allArchived = json['all_archived'];
    branch = json['branch'] != null ? Type.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all_members'] = allMembers;
    data['all_males'] = allMales;
    data['all_females'] = allFemales;
    data['all_organizations'] = allOrganizations;
    data['all_admins'] = allAdmins;
    data['all_archived'] = allArchived;
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    return data;
  }
}
