import 'package:clean_architecture/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User> getUser();
}