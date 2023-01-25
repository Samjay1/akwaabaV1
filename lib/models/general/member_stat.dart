class MemberStat {
  int? totalMembers;
  int? totalMale;
  int? totalFemale;
  int? totalIndividualMembers;
  int? totalIndividualMale;
  int? totalIndividualFemale;
  int? totalOrganizationMembers;
  int? totalOrganizationMale;
  int? totalOrganizationFemale;

  MemberStat(
      {this.totalMembers,
      this.totalMale,
      this.totalFemale,
      this.totalIndividualMembers,
      this.totalIndividualMale,
      this.totalIndividualFemale,
      this.totalOrganizationMembers,
      this.totalOrganizationMale,
      this.totalOrganizationFemale});

  MemberStat.fromJson(Map<String, dynamic> json) {
    totalMembers = json['totalMembers'];
    totalMale = json['totalMale'];
    totalFemale = json['totalFemale'];
    totalIndividualMembers = json['totalIndividualMembers'];
    totalIndividualMale = json['totalIndividualMale'];
    totalIndividualFemale = json['totalIndividualFemale'];
    totalOrganizationMembers = json['totalOrganizationMembers'];
    totalOrganizationMale = json['totalOrganizationMale'];
    totalOrganizationFemale = json['totalOrganizationFemale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalMembers'] = totalMembers;
    data['totalMale'] = totalMale;
    data['totalFemale'] = totalFemale;
    data['totalIndividualMembers'] = totalIndividualMembers;
    data['totalIndividualMale'] = totalIndividualMale;
    data['totalIndividualFemale'] = totalIndividualFemale;
    data['totalOrganizationMembers'] = totalOrganizationMembers;
    data['totalOrganizationMale'] = totalOrganizationMale;
    data['totalOrganizationFemale'] = totalOrganizationFemale;
    return data;
  }
}
