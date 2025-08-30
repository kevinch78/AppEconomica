
import 'package:clean_architecture/domain/entities/spent.dart';

abstract class SpentRepository {
  Future<void> addSpent(Spent spent);
  Future<List<Spent>> getFixedSpends();
  Future<List<Spent>> getVariableSpends();
  Future<void> clearVariableSpends();
}