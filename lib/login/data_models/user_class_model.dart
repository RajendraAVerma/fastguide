class UserClassData {
  UserClassData({
    required this.id,
    required this.userClass,
  });
  final String id;
  final String userClass;

  factory UserClassData.fromMap(Map<String, dynamic> data, String documentId) {
    final String userClass = data['userClass'];
    return UserClassData(
      id: documentId,
      userClass: userClass,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userClass': userClass,
    };
  }
}
