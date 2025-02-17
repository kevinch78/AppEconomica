import 'package:clean_architecture/domain/entities/product.dart';
import 'package:clean_architecture/presentation/bloc/product_bloc.dart';
import 'package:clean_architecture/presentation/bloc/product_event.dart';
import 'package:clean_architecture/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<ProductBloc>().add(
                            DeleteProductEvent(product.id),
                          );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No products'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final product = Product(
            id: const Uuid().v4(),
            name: 'New Product ${DateTime.now().millisecondsSinceEpoch}',
            price: 99.99,
            description: 'A new product description',
          );
          context.read<ProductBloc>().add(AddProduct(product));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
