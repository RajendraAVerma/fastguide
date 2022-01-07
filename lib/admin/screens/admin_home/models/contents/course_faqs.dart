class CourseFAQs {
  CourseFAQs({
    required this.id,
    required this.faqsNo,
    required this.question,
    required this.answer,
  });

  final String id;
  final int faqsNo;
  final String question;
  final String answer;

  factory CourseFAQs.fromMap(Map<String, dynamic> data, String documentId) {
    final int faqsNo = data['faqsNo'];
    final String question = data['question'];
    final String answer = data['answer'];
    return CourseFAQs(
      id: documentId,
      faqsNo: faqsNo,
      question: question,
      answer: answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'faqsNo': faqsNo,
      'question': question,
      'answer': answer,
    };
  }
}
