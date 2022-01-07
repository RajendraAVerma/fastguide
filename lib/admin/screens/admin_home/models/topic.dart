class Topic {
  Topic({
    required this.id,
    required this.lock,
    required this.topicName,
    required this.topicNo,
    required this.totalLecture,
    required this.introLink,
    required this.iconLink,
  });
  final String id;
  final int lock;
  final String topicName;
  final int topicNo;
  final int totalLecture;
  final String introLink;
  final String iconLink;

  factory Topic.fromMap(Map<String, dynamic> data, String documentId) {
    final String topicName = data['topic_name'];
    final int lock = data['lock'];
    final int totalLecture = data['totalLecture'];
    final int topicNo = data['topicNo'];
    final String introLink = data['introLink'];
    final String iconLink = data['iconLink'];

    return Topic(
      id: documentId,
      lock: lock,
      topicName: topicName,
      totalLecture: totalLecture,
      iconLink: iconLink,
      introLink: introLink,
      topicNo: topicNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic_name': topicName,
      'lock': lock,
      'topicNo': topicNo,
      'totalLecture': totalLecture,
      'introLink': introLink,
      'iconLink': iconLink,
    };
  }
}
