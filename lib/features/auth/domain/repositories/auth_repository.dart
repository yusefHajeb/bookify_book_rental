import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Authenticates user with email and password
  /// Returns UserEntity if successful, throws exception if failed
  Future<UserEntity> login(String email, String password);

  /// Registers  new user
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();

  Future<bool> isLoggedIn();
}
