class Batch {
  Batch({
    required this.id,
    required this.batchName,
    required this.totalCourse,
    required this.themeColor1,
    required this.themeColor2,
    required this.boxIconLink,
    required this.thumnailLink,
    required this.tag,
  });
  final String id;
  final String batchName;
  final int totalCourse;
  // design ----
  final String themeColor1;
  final String themeColor2;
  final String boxIconLink;
  final String thumnailLink;
  final String tag;

  factory Batch.fromMap(Map<String, dynamic> data, String documentId) {
    final String batchName = data['batchName'];
    final int tatalCourse = data['tatalCourse'];
    final String themeColor1 = data['themeColor1'];
    final String themeColor2 = data['themeColor2'];
    final String boxIconLink = data['boxIconLink'];
    final String thumnailLink = data['thumnailLink'];
    final String tag = data['tag'];
    return Batch(
      id: documentId,
      batchName: batchName,
      totalCourse: tatalCourse,
      boxIconLink: boxIconLink,
      tag: tag,
      themeColor1: themeColor1,
      themeColor2: themeColor2,
      thumnailLink: thumnailLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batchName': batchName,
      'tatalCourse': totalCourse,
      'boxIconLink': boxIconLink,
      'tag': tag,
      'themeColor1': themeColor1,
      'themeColor2': themeColor2,
      'thumnailLink': thumnailLink,
    };
  }
}
