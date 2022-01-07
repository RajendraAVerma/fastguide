class PaymentHistory {
  PaymentHistory({
    required this.id,
    required this.price,
    required this.date,
    required this.item,
  });
  final String id;
  final String price;
  final String date;
  final String item;

  factory PaymentHistory.fromMap(Map<String, dynamic> data, String documentId) {
    final String price = data['price'];
    final String date = data['date'];
    final String item = data['item'];
    return PaymentHistory(
      id: documentId,
      price: price,
      date: date,
      item: item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'date': date,
      'item': item,
    };
  }
}
