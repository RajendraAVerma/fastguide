class CodeRedeemUser {
  CodeRedeemUser({
    required this.id,
    required this.mobileNo,
    required this.userName,
    required this.date,
  });
  final String id;
  final int mobileNo;
  final String userName;
  final String date;
  factory CodeRedeemUser.fromMap(Map<String, dynamic> data, String documentId) {
    final int mobileNo = data['mobileNo'];
    final String userName = data['userName'];
    final String date = data['date'];

    return CodeRedeemUser(
      id: documentId,
      mobileNo: mobileNo,
      userName: userName,
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobileNo': mobileNo,
      'userName': userName,
      'date': date,
    };
  }
}
