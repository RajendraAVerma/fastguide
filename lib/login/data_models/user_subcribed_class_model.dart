class UserSubcribedClassData {
  UserSubcribedClassData({
    required this.id,
    required this.userSubcribedBatch,
    required this.userSubcribedCourse,
    required this.date,
    required this.payment,
  });
  final String id;
  final String userSubcribedBatch;
  final String userSubcribedCourse;
  final String date;
  final String payment;

  factory UserSubcribedClassData.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String userSubcribedBatch = data['userSubcribedBatch'];
    final String userSubcribedCourse = data['userSubcribedCourse'];
    final String date = data['date'];
    final String payment = data['payment'];
    return UserSubcribedClassData(
      id: documentId,
      userSubcribedBatch: userSubcribedBatch,
      userSubcribedCourse: userSubcribedCourse,
      date: date,
      payment: payment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userSubcribedBatch': userSubcribedBatch,
      'userSubcribedCourse': userSubcribedCourse,
      'date': date,
      'payment': payment,
    };
  }
}
