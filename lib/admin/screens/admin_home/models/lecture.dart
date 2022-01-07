class Lecture {
  Lecture({
    required this.id,
    required this.lectureName,
    required this.lectureNo,
    required this.lectureType,
    required this.lectureIcon,
    required this.lectureVideoLink,
    required this.lectureButtonLink1,
    required this.lectureButtonLink2,
    required this.lectureButtonLink3,
    required this.lectureDiscription,
  });
  final String id;
  final String lectureName;
  final int lectureNo;
  final int lectureType;
  final String lectureIcon;
  final String lectureVideoLink;
  final String lectureButtonLink1;
  final String lectureButtonLink2;
  final String lectureButtonLink3;
  final String lectureDiscription;

  factory Lecture.fromMap(Map<String, dynamic> data, String documentId) {
    final String lectureName = data['lecture_name'];
    final int lectureNo = data['lectureNo'];
    final int lectureType = data['lectureType'];
    final String lectureIcon = data['lectureIcon'];
    final String lectureVideoLink = data['lectureVideoLink'];
    final String lectureButtonLink1 = data['lectureButtonLink1'];
    final String lectureButtonLink2 = data['lectureButtonLink2'];
    final String lectureButtonLink3 = data['lectureButtonLink3'];
    final String lectureDiscription = data['lectureDiscription'];
    return Lecture(
      id: documentId,
      lectureName: lectureName,
      lectureNo: lectureNo,
      lectureType: lectureType,
      lectureIcon: lectureIcon,
      lectureVideoLink: lectureVideoLink,
      lectureButtonLink1: lectureButtonLink1,
      lectureButtonLink2: lectureButtonLink2,
      lectureButtonLink3: lectureButtonLink3,
      lectureDiscription: lectureDiscription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lecture_name': lectureName,
      'lectureNo': lectureNo,
      'lectureType': lectureType,
      'lectureIcon': lectureIcon,
      'lectureVideoLink': lectureVideoLink,
      'lectureButtonLink1': lectureButtonLink1,
      'lectureButtonLink2': lectureButtonLink2,
      'lectureButtonLink3': lectureButtonLink3,
      'lectureDiscription': lectureDiscription,
    };
  }
}
