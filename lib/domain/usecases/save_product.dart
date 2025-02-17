import 'package:clean_architecture/domain/entities/product.dart';
import 'package:clean_architecture/domain/repositories/product_repository.dart';

class SaveProduct {
  final ProductRepository repository;

  SaveProduct(this.repository);

  Future<void> execute(Product product) async {
    await repository.saveProduct(product);
  }
}
