class Member {
  Member({
    required this.id,
    required this.memberName,
    required this.memberMobileNo,
    required this.couponCode,
    required this.percentage,
    required this.upi,
  });
  final String id;
  final String memberName;
  final String memberMobileNo;
  final String couponCode;
  final int percentage;
  final String upi;

  factory Member.fromMap(Map<String, dynamic> data, String documentId) {
    final String memberName = data['memberName'];
    final String memberMobileNo = data['memberMobileNo'];
    final String couponCode = data['couponCode'];
    final int percentage = data['percentage'];
    final String upi = data['upi'];
    return Member(
      id: documentId,
      memberName: memberName,
      memberMobileNo: memberMobileNo,
      couponCode: couponCode,
      percentage: percentage,
      upi: upi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'memberMobileNo': memberMobileNo,
      'couponCode': couponCode,
      'percentage': percentage,
      'upi': upi,
    };
  }
}
