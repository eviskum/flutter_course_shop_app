import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id, required this.title, required this.quantity, required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  List<CartItem> get itemsList {
    return _items.values.toList();
  }

  List<String> get keysList {
    return _items.keys.toList();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalSum {
    double sum = 0;
    _items.forEach((key, c) {
      sum += (c.quantity * c.price);
    });
    return sum;
  }

  void addItem(
    String id,
    double price,
    String title,
  ) {
    if (_items.containsKey(id)) {
      _items.update(id, (e) => CartItem(id: e.id, title: e.title, quantity: e.quantity + 1, price: e.price));
    } else {
      _items.putIfAbsent(id, () => CartItem(id: DateTime.now().toString(), title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSignleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
            price: existingItem.price),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
