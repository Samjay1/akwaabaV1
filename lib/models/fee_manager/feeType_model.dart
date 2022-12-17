
class FeeType {
  var id;
  var feeType;

  FeeType(
      this.id,
      this.feeType
      );

  factory FeeType.fromJson(Map<String, dynamic> json){
    return FeeType(json['id'], json['fee_type']);
  }
}