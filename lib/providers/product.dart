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

  void toggleFavorite(String? token, String userId) {
    if (token == null) return;

    final Uri firebaseDocUri = Uri.https(firebaseUrl, firebaseCollection + '/$id.json', {'auth': token});
    final Uri firebaseFavoriteUri = Uri.https(firebaseUrl, 'favorite/$userId.json', {'auth': token});

    final _oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    patch(
      firebaseFavoriteUri,
      body: json.encode({
        id: isFavorite,
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
