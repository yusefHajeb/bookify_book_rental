import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration functionality
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<UserEntity> execute({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    if (!_isValidName(name)) {
      throw ArgumentError('الاسم يجب ان يحتوي على حرفين على الاقل');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('خطأ في تنسييق  الايميل');
    }

    if (!_isValidPassword(password)) {
      throw ArgumentError(
        'كلمة المرور يجب ان تحتوي على 8 احرف منها حرف كبير ورقم',
      );
    }

    if (!_isValidRole(role)) {
      throw ArgumentError('الصلاحية لا يمكن ان تكون سوى مشرف او مستخدم');
    }

    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      return user;
    } catch (e) {
      // Re-throw with more specific error message
      throw Exception('خطأ: ${e.toString()}');
    }
  }

  /// Validates name format
  bool _isValidName(String name) {
    if (name.length < 2) return false;

    return true;
  }

  /// Validates email format using regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  bool _isValidPassword(String password) {
    if (password.length < 8) return false;

    if (!password.contains(RegExp(r'[A-Z]'))) return false;

    if (!password.contains(RegExp(r'[a-z]'))) return false;

    if (!password.contains(RegExp(r'[0-9]'))) return false;

    return true;
  }

  bool _isValidRole(String role) {
    const validRoles = ['user', 'admin'];
    return validRoles.contains(role.toLowerCase());
  }
}
