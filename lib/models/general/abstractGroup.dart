class AbstractGroup {
  int? id;
  String? group;

  AbstractGroup(
      this.id,
      this. group);

  factory AbstractGroup.fromJson(Map<String, dynamic> json) {
    return AbstractGroup(
        json['id'],
        json['group']
    );
  }

}