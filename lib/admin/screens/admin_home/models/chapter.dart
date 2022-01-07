class Chapter {
  Chapter({
    required this.id,
    required this.chapterName,
    required this.chapterNo,
    required this.totalTopic,
    required this.totalLecture,
  });
  final String id;
  final String chapterName;
  final int chapterNo;
  final int totalTopic;
  final int totalLecture;

  factory Chapter.fromMap(Map<String, dynamic> data, String documentId) {
    final String chapterName = data['chapter_name'];
    final int chapterNo = data['chapterNo'];
    final int totalTopic = data['totalTopic'];
    final int totalLecture = data['totalLecture'];
    return Chapter(
      id: documentId,
      chapterName: chapterName,
      chapterNo: chapterNo,
      totalTopic: totalTopic,
      totalLecture: totalLecture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapter_name': chapterName,
      'chapterNo': chapterNo,
      'totalTopic': totalTopic,
      'totalLecture': totalLecture,
    };
  }
}
