import 'dart:convert';
import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  static const String _userKey = 'user';

  
  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final encoded = jsonEncode(user.toJson());
      await prefs.setString(_userKey, encoded);
      print('User saved successfully: $encoded'); // Log para depuración
    } catch (e) {
      print('Error saving user: $e');
      throw Exception('Failed to save user: $e');
    }
  }

  @override
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final jsonMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(jsonMap);
        print('User loaded successfully: ${user.toJson()}'); // Log para depuración
        return user;
      } catch (e) {
        print('Error parsing user JSON: $e');
        return User();
      }
    }
    print('No user found, returning default User');
    return User();
  }
}