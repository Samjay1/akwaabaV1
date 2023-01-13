class AttendanceNote {
  int? id;
  int? clockingId;
  String? note;
  String? date;
  String? message;

  AttendanceNote({
    this.id,
    this.clockingId,
    this.note,
    this.date,
    this.message,
  });

  AttendanceNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clockingId = json['clockingId'];
    note = json['note'];
    message = json['SUCCESS_RESPONSE_MESSAGE'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clockingId'] = clockingId;
    data['note'] = note;
    data['SUCCESS_RESPONSE_MESSAGE'] = message;
    data['date'] = date;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is AttendanceNote && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
