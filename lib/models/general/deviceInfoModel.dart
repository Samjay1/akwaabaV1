
class DeviceInfoModel{
  var systemDevice;
  var deviceType;
  var deviceId;

  DeviceInfoModel(
      this.systemDevice,this.deviceType,this.deviceId
      );

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoModel(
        json['systemDevice'],
        json['deviceType'],
        json['deviceId']);
  }
}