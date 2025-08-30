

// import 'package:clean_architecture/domain/entities/spent.dart';
// import 'package:clean_architecture/domain/repositories/spent_repository.dart';

// class SpentRepositoryImpl implements SpentRepository {
//   static const String _fixedKey = 'fixed_spends';
//   static const String _variableKey = 'variable_spends';

//   @override
//   Future<void> addSpent(Spent spent) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = spent.isFixed ? _fixedKey : _variableKey;
//     final spends = prefs.getStringList(key)?.map((s) => Spent.fromJson(s)).toList() ?? [];
//     spends.add(spent);
//     await prefs.setStringList(key, spends.map((s) => s.toJson()).toString());
//   }

//   @override
//   Future<List<Spent>> getFixedSpends() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_fixedKey)?.map((s) => Spent.fromJson(s)).toList() ?? [];
//   }

//   @override
//   Future<List<Spent>> getVariableSpends() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_variableKey)?.map((s) => Spent.fromJson(s)).toList() ?? [];
//   }

//   @override
//   Future<void> clearVariableSpends() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_variableKey);
//   }
// }