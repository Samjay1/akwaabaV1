class MemberProfile {
  int? id;
  String? firstname;
  String? surname;
  String? profilePicture;
  String? phone;
  String? email;
  int? clientId;

  MemberProfile(
      {this.id,
        this.firstname,
        this.surname,
        this.profilePicture,
        this.phone,
        this.email,
        this.clientId});

  MemberProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    surname = json['surname'];
    profilePicture = json['profilePicture'];
    phone = json['phone'];
    email = json['email'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['surname'] = this.surname;
    data['profilePicture'] = this.profilePicture;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['clientId'] = this.clientId;
    return data;
  }
}
