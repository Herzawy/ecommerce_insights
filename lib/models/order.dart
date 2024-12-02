class Order {
  final String id;
  final bool isActive;
  final double priceValue;
  final String company;
  final String picture;
  final String buyer;
  final List<String> tags;
  final String status;
  final String registered;

  Order({
    required this.id,
    required this.isActive,
    required this.priceValue,
    required this.company,
    required this.picture,
    required this.buyer,
    required this.tags,
    required this.status,
    required this.registered,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      isActive: json['isActive'] ?? false,
      priceValue: (json['price'] != null)
          ? double.tryParse(json['price'].replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0
          : 0.0,
      company: json['company'] as String,
      picture: json['picture'] as String,
      buyer: json['buyer'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] as String,
      registered: json['registered'] as String,
    );
  }
}
