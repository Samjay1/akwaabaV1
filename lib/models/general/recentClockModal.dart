
class RecentClockModal {
  int? id;
  int? type;
  int? memberType;
  String? name;
  int? meetingSpan;
  String? startTime;
  String? closeTime;
  String? agenda;
  String? updateDate;
  bool? inOrOut = false;
  dynamic startBreak;
  dynamic endBreak;
  dynamic inTime;
  dynamic outTime;
  String? clockedBy;

  RecentClockModal(
    this.id,
    this.type,
    this.memberType,
    this.name,
    this.meetingSpan,
    this.startTime,
    this.closeTime,
    this.agenda,
    this.updateDate,
    this.inOrOut,
    this.startBreak,
    this.endBreak,
    this.inTime,
    this.outTime,
    this.clockedBy
  );

  factory RecentClockModal.fromJson(Map<String, dynamic> json, Map<String, dynamic> mainJson) {
    return RecentClockModal(
      json['id'],
      json['type'],
      json['memberType'],
      json['name'],
      json['meetingSpan'],
      json['startTime'],
      json['closeTime'],
      json['agenda'],
      json['updateDate'],
        mainJson['inOrOut'],
        mainJson['startBreak'],
        mainJson['endBreak'],
        mainJson['inTime'],
        mainJson['outTime'],
        mainJson['clockedBy']
    );
  }

}
