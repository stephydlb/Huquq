import 'package:flutter/material.dart';
import '../models/gold_price.dart';
import '../services/gold_price_service.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  GoldPrice? _goldPrice;
  bool _isLoading = false;
  final GoldPriceService _goldService = GoldPriceService();

  GoldPrice? get goldPrice => _goldPrice;
  bool get isLoading => _isLoading;

  Future<void> loadGoldPrice() async {
    // Only show loading if we don't have cached data
    if (_goldPrice == null) {
      _isLoading = true;
      notifyListeners();
    }

    _goldPrice = await _goldService.fetchGoldPrice();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshGoldPrice() async {
    await loadGoldPrice();
    if (_goldPrice != null) {
      await NotificationService.showGoldPriceNotification(_goldPrice!);
    }
  }
}
