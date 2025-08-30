import 'package:clean_architecture/domain/entities/user.dart';
import 'package:clean_architecture/domain/repositories/user_repository.dart';  // Corregido

class GetUserById {
  final UserRepository userRepository;

  GetUserById(this.userRepository);

  Future<User> execute(String id) async {
    return await userRepository.getUser();  // Ignora id, single user
  }
}