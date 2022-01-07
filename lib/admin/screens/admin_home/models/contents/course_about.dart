class CourseAbout {
  CourseAbout({
    required this.id,
    required this.videoLink,
    required this.imgLink1,
    required this.imgLink2,
    required this.discription,
  });

  final String id;
  final String videoLink;
  final String imgLink1;
  final String imgLink2;
  final String discription;

  factory CourseAbout.fromMap(Map<String, dynamic> data, String documentId) {
    final String videoLink = data['videoLink'];
    final String imgLink1 = data['imgLink1'];
    final String imgLink2 = data['imgLink2'];
    final String discription = data['discription'];
    return CourseAbout(
      id: documentId,
      videoLink: videoLink,
      imgLink1: imgLink1,
      imgLink2: imgLink2,
      discription: discription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoLink': videoLink,
      'imgLink1': imgLink1,
      'imgLink2': imgLink2,
      'discription': discription,
    };
  }
}
