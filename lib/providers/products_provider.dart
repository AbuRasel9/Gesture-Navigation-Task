import 'package:flutter/foundation.dart';
import 'package:gesture_coordination_task/repository/home_api/product_repository_impl.dart';
import '../model/product_list/product.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<String> _categories = [];
  bool _loading = false;
  String? _error;

  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;


  List<Product> productsForTab(String tabKey) {
    if (tabKey == 'all') return _allProducts;
    return _allProducts.where((p) => p.category == tabKey).toList();
  }

  Future<void> loadAll() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        ProductRepositoryImpl().getProducts(),
        ProductRepositoryImpl().getCategories(),
      ]);
      _allProducts = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadAll();
}
