import 'package:flutter/foundation.dart';
import '../Merchant Sign Up/merchant_structure.dart';

class CheckoutState extends ChangeNotifier {
  final Map<MenuItem, int> _itemsWithQuantity = {};
  int _totalQuantity = 0;

  Map<MenuItem, int> get itemsWithQuantity => _itemsWithQuantity;

  // Calculate total price dynamically based on itemsWithQuantity
  double get totalPrice {
    double total = 0;
    _itemsWithQuantity.forEach((item, quantity) {
      total += item.price * quantity; // Assuming MenuItem has a price field
    });
    return double.parse(
        total.toStringAsFixed(2)); // Format to two decimal places
  }

  int get totalQuantity {
    _totalQuantity = itemsWithQuantity.values.fold(0, (sum, quantity) => sum + quantity);
    return _totalQuantity;
  }

  // Add or increase quantity of an item
  void addItem(MenuItem menuItem) {
    if (_itemsWithQuantity.containsKey(menuItem)) {
      _itemsWithQuantity[menuItem] = _itemsWithQuantity[menuItem]! + 1;
    } else {
      _itemsWithQuantity[menuItem] = 1;
    }
    notifyListeners();
  }

  // Remove or decrease quantity of an item
  void removeItem(MenuItem menuItem) {
    if (_itemsWithQuantity.containsKey(menuItem) &&
        _itemsWithQuantity[menuItem]! > 1) {
      _itemsWithQuantity[menuItem] = _itemsWithQuantity[menuItem]! - 1;
    } else {
      _itemsWithQuantity.remove(menuItem);
    }

    notifyListeners();
  }

  // Clear all items
  void clearCart() {
    _itemsWithQuantity.clear();
    notifyListeners();
  }
}
