import 'package:clean_architecture/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(String id);
  Future<void> saveProduct(Product product);
  Future<void> deleteProduct(String id);
}
