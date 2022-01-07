class Course {
  Course({
    required this.id,
    required this.courseName,
    required this.courseMRP,
    required this.courseSellingPrice,
    required this.totalChapter,
    required this.themeColor1,
    required this.themeColor2,
    required this.boxIconLink,
    required this.thumnailLink,
    required this.teacher,
  });

  final String id;
  final String courseName;
  final int totalChapter;
  final int courseMRP;
  final int courseSellingPrice;
  // design ----
  final String themeColor1;
  final String themeColor2;
  final String boxIconLink;
  final String thumnailLink;
  final String teacher;

  factory Course.fromMap(Map<String, dynamic> data, String documentId) {
    final String courseName = data['course_name'];
    final int tatalChapter = data['tatalChapter'];
    final int courseMRP = data['courseMRP'];
    final int courseSellingPrice = data['courseSellingPrice'];
    final String themeColor1 = data['themeColor1'];
    final String themeColor2 = data['themeColor2'];
    final String boxIconLink = data['boxIconLink'];
    final String thumnailLink = data['thumnailLink'];
    final String teacher = data['teacher'];
    return Course(
      id: documentId,
      courseName: courseName,
      totalChapter: tatalChapter,
      courseMRP: courseMRP,
      courseSellingPrice: courseSellingPrice,
      boxIconLink: boxIconLink,
      teacher: teacher,
      themeColor1: themeColor1,
      themeColor2: themeColor2,
      thumnailLink: thumnailLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_name': courseName,
      'courseMRP': courseMRP,
      'courseSellingPrice': courseSellingPrice,
      'tatalChapter': totalChapter,
      'boxIconLink': boxIconLink,
      'teacher': teacher,
      'themeColor1': themeColor1,
      'themeColor2': themeColor2,
      'thumnailLink': thumnailLink,
    };
  }
}
