class ChapterContent {
  ChapterContent({
    required this.id,
    required this.contentNo,
    required this.title,
    required this.type,
    required this.time,
    required this.link,
  });
  
  final String id;
  final int contentNo;
  final String title;
  final int type;
  final String time;
  final String link;

  factory ChapterContent.fromMap(Map<String, dynamic> data, String documentId) {
    final int contentNo = data['contentNo'];
    final String title = data['title'];
    final int type = data['type'];
    final String link = data['link'];
    final String time = data['time'];
    return ChapterContent(
      id: documentId,
      contentNo: contentNo,
      title: title,
      type: type,
      link: link,
      time: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentNo': contentNo,
      'title': title,
      'type': type,
      'link': link,
      'time': time,
    };
  }
}
