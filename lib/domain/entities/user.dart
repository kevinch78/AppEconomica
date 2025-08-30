import 'package:uuid/uuid.dart';
import 'package:clean_architecture/domain/entities/spent.dart';

class User {
  final String id;
  final String name;
  final double monthlyIncome;
  final double savingsGoal;
  final List<Spent> fixedExpenses;
  final List<Spent> variableExpenses;
  final int lastResetMonth;  // Nueva: para reset auto (mes del último reset)

  User({
    String? id,
    this.name = '',
    this.monthlyIncome = 0,
    this.savingsGoal = 0,
    List<Spent>? fixedExpenses,
    List<Spent>? variableExpenses,
    int? lastResetMonth,
  })  : id = id ?? const Uuid().v4(),
        fixedExpenses = fixedExpenses ?? [],
        variableExpenses = variableExpenses ?? [],
        lastResetMonth = lastResetMonth ?? DateTime.now().month;

  double get totalFixedExpenses => fixedExpenses.fold(0, (sum, expense) => sum + expense.amount);
  double get totalVariableExpenses => variableExpenses.fold(0, (sum, expense) => sum + expense.amount);
  double get totalExpenses => totalFixedExpenses + totalVariableExpenses;
  double get remainingForFun => monthlyIncome - totalExpenses;
  bool get canReachSavingsGoal => remainingForFun >= savingsGoal;
  double get spentPercentage => monthlyIncome > 0 ? (totalExpenses / monthlyIncome) * 100 : 0;  // Nueva: %

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'monthlyIncome': monthlyIncome,
        'savingsGoal': savingsGoal,
        'fixedExpenses': fixedExpenses.map((e) => e.toJson()).toList(),
        'variableExpenses': variableExpenses.map((e) => e.toJson()).toList(),
        'lastResetMonth': lastResetMonth,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? const Uuid().v4(),
      name: json['name'] ?? '',
      monthlyIncome: json['monthlyIncome']?.toDouble() ?? 0,
      savingsGoal: json['savingsGoal']?.toDouble() ?? 0,
      fixedExpenses: (json['fixedExpenses'] as List<dynamic>?)?.map((e) => Spent.fromJson(e)).toList() ?? [],
      variableExpenses: (json['variableExpenses'] as List<dynamic>?)?.map((e) => Spent.fromJson(e)).toList() ?? [],
      lastResetMonth: json['lastResetMonth'] ?? DateTime.now().month,
    );
  }

  User copyWith({
    String? id,
    String? name,
    double? monthlyIncome,
    double? savingsGoal,
    List<Spent>? fixedExpenses,
    List<Spent>? variableExpenses,
    int? lastResetMonth,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      fixedExpenses: fixedExpenses ?? this.fixedExpenses,
      variableExpenses: variableExpenses ?? this.variableExpenses,
      lastResetMonth: lastResetMonth ?? this.lastResetMonth,
    );
  }
}