import 'package:clean_architecture/domain/entities/spent.dart';
import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
import 'package:flutter/material.dart';

class AddExpenseDialog extends StatefulWidget {
  final bool isFixed;
  final Spent? editingExpense;
  final UserBloc userBloc; // Nuevo parámetro
  final Function(Spent)? onSave;

  const AddExpenseDialog({
    super.key,
    this.isFixed = false,
    this.editingExpense,
    required this.userBloc,
    this.onSave,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Otros';

  final List<String> _categories = [
    'Alimentación',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Vivienda',
    'Servicios',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingExpense != null) {
      _nameController.text = widget.editingExpense!.name;
      _amountController.text = widget.editingExpense!.amount.toString();
      _descriptionController.text = widget.editingExpense!.description;
      _selectedCategory = widget.editingExpense!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editingExpense == null
          ? (widget.isFixed ? "Agregar Gasto Fijo" : "Agregar Gasto Variable")
          : "Editar Gasto"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del gasto",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: "Monto (\$)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Categoría",
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descripción (opcional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
            final name = _nameController.text.trim();
            final amount = double.tryParse(_amountController.text);
            
            if (name.isEmpty || amount == null || amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Por favor completa todos los campos correctamente"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            
            final expense = Spent(
              name: name,
              amount: amount,
              isFixed: widget.isFixed,
              category: _selectedCategory,
              description: _descriptionController.text.trim(),
            ).copyWith(id: widget.editingExpense?.id); // Preserve ID if editing
            
            if (widget.onSave != null) {
              widget.onSave!(expense);
            } else if (widget.editingExpense == null) {
              if (widget.isFixed) {
                widget.userBloc.add(AddFixedExpenseEvent(expense));
              } else {
                widget.userBloc.add(AddVariableExpenseEvent(expense));
              }
            }
            
            Navigator.of(context).pop();
          },
          child: Text(widget.editingExpense == null ? "Agregar" : "Guardar"),
        ),
      ],
    );
  }
}