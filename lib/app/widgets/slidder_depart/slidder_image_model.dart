class SlidderModel {
  SlidderModel({
    required this.id,
    required this.imageLink,
    required this.link,
  });
  final String id;
  final String imageLink;
  final String link;

  factory SlidderModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String imageLink = data['imageLink'];
    final String link = data['link'];
    return SlidderModel(
      id: documentId,
      imageLink: imageLink,
      link: link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageLink': imageLink,
      'link': link
    };
  }
}
