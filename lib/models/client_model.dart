
class ClientModel{
  var id;
  var firstName;
  var surName;
  var profilePicture;
  var phone;
  var email;
  var accountId;
  var branchId;

  ClientModel(
      this.id,
      this.firstName,
      this.surName,
      this.profilePicture,
      this.phone,
      this.email,
      this.accountId,
      this.branchId
      );

  factory ClientModel.fromJson(Map<String, dynamic> json){
    return ClientModel(
        json['id'],
        json['firstname'],
        json['surname'],
        json['profilePicture'],
        json['phone'],
        json['email'],
        json['accountID'],
        json['branchId']
    );
  }
}