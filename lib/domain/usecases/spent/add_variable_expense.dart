import 'package:clean_architecture/domain/entities/spent.dart';
import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';  // Corregido

class AddVariableExpense {
  final UserRepository repository;

  AddVariableExpense(this.repository);

  Future<User> call(User user, Spent expense) async {
    final updatedUser = user.copyWith(
      variableExpenses: [...user.variableExpenses, expense],
    );
    await repository.saveUser(updatedUser);
    return updatedUser;
  }
}