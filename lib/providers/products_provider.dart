import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/models/http_exceptions.dart';
import 'package:flutter_course_shop_app/providers/auth.dart';
import 'package:flutter_course_shop_app/providers/product.dart';
import 'package:http/http.dart';

class Products with ChangeNotifier {
  static const String firebaseUrl = 'fluttercourse-viskum-default-rtdb.europe-west1.firebasedatabase.app';
  static const String firebaseCollection = 'products';
  String? _token;
  String _userId = "default";

  final List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  bool showFavorites = false;

  void setShowFavorites(bool flag) {
    showFavorites = flag;
    notifyListeners();
  }

  List<Product> get items {
    // return [..._items];
    return _items;
  }

  List<Product> get filteredItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Map<String, Object> toJSON(
    String title,
    String description,
    double price,
    String imageUrl,
    /* bool isFavorite */
  ) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      // 'isFavorite': isFavorite,
    };
  }

  Future<void> addProduct(Product product) async {
    // return post(
    try {
      final firebaseUri = Uri.https(firebaseUrl, firebaseCollection + '.json', {'auth': _token});
      final response = await post(
        firebaseUri,
        body: json.encode(
          toJSON(
            product.title,
            product.description,
            product.price,
            product.imageUrl,
            // product.isFavorite,
          ),
        ),
        // ).then((response) {
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }

    // }).catchError((error) {
    //   print(error);
    //   throw error;
    // });
  }

  Future<void> fetchProducts() async {
    try {
      final firebaseUri = Uri.https(firebaseUrl, firebaseCollection + '.json', {'auth': _token});
      final response = await get(firebaseUri);
      final jsonData = json.decode(response.body) as Map<String, dynamic>?;
      final firebaseFavoriteUri = Uri.https(firebaseUrl, 'favorite/$_userId.json', {'auth': _token});
      final favoriteResponse = await get(firebaseFavoriteUri);
      final favoriteJsonData = json.decode(favoriteResponse.body) as Map<String, dynamic>?;
      _items.clear();
      if (jsonData == null) return;
      jsonData.forEach((key, value) {
        _items.add(
          Product(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite: favoriteJsonData == null ? false : favoriteJsonData[key] ?? false),
        );
      });
      print(json.decode(response.body));
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final prodIdx = _items.indexWhere((element) => element.id == product.id);
    if (prodIdx < 0) return;
    final Uri firebaseDocUri = Uri.https(firebaseUrl, firebaseCollection + '/${product.id}.json', {'auth': _token});
    await patch(
      firebaseDocUri,
      body: json.encode(
        toJSON(
          product.title,
          product.description,
          product.price,
          product.imageUrl,
          // product.isFavorite,
        ),
      ),
    );
    _items[prodIdx] = product;
    notifyListeners();
  }

  void deleteProduct(String id) {
    // final prodIdx = _items.indexWhere((element) => element.id == id);
    // if (prodIdx < 0) return;
    // _items.removeAt(prodIdx);
    // _items.remove(product);
    final Uri firebaseDocUri = Uri.https(firebaseUrl, firebaseCollection + '/$id.json', {'auth': _token});
    final existingProductIdx = _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingProductIdx];
    _items.removeWhere((e) => e.id == id);
    delete(firebaseDocUri).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete Product');
      }
    }).catchError((_) {
      _items.insert(existingProductIdx, existingProduct);
    });
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateAuth(Auth auth) async {
    _token = auth.token;
    _userId = auth.userId ?? "default";

    if (_token == null) {
      _items.clear();
      notifyListeners();
    } else {
      await fetchProducts();
    }
    print('Products updateAuth called');
  }

  Products() {
    print('Products constructor called');
    // fetchProducts();
  }
}
