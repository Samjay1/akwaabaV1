class LeaveStatus {
  int? id;
  int? clientId;
  int? branchId;
  String? status;
  String? date;

  LeaveStatus({
    this.id,
    this.clientId,
    this.branchId,
    this.status,
    this.date,
  });

  LeaveStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    branchId = json['branchId'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['branchId'] = branchId;
    data['status'] = status;
    data['date'] = date;
    return data;
  }

  bool operator ==(dynamic other) =>
      other != null && other is LeaveStatus && id == other.id;

  @override
  int get hashCode => super.hashCode;
}
