class AdminProfile {
  var id;
  var firstname;
  var surname;
  var profilePicture;
  var phone;
  var email;
  var accountId;
  var branchId;

  AdminProfile(
      {this.id,
      this.firstname,
      this.surname,
      this.profilePicture,
      this.phone,
      this.email,
      this.accountId,
      this.branchId});

  AdminProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    surname = json['surname'];
    profilePicture = json['profilePicture'];
    phone = json['phone'];
    email = json['email'];
    accountId = json['accountId'];
    branchId = json['branchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['surname'] = surname;
    data['profilePicture'] = profilePicture;
    data['phone'] = phone;
    data['email'] = email;
    data['accountId'] = accountId;
    data['branchId'] = branchId;
    return data;
  }
}
