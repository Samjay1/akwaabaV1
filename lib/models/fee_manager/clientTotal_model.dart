
class ClientTotalModel {
  var total_assigned;
  var total_paid;
  var total_arrears;

  ClientTotalModel(
      this.total_assigned,
      this.total_paid,
      this.total_arrears
      );

  factory ClientTotalModel.fromJson(Map<String, dynamic> json){
    return ClientTotalModel(
        json['total_assigned'],
        json['total_paid'],
        json['total_arrears']);
  }
}