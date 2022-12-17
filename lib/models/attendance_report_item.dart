class AttendanceReportItem {
  String? username;
  String? clockInTime;
  String? clockOutTime;
  String? breakTimeStart;
  String? breakTimeEnd;
  String? lastAttendedMeeting;
  String? whatsappContact;

  AttendanceReportItem(
      {this.username,
        this.clockInTime,
        this.clockOutTime,
        this.breakTimeStart,
        this.breakTimeEnd,
        this.lastAttendedMeeting,
        this.whatsappContact});

  AttendanceReportItem.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    clockInTime = json['clock_in_time'];
    clockOutTime = json['clock_out_time'];
    breakTimeStart = json['break_time_start'];
    breakTimeEnd = json['break_time_end'];
    lastAttendedMeeting = json['last_attended_meeting'];
    whatsappContact = json['Whatsapp_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_time'] = this.clockOutTime;
    data['break_time_start'] = this.breakTimeStart;
    data['break_time_end'] = this.breakTimeEnd;
    data['last_attended_meeting'] = this.lastAttendedMeeting;
    data['Whatsapp_contact'] = this.whatsappContact;
    return data;
  }
}
