import 'package:clean_architecture/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteProduct(id);
  }
}
