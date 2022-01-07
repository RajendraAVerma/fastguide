class UserData {
  UserData({
    required this.id,
    required this.userName,
    required this.address,
    required this.email,
    required this.mobileNo,
    required this.registerDate,
  });
  final String id;
  final String userName;
  final String address;
  final String email;
  final String mobileNo;
  final String registerDate;

  factory UserData.fromMap(Map<String, dynamic> data, String documentId) {
    final String userName = data['userName'];
    final String mobileNo = data['mobileNo'];
    final String email = data['email'];
    final String address = data['address'];
    final String registerDate = data['registerDate'];
    return UserData(
      id: documentId,
      userName: userName,
      mobileNo: mobileNo,
      email: email,
      address: address,
      registerDate: registerDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'mobileNo': mobileNo,
      'email': email,
      'address': address,
      'registerDate': registerDate,
    };
  }
}
