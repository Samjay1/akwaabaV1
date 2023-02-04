class DeviceRequestModel {
  var memberAccountType;
  var systemDevice;
  var deviceType;
  var deviceId;
  var approved;
  var creationDate;

  DeviceRequestModel(this.memberAccountType, this.systemDevice, this.deviceType,
      this.deviceId, this.approved, this.creationDate);

  factory DeviceRequestModel.fromJson(Map<String, dynamic> json) {
    return DeviceRequestModel(
      json['memberAccountType'],
      json['systemDevice'],
      json['deviceType'],
      json['deviceId'],
      json['approved'],
      json['creationDate'],
    );
  }
}
