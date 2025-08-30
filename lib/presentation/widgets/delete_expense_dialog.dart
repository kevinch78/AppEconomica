import 'package:clean_architecture/domain/entities/spent.dart';
import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
import 'package:flutter/material.dart';

class DeleteExpenseDialog extends StatelessWidget {
  final Spent expense;
  final bool isFixed;
  final UserBloc userBloc;

  const DeleteExpenseDialog({
    super.key,
    required this.expense,
    required this.isFixed,
    required this.userBloc,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar Gasto"),
      content: Text("¿Estás seguro de que quieres eliminar '${expense.name}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            userBloc.add(RemoveExpense(expense.id, isFixed));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gasto eliminado 🚮")),
            );
            Navigator.of(context).pop();
          },
          child: const Text("Eliminar"),
        ),
      ],
    );
  }
}