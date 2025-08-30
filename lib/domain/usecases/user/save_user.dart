import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';  // Corregido

class SaveUser {
  final UserRepository userRepository;

  SaveUser(this.userRepository);

  Future<void> execute(User user) async {
    await userRepository.saveUser(user);
  }
}