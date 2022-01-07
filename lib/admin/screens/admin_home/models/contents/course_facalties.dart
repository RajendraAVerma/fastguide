class CourseFaculties {
  CourseFaculties({
    required this.id,
    required this.facultieNo,
    required this.name,
    required this.mobileNo,
    required this.imageLink,
    required this.courseName,
    required this.tag,
  });

  final String id;
  final int facultieNo;
  final String name;
  final String mobileNo;
  final String imageLink;
  final String courseName;
  final String tag;

  factory CourseFaculties.fromMap(
      Map<String, dynamic> data, String documentId) {
    final int facultieNo = data['facultieNo'];
    final String name = data['name'];
    final String mobileNo = data['mobileNo'];
    final String imageLink = data['imageLink'];
    final String courseName = data['courseName'];
    final String tag = data['tag'];
    return CourseFaculties(
      id: documentId,
      facultieNo: facultieNo,
      name: name,
      mobileNo: mobileNo,
      imageLink: imageLink,
      courseName: courseName,
      tag: tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'facultieNo': facultieNo,
      'name': name,
      'mobileNo': mobileNo,
      'imageLink': imageLink,
      'courseName': courseName,
      'tag': tag,
    };
  }
}
