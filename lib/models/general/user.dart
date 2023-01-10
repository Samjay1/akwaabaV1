class User {
  int? id;
  String? firstname;
  String? surname;
  String? profilePicture;
  String? phone;
  String? email;
  int? clientId;

  User(
      {this.id,
      this.firstname,
      this.surname,
      this.profilePicture,
      this.phone,
      this.email,
      this.clientId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    surname = json['surname'];
    profilePicture = json['profilePicture'];
    phone = json['phone'];
    email = json['email'];
    clientId = json['clientId'];
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