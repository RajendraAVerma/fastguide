class UserStatusData {
  UserStatusData({
    required this.id,
    required this.status,
  });
  final String id;
  final String status;

  factory UserStatusData.fromMap(Map<String, dynamic> data, String documentId) {
    final String status = data['status'];
    return UserStatusData(
      id: documentId,
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
    };
  }
}
