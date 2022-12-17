class MemberModel {
  String? id;
  String? clientId;
  String? firstname;
  String? surname;
  String? gender;
  String? profilePicture;
  String? phone;
  String? email;
  String? dateOfBirth;
  String? date;
  String? countryOfResidence;
  String? region;
  String? district;
  String? constituency;
  String? community;
  String? hometown;
  String? houseNoDigitalAddress;
  String? digitalAddress;

  MemberModel(
      this.id,
      this.clientId,
      this.firstname,
      this.surname,
      this.gender,
      this.profilePicture,
      this.phone,
      this.email,
      this.dateOfBirth,
      this.date,
      this.countryOfResidence,
      this.region,
      this.district,
      this.constituency,
      this.community,
      this.hometown,
      this.houseNoDigitalAddress,
      this.digitalAddress
      );

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
        json['id'],
        json['clientId'],
        json['firstname'],
        json['surname'],
        json['gender'],
        json['profilePicture'],
        json['phone'],
        json['email'],
        json['dateOfBirth'],
        json['date'],
        json['countryOfResidence'],
        json['region'],
        json['district'],
        json['constituency'],
        json['community'],
        json['hometown'],
        json['houseNoDigitalAddress'],
        json['digitalAddress']
    );
  }


}
