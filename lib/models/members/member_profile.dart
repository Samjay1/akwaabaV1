class MemberProfile {
  var id;
  String? firstname;
  String? surname;
  String? profilePicture;
  String? phone;
  String? email;
  int? clientId;
  String? memberToken;

  MemberProfile(this.id, this.firstname, this.surname, this.profilePicture,
      this.phone, this.email, this.clientId, this.memberToken);

  factory MemberProfile.fromJson(Map<String, dynamic> json, memberToken) {
    return MemberProfile(
        json['id'],
        json['firstname'],
        json['surname'],
        json['profilePicture'],
        json['phone'],
        json['email'],
        json['clientId'],
        memberToken);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['surname'] = surname;
    data['profilePicture'] = profilePicture;
    data['phone'] = phone;
    data['email'] = email;
    data['clientId'] = clientId;
    return data;
  }
}
