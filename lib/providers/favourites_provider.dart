import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavouritesProvider extends ChangeNotifier {
  List<Product> _favourites = [];

  List<Product> get favourites => [..._favourites];

  Future<void> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favString = prefs.getString('favourites');
    if (favString != null) {
      final List<dynamic> favJson = json.decode(favString);
      _favourites = favJson.map((json) => Product.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> toggleFavourite(Product product) async {
    final existingIndex = _favourites.indexWhere((p) => p.id == product.id);
    if (existingIndex >= 0) {
      _favourites.removeAt(existingIndex);
    } else {
      _favourites.add(product);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final favString = json.encode(_favourites.map((p) => _productToJson(p)).toList());
    await prefs.setString('favourites', favString);
  }

  bool isFavourite(int productId) {
    return _favourites.any((p) => p.id == productId);
  }

  Map<String, dynamic> _productToJson(Product product) {
    return {
      "id": product.id,
      "title": product.title,
      "price": product.price,
      "description": product.description,
      "category": product.category,
      "image": product.image,
      "rating": {"rate": product.rating, "count": product.ratingCount},
    };
  }
}
