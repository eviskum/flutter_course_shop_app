import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_course_shop_app/providers/auth.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';
import 'package:http/http.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amount, required this.products, required this.dateTime});
}

class Orders extends ChangeNotifier {
  static const String firebaseUrl = 'fluttercourse-viskum-default-rtdb.europe-west1.firebasedatabase.app';
  static const String firebaseCollection = 'orders';
  // final Uri firebaseUri = Uri.https(firebaseUrl, firebaseCollection + '.json');
  String? _token;
  String _userId = "default";

  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  Map<String, Object> productToJSON(CartItem cart) {
    return {
      'id': cart.id,
      'title': cart.title,
      'quantity': cart.quantity,
      'price': cart.price,
    };
  }

  Map<String, Object> toJSON(double amount, List<CartItem> products, DateTime dateTime) {
    return {
      'amount': amount,
      'products': products.map((e) => productToJSON(e)).toList(),
      'datetime': dateTime.toIso8601String(),
    };
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalSum) async {
    try {
      final firebaseUri = Uri.https(firebaseUrl, firebaseCollection + '/$_userId.json', {'auth': _token});
      final dateTime = DateTime.now();
      final response = await post(
        firebaseUri,
        body: json.encode(
          toJSON(
            totalSum,
            cartProducts,
            dateTime,
          ),
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalSum,
          products: cartProducts,
          dateTime: dateTime,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> fetchOrders() async {
    try {
      final firebaseUri = Uri.https(firebaseUrl, firebaseCollection + '/$_userId.json', {'auth': _token});
      final response = await get(firebaseUri);
      final jsonData = json.decode(response.body) as Map<String, dynamic>?;
      _orders.clear();
      if (jsonData == null) return;
      jsonData.forEach((key, value) {
        _orders.add(
          OrderItem(
            id: key,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map((e) => CartItem(id: e['id'], title: e['title'], quantity: e['quantity'], price: e['price']))
                .toList(),
            dateTime: DateTime.parse(value['datetime']),
          ),
        );
      });
      print(json.decode(response.body));
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  void updateAuth(Auth auth) async {
    _token = auth.token;
    _userId = auth.userId ?? "default";
    if (_token == null) {
      _orders.clear();
      notifyListeners();
    } else {
      await fetchOrders();
    }
    print('Orders updateAuth called');
  }

  Orders() {
    print('Orders constructor called');
    // fetchOrders();
  }
}
