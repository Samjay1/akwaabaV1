class NotificationType {
  int? id;
  String? type;

  NotificationType({
    this.id,
    this.type,
  });

  NotificationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;

    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is NotificationType && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
