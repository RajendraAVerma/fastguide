class UserDeviceData {
  UserDeviceData({
    required this.id,
    required this.mobileNo,
    required this.deviceManufacture,
    required this.deviceModel,
    required this.androidId,
    required this.lastLogin,
  });
  final String id;
  final String deviceManufacture;
  final String mobileNo;
  final String deviceModel;
  final String androidId;
  final String lastLogin;

  factory UserDeviceData.fromMap(Map<String, dynamic> data, String documentId) {
    final String deviceId = data['deviceId'];
    final String mobileNo = data['mobileNo'];
    final String deviceModel = data['deviceModel'];
    final String androidId = data['androidId'];
    final String lastLogin = data['lastLogin'];
    return UserDeviceData(
      id: documentId,
      deviceManufacture: deviceId,
      mobileNo: mobileNo,
      deviceModel: deviceModel,
      androidId: androidId,
      lastLogin: lastLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceManufacture,
      'mobileNo': mobileNo,
      'deviceModel': deviceModel,
      'androidId': androidId,
      'lastLogin': lastLogin,
    };
  }
}
