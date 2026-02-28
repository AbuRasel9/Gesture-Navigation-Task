import 'dart:convert';

import 'package:gesture_coordination_task/configs/app_url.dart';
import 'package:gesture_coordination_task/repository/home_api/product_repository.dart';
import 'package:http/http.dart'as http;

import '../../model/product_list/product.dart';

class ProductRepositoryImpl extends ProductRepository{
  @override
  Future<List<String>> getCategories() async {

    final res = await http.get(Uri.parse('${AppUrl.base}/products/categories'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.cast<String>();
    }
    throw Exception('Failed to get categories');

  }

  @override
  Future<List<Product>> getProducts() async {


    final res = await http.get(Uri.parse('${AppUrl.base}/products'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to get products');
  
  }

  @override
  Future<List<Product>>getProductsByCategory(String category) async {
    final res =
    await http.get(Uri.parse('${AppUrl.base}/products/category/$category'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to get products by category');



  }

}