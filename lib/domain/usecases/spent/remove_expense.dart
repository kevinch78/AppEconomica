import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';  // Corregido

class RemoveExpense {
  final UserRepository repository;

  RemoveExpense(this.repository);

  Future<User> call(User user, String expenseId, bool isFixed) async {
    if (isFixed) {
      final updatedFixedExpenses = user.fixedExpenses.where((expense) => expense.id != expenseId).toList();
      final updatedUser = user.copyWith(fixedExpenses: updatedFixedExpenses);
      await repository.saveUser(updatedUser);
      return updatedUser;
    } else {
      final updatedVariableExpenses = user.variableExpenses.where((expense) => expense.id != expenseId).toList();
      final updatedUser = user.copyWith(variableExpenses: updatedVariableExpenses);
      await repository.saveUser(updatedUser);
      return updatedUser;
    }
  }
}