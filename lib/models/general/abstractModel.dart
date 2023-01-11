class AbstractModel {
  String? id;
  String? name;

  AbstractModel(
      this.id,
      this.name);

  factory AbstractModel.fromJson(Map<String, dynamic> json) {
    return AbstractModel(
        json['id'],
        json['name']
    );
  }

}