// import 'package:clean_architecture/domain/entities/spent.dart';
// import 'package:clean_architecture/domain/entities/user.dart';

// class Summary {
//   final List<Spent> spends;
//   final String month;
//   final String year;

//   Summary({
//     required this.spends,
//     required this.month,
//     required this.year,
//   });

//   double get totalSpent {
//     return spends.fold(0, (sum, item) => sum + item.amount);
//   }

//   double get fixedExpenses {
//     return spends
//         .where((s) => s.isFixedExpenses)
//         .fold(0, (sum, s) => sum + s.amount);
//   }

//   double get variableExpenses {
//     return spends
//         .where((s) => !s.isFixedExpenses)
//         .fold(0, (sum, s) => sum + s.amount);
//   }

//   /// Saldo disponible después de gastos y ahorro
//   double availableBalance(User user) {
//     return user.monthlyIncome - totalSpent - user.savingsGoal;
//   }

//   /// Verifica si el usuario alcanzó su meta de ahorro
//   bool reachedGoal(User user) {
//     final balance = user.monthlyIncome - totalSpent;
//     return balance >= user.savingsGoal;
//   }
// }
