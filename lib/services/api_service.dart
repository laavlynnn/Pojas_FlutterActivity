import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String apiUrl =
      'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['products'];

      return products
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}