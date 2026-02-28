import '../../model/product_list/product.dart';

abstract class ProductRepository{
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
}