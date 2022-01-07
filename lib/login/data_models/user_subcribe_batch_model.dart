class UserSubcribedBatch {
  UserSubcribedBatch({
    required this.id,
    required this.userBatch,
  });
  final String id;
  final String userBatch;

  factory UserSubcribedBatch.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String userBatch = data['userBatch'];
    return UserSubcribedBatch(
      id: documentId,
      userBatch: userBatch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userBatch': userBatch,
    };
  }
}
