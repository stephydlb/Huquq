import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gold_price.dart';

class GoldPriceService {
  static const String _apiUrl =
      'https://api.goldapi.io/api/XAU/EUR'; // Example API
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual key

  Future<GoldPrice?> fetchGoldPrice() async {
    // Check if cached price is recent (less than 1 hour old)
    final cachedPrice = await getCachedPrice();
    if (cachedPrice != null &&
        DateTime.now().difference(cachedPrice.lastUpdated).inHours < 1) {
      return cachedPrice;
    }

    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'x-access-token': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final price = GoldPrice.fromJson(data);
        await _savePrice(price);
        return price;
      }
    } catch (e) {
      // Error fetching gold price: $e
    }

    // Return cached price if API fails or if recent
    return cachedPrice;
  }

  Future<void> _savePrice(GoldPrice price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gold_price', json.encode(price.toJson()));
  }

  Future<GoldPrice?> getCachedPrice() async {
    final prefs = await SharedPreferences.getInstance();
    final priceJson = prefs.getString('gold_price');
    if (priceJson != null) {
      final data = json.decode(priceJson);
      return GoldPrice(
        pricePerGram: data['price_per_gram'],
        currency: data['currency'],
        lastUpdated: DateTime.parse(data['last_updated']),
      );
    }
    return null;
  }
}
