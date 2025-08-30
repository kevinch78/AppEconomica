import 'package:clean_architecture/data/repositories/user_repository_impl.dart';
import 'package:clean_architecture/domain/usecases/spent/add_fixed_expense.dart';
import 'package:clean_architecture/domain/usecases/spent/add_variable_expense.dart';
import 'package:clean_architecture/domain/usecases/spent/remove_expense.dart';
import 'package:clean_architecture/domain/usecases/user/get_user_by_id.dart';
import 'package:clean_architecture/domain/usecases/user/save_user.dart';
import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
import 'package:clean_architecture/presentation/bloc/user/user_event.dart' hide SaveUser, AddFixedExpense, AddVariableExpense, RemoveExpense;
import 'package:clean_architecture/presentation/pages/finance_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepositoryImpl();

    return MaterialApp(
      title: 'Presupuesto Amigable',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => UserBloc(
          saveUser: SaveUser(userRepository),
          getUserById: GetUserById(userRepository),
          addFixedExpense: AddFixedExpense(userRepository),
          addVariableExpense: AddVariableExpense(userRepository),
          removeExpense: RemoveExpense(userRepository),
        )..add(LoadUser()),  // Carga inicial
        child: const FinanceHomePage(),
      ),
    );
  }
}