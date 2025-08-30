import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
import 'package:clean_architecture/presentation/bloc/user/user_state.dart';
import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final UserBloc userBloc;

  const SettingsDialog({super.key, required this.userBloc});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final _incomeController = TextEditingController();
  final _savingsGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar con valores actuales desde el UserBloc
    if (widget.userBloc.state is UserLoaded) {
      final user = (widget.userBloc.state as UserLoaded).user;
      _incomeController.text = user.monthlyIncome.toStringAsFixed(0);
      _savingsGoalController.text = user.savingsGoal.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _savingsGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configuración"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _incomeController,
              decoration: const InputDecoration(
                labelText: "Ingreso mensual (\$)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _savingsGoalController,
              decoration: const InputDecoration(
                labelText: "Meta de ahorro (\$)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final income = double.tryParse(_incomeController.text) ?? 0.0;
            final savingsGoal = double.tryParse(_savingsGoalController.text) ?? 0.0;
            
            if (income < 0 || savingsGoal < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Los valores no pueden ser negativos"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            
            widget.userBloc.add(UpdateUserSettings(income, savingsGoal));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Configuración guardada ✅")),
            );
            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}