import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  static const String firebaseUrl = 'fluttercourse-viskum-default-rtdb.europe-west1.firebasedatabase.app';
  static const String firebaseCollection = '/products';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  void toggleFavorite() {
    final Uri firebaseDocUri = Uri.https(firebaseUrl, firebaseCollection + '/$id.json');

    final _oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    patch(
      firebaseDocUri,
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    ).then((result) {
      print(result.statusCode);
      if (result.statusCode >= 400) {
        isFavorite = _oldStatus;
        notifyListeners();
      }
    }).catchError((_) {
      isFavorite = _oldStatus;
      notifyListeners();
    });
  }

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
}
