import 'package:flutter/foundation.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amount, required this.products, required this.dateTime});
}

class Orders extends ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  void addOrder(List<CartItem> cartProducts, double totalSum) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: totalSum,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
