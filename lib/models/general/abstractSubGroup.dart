class AbstractSubGroup {
  String? id;
  String? subgroup;

  AbstractSubGroup(
      this.id,
      this.subgroup);

  factory AbstractSubGroup.fromJson(Map<String, dynamic> json) {
    return AbstractSubGroup(
        json['id'],
        json['subgroup']
    );
  }

}