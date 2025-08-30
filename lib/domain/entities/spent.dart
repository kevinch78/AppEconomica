import 'package:uuid/uuid.dart';

class Spent {
  final String id;
  final String name;
  final double amount;
  final bool isFixed;
  final String category;
  final String description;
  final DateTime date;

  Spent({
    String? id,
    required this.name,
    required this.amount,
    this.isFixed = false,
    this.category = 'Otros',
    this.description = '',
    DateTime? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'isFixed': isFixed,
        'category': category,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory Spent.fromJson(Map<String, dynamic> json) => Spent(
        id: json['id'] ?? const Uuid().v4(),
        name: json['name'],
        amount: json['amount']?.toDouble() ?? 0,
        isFixed: json['isFixed'] ?? false,
        category: json['category'] ?? 'Otros',
        description: json['description'] ?? '',
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      );

  Spent copyWith({
    String? id,
    String? name,
    double? amount,
    bool? isFixed,
    String? category,
    String? description,
    DateTime? date,
  }) {
    return Spent(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isFixed: isFixed ?? this.isFixed,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}