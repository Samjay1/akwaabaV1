import 'package:akwaaba/Networks/api_responses/coordinates_response.dart';

class MeetingEventModel {
  int? id;
  int? type;
  int? memberType;
  String? name;
  dynamic clientId;
  dynamic branchId;
  dynamic memberCategoryId;
  int? meetingSpan;
  String? startTime;
  String? closeTime;
  String? latenessTime;
  bool? isRecuring;
  bool? hasBreakTime;
  bool? hasDuty;
  bool? hasOvertime;
  String? startBreakTime;
  String? endBreakTime;
  String? virtualMeetingLink;
  int? virtualMeetingType;
  int? meetingLocation;
  int? expectedMonthlyAttendance;
  int? activeMonthlyAttendance;
  String? agenda;
  String? agendaFile;
  int? updatedBy;
  String? updateDate;
  String? date;
  bool? inOrOut = false;
  dynamic startBreak;
  dynamic endBreak;
  dynamic inTime;
  dynamic outTime;
  List<UpcomingDays>? upcomingDays;
  List<UpcomingDates>? upcomingDates;
  List<LocationInfo>? locationInfo;
  List<BreakInfo>? breakInfo;

  MeetingEventModel({
    this.id,
    this.type,
    this.memberType,
    this.name,
    this.clientId,
    this.branchId,
    this.memberCategoryId,
    this.meetingSpan,
    this.startTime,
    this.closeTime,
    this.latenessTime,
    this.isRecuring,
    this.hasBreakTime,
    this.hasDuty,
    this.hasOvertime,
    this.startBreakTime,
    this.endBreakTime,
    this.virtualMeetingLink,
    this.virtualMeetingType,
    this.meetingLocation,
    this.expectedMonthlyAttendance,
    this.activeMonthlyAttendance,
    this.agenda,
    this.agendaFile,
    this.updatedBy,
    this.updateDate,
    this.date,
    this.inOrOut,
    this.upcomingDays,
    this.upcomingDates,
    this.locationInfo,
    this.breakInfo,
  });

  MeetingEventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    memberType = json['memberType'];
    name = json['name'];
    // clientId =
    //     json['clientId'] != null ? ClientId.fromJson(json['clientId']) : null;
    // branchId =
    //     json['branchId'] != null ? BranchId.fromJson(json['branchId']) : null;
    // memberCategoryId = json['memberCategoryId'] != null
    //     ? MemberCategoryId.fromJson(json['memberCategoryId'])
    //     : null;
    clientId = json['clientId'];
    branchId = json['branchId'];
    memberCategoryId = json['memberCategoryId'];
    meetingSpan = json['meetingSpan'];
    startTime = json['startTime'];
    closeTime = json['closeTime'];
    latenessTime = json['latenessTime'];
    isRecuring = json['isRecuring'];
    hasBreakTime = json['hasBreakTime'];
    startBreakTime = json['startBreakTime'];
    endBreakTime = json['endBreakTime'];
    hasDuty = json['hasDuty'];
    hasOvertime = json['hasOvertime'];
    virtualMeetingLink = json['virtualMeetingLink'];
    virtualMeetingType = json['virtualMeetingType'];
    meetingLocation = json['meetingLocation'];
    expectedMonthlyAttendance = json['expectedMonthlyAttendance'];
    activeMonthlyAttendance = json['activeMonthlyAttendance'];
    agenda = json['agenda'];
    agendaFile = json['agendaFile'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
    if (json['upcoming_days'] != null) {
      upcomingDays = <UpcomingDays>[];
      json['upcoming_days'].forEach((v) {
        upcomingDays!.add(UpcomingDays.fromJson(v));
      });
    }
    if (json['upcoming_dates'] != null) {
      upcomingDates = <UpcomingDates>[];
      json['upcoming_dates'].forEach((v) {
        upcomingDates!.add(UpcomingDates.fromJson(v));
      });
    }
    if (json['locationInfo'] != null) {
      locationInfo = <LocationInfo>[];
      json['locationInfo'].forEach((v) {
        locationInfo!.add(LocationInfo.fromJson(v));
      });
    }
    if (json['breakInfo'] != null) {
      breakInfo = <BreakInfo>[];
      json['breakInfo'].forEach((v) {
        breakInfo!.add(BreakInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['memberType'] = memberType;
    data['name'] = name;
    data['clientId'] = clientId!;
    data['branchId'] = branchId!;
    data['memberCategoryId'] = memberCategoryId!;
    data['meetingSpan'] = meetingSpan;
    data['startTime'] = startTime;
    data['closeTime'] = closeTime;
    data['latenessTime'] = latenessTime;
    data['isRecuring'] = isRecuring;
    data['hasBreakTime'] = hasBreakTime;
    data['startBreakTime'] = startBreakTime;
    data['endBreakTime'] = endBreakTime;
    data['hasDuty'] = hasDuty;
    data['hasOvertime'] = hasOvertime;
    data['virtualMeetingLink'] = virtualMeetingLink;
    data['virtualMeetingType'] = virtualMeetingType;
    data['meetingLocation'] = meetingLocation;
    data['expectedMonthlyAttendance'] = expectedMonthlyAttendance;
    data['activeMonthlyAttendance'] = activeMonthlyAttendance;
    data['agenda'] = agenda;
    data['agendaFile'] = agendaFile;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    if (upcomingDays != null) {
      data['upcoming_days'] = upcomingDays!.map((v) => v.toJson()).toList();
    }
    if (upcomingDates != null) {
      data['upcoming_dates'] = upcomingDates!.map((v) => v.toJson()).toList();
    }
    if (locationInfo != null) {
      data['locationInfo'] = locationInfo!.map((v) => v.toJson()).toList();
    }
    if (breakInfo != null) {
      data['breakInfo'] = breakInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is MeetingEventModel && id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class UpcomingDays {
  int? id;
  int? meetingEventId;
  int? dayId;
  String? endDate;
  int? updatedBy;
  String? updateDate;
  String? date;

  UpcomingDays(
      {this.id,
      this.meetingEventId,
      this.dayId,
      this.endDate,
      this.updatedBy,
      this.updateDate,
      this.date});

  UpcomingDays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    dayId = json['dayId'];
    endDate = json['endDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['meetingEventId'] = meetingEventId;
    data['dayId'] = dayId;
    data['endDate'] = endDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }
}

class UpcomingDates {
  int? id;
  int? meetingEventId;
  String? date;
  int? updatedBy;
  String? updateDate;
  String? creationDate;

  UpcomingDates(
      {this.id,
      this.meetingEventId,
      this.date,
      this.updatedBy,
      this.updateDate,
      this.creationDate});

  UpcomingDates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    date = json['date'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['meetingEventId'] = meetingEventId;
    data['date'] = date;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['creationDate'] = creationDate;
    return data;
  }
}

class LocationInfo {
  int? id;
  int? meetingEventId;
  String? latitude;
  String? longitude;
  double? radius;
  int? updatedBy;
  String? updateDate;
  String? date;

  LocationInfo({
    this.id,
    this.meetingEventId,
    this.latitude,
    this.longitude,
    this.radius,
    this.updatedBy,
    this.updateDate,
    this.date,
  });

  LocationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['meetingEventId'] = meetingEventId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['date'] = date;
    return data;
  }
}

class BreakInfo {
  int? id;
  int? meetingEventId;
  String? startBreak;
  String? endBreak;
  int? updatedBy;
  String? updateDate;
  String? date;

  BreakInfo(
      {this.id,
      this.meetingEventId,
      this.startBreak,
      this.endBreak,
      this.updatedBy,
      this.updateDate,
      this.date});

  BreakInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingEventId = json['meetingEventId'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meetingEventId'] = this.meetingEventId;
    data['startBreak'] = this.startBreak;
    data['endBreak'] = this.endBreak;
    data['updatedBy'] = this.updatedBy;
    data['updateDate'] = this.updateDate;
    data['date'] = this.date;
    return data;
  }
}
