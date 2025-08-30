import 'package:clean_architecture/domain/entities/spent.dart';
import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/presentation/bloc/user/user_bloc.dart';
import 'package:clean_architecture/presentation/bloc/user/user_event.dart';
import 'package:clean_architecture/presentation/bloc/user/user_state.dart';
import 'package:clean_architecture/presentation/widgets/settings_dialog.dart';
import 'package:clean_architecture/presentation/widgets/add_expense_dialog.dart';
import 'package:clean_architecture/presentation/widgets/delete_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FinanceHomePage extends StatelessWidget {
  const FinanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Mi Dinero 💰",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2196F3),
              ),
            );
          }
          
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${state.message}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUser());
                    },
                    child: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          }
          
          if (state is UserLoaded) {
            return _buildHomeContent(context, state.user);
          }
          
          return const Center(
            child: Text("Cargando..."),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, false),
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Agregar Gasto",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, User user) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, user, currencyFormat),
          const SizedBox(height: 24),
          _buildMainSummary(context, user, currencyFormat),
          const SizedBox(height: 24),
          _buildFixedExpenses(context, user, currencyFormat),
          const SizedBox(height: 24),
          _buildVariableExpenses(context, user, currencyFormat),
          const SizedBox(height: 100), // Espacio para FAB
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name.isNotEmpty ? "¡Hola ${user.name}! 👋" : "¡Hola! 👋",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tu resumen financiero del mes",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSummary(BuildContext context, User user, NumberFormat currencyFormat) {
    final remainingForFun = user.remainingForFun;
    final canReachGoal = user.canReachSavingsGoal;
    
    String message;
    Color messageColor;
    String emoji;
    
    if (remainingForFun >= 0) {
      if (canReachGoal) {
        message = "¡Excelente! Puedes alcanzar tu meta de ahorro 🎯";
        messageColor = Colors.green;
        emoji = "🎉";
      } else {
        message = "Te quedan ${currencyFormat.format(remainingForFun)} para tus gusticos";
        messageColor = Colors.orange;
        emoji = "🍔";
      }
    } else {
      message = "¡Cuidado! Has gastado más de lo que tienes";
      messageColor = Colors.red;
      emoji = "⚠️";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: messageColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Ya gastaste el ${user.spentPercentage.toStringAsFixed(0)}% de tu ingreso 👀",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow("Ingreso mensual", user.monthlyIncome, currencyFormat, Colors.blue),
          _buildSummaryRow("Gastos fijos", user.totalFixedExpenses, currencyFormat, Colors.red),
          _buildSummaryRow("Gastos variables", user.totalVariableExpenses, currencyFormat, Colors.orange),
          const Divider(height: 24),
          _buildSummaryRow("Saldo disponible", remainingForFun, currencyFormat,
              remainingForFun >= 0 ? Colors.green : Colors.red, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, NumberFormat currencyFormat, Color color, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            currencyFormat.format(amount),
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedExpenses(BuildContext context, User user, NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Gastos Fijos 🔒",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddFixedExpenseDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Agregar"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (user.fixedExpenses.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                "No hay gastos fijos configurados",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.fixedExpenses.length,
            itemBuilder: (context, index) => _buildExpenseCard(context, user.fixedExpenses[index], currencyFormat, true),
          ),
      ],
    );
  }

  Widget _buildVariableExpenses(BuildContext context, User user, NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Gastos Variables 🛒",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddVariableExpenseDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Agregar"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (user.variableExpenses.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                "No hay gastos variables registrados",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.variableExpenses.length,
            itemBuilder: (context, index) => _buildExpenseCard(context, user.variableExpenses[index], currencyFormat, false),
          ),
      ],
    );
  }

  Widget _buildExpenseCard(BuildContext context, Spent expense, NumberFormat currencyFormat, bool isFixed) {
    final Map<String, IconData> categoryIcons = {
      'Alimentación': Icons.food_bank,
      'Transporte': Icons.directions_car,
      'Entretenimiento': Icons.movie,
      'Salud': Icons.local_hospital,
      'Educación': Icons.school,
      'Vivienda': Icons.home,
      'Servicios': Icons.lightbulb,
      'Otros': Icons.category,
    };
    final icon = categoryIcons[expense.category] ?? Icons.category;

    return GestureDetector(
      onTap: () => _showEditExpenseDialog(context, expense, isFixed),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFixed ? Colors.red[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isFixed ? Colors.red : Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (expense.description.isNotEmpty)
                    Text(
                      expense.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(expense.date),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(expense.amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isFixed ? Colors.red : Colors.orange,
                  ),
                ),
                Text(
                  expense.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _showDeleteExpenseDialog(context, expense, isFixed),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(userBloc: userBloc),
    );
  }

  void _showAddExpenseDialog(BuildContext context, bool isFixed) {
    final userBloc = context.read<UserBloc>();
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        isFixed: isFixed,
        userBloc: userBloc,
        onSave: (expense) {
          if (isFixed) {
            userBloc.add(AddFixedExpenseEvent(expense));
          } else {
            userBloc.add(AddVariableExpenseEvent(expense));
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gasto agregado 🎉")),
          );
        },
      ),
    );
  }

  void _showAddFixedExpenseDialog(BuildContext context) {
    _showAddExpenseDialog(context, true);
  }

  void _showAddVariableExpenseDialog(BuildContext context) {
    _showAddExpenseDialog(context, false);
  }

  void _showDeleteExpenseDialog(BuildContext context, Spent expense, bool isFixed) {
    final userBloc = context.read<UserBloc>();
    showDialog(
      context: context,
      builder: (context) => DeleteExpenseDialog(
        expense: expense,
        isFixed: isFixed,
        userBloc: userBloc,
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context, Spent expense, bool isFixed) {
    final userBloc = context.read<UserBloc>();
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        isFixed: isFixed,
        editingExpense: expense,
        userBloc: userBloc,
        onSave: (updatedExpense) {
          userBloc.add(RemoveExpense(expense.id, isFixed));
          if (isFixed) {
            userBloc.add(AddFixedExpenseEvent(updatedExpense));
          } else {
            userBloc.add(AddVariableExpenseEvent(updatedExpense));
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gasto actualizado ✅")),
          );
        },
      ),
    );
  }
}