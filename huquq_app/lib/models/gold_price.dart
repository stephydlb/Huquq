class GoldPrice {
  final double pricePerGram;
  final String currency;
  final DateTime lastUpdated;

  GoldPrice({
    required this.pricePerGram,
    required this.currency,
    required this.lastUpdated,
  });

  double get pricePerKilo => pricePerGram * 1000;
  double get pricePerMithqal => pricePerGram * 4.25; // Mithqal ≈ 4.25g

  factory GoldPrice.fromJson(Map<String, dynamic> json) {
    return GoldPrice(
      pricePerGram: json['price_per_gram'] ?? 0.0,
      currency: json['currency'] ?? 'EUR',
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_per_gram': pricePerGram,
      'currency': currency,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
