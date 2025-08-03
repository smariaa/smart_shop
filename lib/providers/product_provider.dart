import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

enum SortOption { priceLowToHigh, priceHighToLow, rating }

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _originalProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _selectedCategory;
  SortOption? _selectedSort;

  List<Product> get filteredProducts => [..._products];
  List<String> get categories => [..._categories];
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;
  SortOption? get selectedSort => _selectedSort;

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _categories = List<String>.from(data);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> fetchProducts({String? category}) async {
    _isLoading = true;
    notifyListeners();

    try {
      Uri url = category == null
          ? Uri.parse('https://fakestoreapi.com/products')
          : Uri.parse('https://fakestoreapi.com/products/category/$category');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _originalProducts = data.map((json) => Product.fromJson(json)).toList();
        _products = [..._originalProducts];

        _selectedCategory = category;
        _selectedSort = null;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  void sortBy(SortOption? option) {
    _selectedSort = option;

    _products = [..._originalProducts];

    if (option == SortOption.priceLowToHigh) {
      _products.sort((a, b) => a.price.compareTo(b.price));
    } else if (option == SortOption.priceHighToLow) {
      _products.sort((a, b) => b.price.compareTo(a.price));
    } else if (option == SortOption.rating) {
      _products.sort((a, b) => b.rating.compareTo(a.rating));
    }

    notifyListeners();
  }
}
