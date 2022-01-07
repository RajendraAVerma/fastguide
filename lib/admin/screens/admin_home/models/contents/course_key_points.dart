class CourseKeyPoints {
  CourseKeyPoints({
    required this.id,
    required this.keyPointsNo,
    required this.keyPoint,
  });

  final String id;
  final int keyPointsNo;
  final String keyPoint;

  factory CourseKeyPoints.fromMap(
      Map<String, dynamic> data, String documentId) {
    final int keyPointsNo = data['keyPointsNo'];
    final String keyPoint = data['keyPoint'];
    return CourseKeyPoints(
      id: documentId,
      keyPointsNo: keyPointsNo,
      keyPoint: keyPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keyPointsNo': keyPointsNo,
      'keyPoint': keyPoint,
    };
  }
}
