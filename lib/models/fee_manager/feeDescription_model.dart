
class FeeDescription {
  var id;
  var feeDescription;

  FeeDescription(
      this.id,
      this.feeDescription
      );

  factory FeeDescription.fromJson(Map<String, dynamic> json){
    return FeeDescription(json['id'], json['fee_description']);
  }
}