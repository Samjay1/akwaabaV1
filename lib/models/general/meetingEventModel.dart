class MeetingEventModel{
  var id;
  var type;
  var name;
  var memberType;
  var clientId;
  var branchId;
  var meetingSpan;
  var startTime;
  var closeTime;
  var latenessTime;
  var hasBreakTIme;
  var hasDuty;
  var hasOverTime;
  var virtualMeetingLink;
  var virtualMeetingType;
  var meetingLocation;
  var expectedMonthlyAttendance;
  var activeMonthlyAttendance;
  var agenda;
  var updateDate;

  MeetingEventModel(
      this.id,
      this.type,
      this.name,
      this.memberType,
      this.clientId,
      this.branchId,
      this.meetingSpan,
      this.startTime,
      this.closeTime,
      this.latenessTime,
      this.hasBreakTIme,
      this.hasDuty,
      this.hasOverTime,
      this.virtualMeetingLink,
      this.virtualMeetingType,
      this.meetingLocation,
      this.expectedMonthlyAttendance,
      this.activeMonthlyAttendance,
      this.agenda,
      this.updateDate
      );

  factory MeetingEventModel.fromJson(Map<String, dynamic> json){
    return  MeetingEventModel(
        json['id'],
        json['type'],
        json['name'],
        json['memberType'],
        json['clientId'],
        json['branchId'],
        json['meetingSpan'],
        json['startTime'],
        json['closeTime'],
        json['latenessTime'],
        json['hasBreakTIme'],
        json['hasDuty'],
        json['hasOverTime'],
        json['virtualMeetingLink'],
        json['virtualMeetingType'],
        json['meetingLocation'],
        json['expectedMonthlyAttendance'],
        json['activeMonthlyAttendance'],
        json['agenda'],
        json['updateDate']
    );
  }

}