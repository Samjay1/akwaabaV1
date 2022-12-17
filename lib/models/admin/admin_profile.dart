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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['surname'] = this.surname;
    data['profilePicture'] = this.profilePicture;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['accountId'] = this.accountId;
    data['branchId'] = this.branchId;
    return data;
  }
}
