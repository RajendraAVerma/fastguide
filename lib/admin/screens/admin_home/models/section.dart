class Section {
  Section({
    required this.id,
    required this.sectionName,
    required this.totalSection,
    required this.sectionNo,
  });
  final String id;
  final String sectionName;
  final int totalSection;
  final int sectionNo;

  factory Section.fromMap(Map<String, dynamic> data, String documentId) {
    final String sectionName = data['sectionName'];
    final int totalSection = data['totalSection'];
    final int sectionNo = data['sectionNo'];
    return Section(
        id: documentId,
        sectionName: sectionName,
        totalSection: totalSection,
        sectionNo: sectionNo);
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'totalSection': totalSection,
      'sectionNo': sectionNo,
    };
  }
}
