import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/entities/spent.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class SaveUserEvent extends UserEvent {  // Renombrado
  final User user;
  SaveUserEvent(this.user);
}

class UpdateUserIncome extends UserEvent {
  final double income;
  UpdateUserIncome(this.income);
}

class UpdateUserSavingsGoal extends UserEvent {
  final double goal;
  UpdateUserSavingsGoal(this.goal);
}

class UpdateUserSettings extends UserEvent {
  final double income;
  final double savingsGoal;
  UpdateUserSettings(this.income, this.savingsGoal);
}

class AddFixedExpenseEvent extends UserEvent {  // Renombrado
  final Spent expense;
  AddFixedExpenseEvent(this.expense);
}

class AddVariableExpenseEvent extends UserEvent {  // Renombrado
  final Spent expense;
  AddVariableExpenseEvent(this.expense);
}

class RemoveExpense extends UserEvent {
  final String expenseId;
  final bool isFixed;
  RemoveExpense(this.expenseId, this.isFixed);
}

class ResetMonth extends UserEvent {}