import 'package:clean_architecture/domain/entities/spent.dart';
import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';  // Corregido

class AddFixedExpense {
  final UserRepository repository;

  AddFixedExpense(this.repository);

  Future<User> call(User user, Spent expense) async {
    final updatedUser = user.copyWith(
      fixedExpenses: [...user.fixedExpenses, expense],
    );
    await repository.saveUser(updatedUser);
    return updatedUser;
  }
}