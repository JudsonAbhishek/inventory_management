import 'package:flutter/material.dart';

import 'items.dart';

class ItemProvider with ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  // Add item to the list
  void addItem(Item newItem) {
    _items.add(newItem);
    notifyListeners(); // Notify listeners of changes
  }

  // Decrement the quantity of an item
  void decrementQuantity(int index) {
    if (_items[index].quantity > 0) {
      _items[index].quantity--;
      notifyListeners(); // Notify listeners of changes
    }
  }

  // Increment the quantity of an item
  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners(); // Notify listeners of changes
  }
}
