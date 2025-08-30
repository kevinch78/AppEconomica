import 'package:clean_architecture/domain/usecases/spent/add_fixed_expense.dart' as expense_usecase;
import 'package:clean_architecture/domain/usecases/spent/add_variable_expense.dart' as variable_usecase;
import 'package:clean_architecture/domain/usecases/spent/remove_expense.dart' as remove_usecase;
import 'package:clean_architecture/domain/usecases/user/get_user_by_id.dart';
import 'package:clean_architecture/domain/usecases/user/save_user.dart' as user_usecase;
import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
import 'package:clean_architecture/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final user_usecase.SaveUser saveUser;
  final GetUserById getUserById;
  final expense_usecase.AddFixedExpense addFixedExpense;
  final variable_usecase.AddVariableExpense addVariableExpense;
  final remove_usecase.RemoveExpense removeExpense;

  UserBloc({
    required this.saveUser,
    required this.getUserById,
    required this.addFixedExpense,
    required this.addVariableExpense,
    required this.removeExpense,
  }) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<SaveUserEvent>(_onSaveUser);
    on<UpdateUserIncome>(_onUpdateUserIncome);
    on<UpdateUserSavingsGoal>(_onUpdateUserSavingsGoal);
    on<UpdateUserSettings>(_onUpdateUserSettings);
    on<AddFixedExpenseEvent>(_onAddFixedExpense);
    on<AddVariableExpenseEvent>(_onAddVariableExpense);
    on<RemoveExpense>(_onRemoveExpense);
    on<ResetMonth>(_onResetMonth);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      var user = await getUserById.execute('current_user');
      final currentMonth = DateTime.now().month;
      if (user.lastResetMonth != currentMonth) {
        user = user.copyWith(
          variableExpenses: [],
          lastResetMonth: currentMonth,
        );
        await saveUser.execute(user);
      }
      print('Loaded user from repository: ${user.toJson()}');
      emit(UserLoaded(user));
    } catch (e) {
      print('Error loading user: $e');
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSaveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await saveUser.execute(event.user);
      print('Saved user: ${event.user.toJson()}');
      emit(UserLoaded(event.user));
    } catch (e) {
      print('Error saving user: $e');
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserIncome(UpdateUserIncome event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(monthlyIncome: event.income);
      print('Attempting to save user with new income: ${updatedUser.toJson()}');
      await saveUser.execute(updatedUser);
      print('Successfully saved user with income: ${updatedUser.toJson()}');
      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onUpdateUserSavingsGoal(UpdateUserSavingsGoal event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(savingsGoal: event.goal);
      print('Attempting to save user with new savings goal: ${updatedUser.toJson()}');
      await saveUser.execute(updatedUser);
      print('Successfully saved user with savings goal: ${updatedUser.toJson()}');
      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onUpdateUserSettings(UpdateUserSettings event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(
        monthlyIncome: event.income,
        savingsGoal: event.savingsGoal,
      );
      print('Attempting to save user with new settings: ${updatedUser.toJson()}');
      await saveUser.execute(updatedUser);
      print('Successfully saved user with new settings: ${updatedUser.toJson()}');
      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onAddFixedExpense(AddFixedExpenseEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      print('Adding fixed expense: ${event.expense.toJson()}');
      final currentUser = (state as UserLoaded).user;
      final updatedUser = await addFixedExpense(currentUser, event.expense);
      await saveUser.execute(updatedUser);
      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onAddVariableExpense(AddVariableExpenseEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      print('Adding variable expense: ${event.expense.toJson()}');
      final currentUser = (state as UserLoaded).user;
      final updatedUser = await addVariableExpense(currentUser, event.expense);
      await saveUser.execute(updatedUser);
      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onRemoveExpense(RemoveExpense event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      print('Removing expense with id: ${event.expenseId}, isFixed: ${event.isFixed}');
      final currentUser = (state as UserLoaded).user;
      final updatedUser = await removeExpense(currentUser, event.expenseId, event.isFixed);
      if (updatedUser != null) {
        await saveUser.execute(updatedUser);
        emit(UserLoaded(updatedUser));
      } else {
        print('No expense found to remove with id: ${event.expenseId}');
      }
    }
  }

  Future<void> _onResetMonth(ResetMonth event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(
        variableExpenses: [],
      );
      await saveUser.execute(updatedUser);
      print('Reset month, cleared variable expenses');
      emit(UserLoaded(updatedUser));
    }
  }
}