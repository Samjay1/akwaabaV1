class AttendanceHistoryItem {
  String? name;
  String? fromDate;
  String? toDate;
  String? meetingType;
  String? endBreak;
  String? status;
  String? date;

  AttendanceHistoryItem(
      {this.name,
        this.fromDate,
        this.toDate,
        this.meetingType,
        this.endBreak,
        this.status,
        this.date});

  AttendanceHistoryItem.fromJson(Map<String, dynamic> json) {
    name = json['meeting_type'];
    fromDate = json['clock_in'];
    toDate = json['clock_out'];
    meetingType = json['start_break'];
    endBreak = json['end_break'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meeting_type'] = this.name;
    data['clock_in'] = this.fromDate;
    data['clock_out'] = this.toDate;
    data['start_break'] = this.meetingType;
    data['end_break'] = this.endBreak;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
