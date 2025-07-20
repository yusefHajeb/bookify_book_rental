import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);
  Future<UserEntity> execute(String email, String password) async {
    // Validate input parameters
    if (!_isValidEmail(email)) {
      throw ArgumentError('خطأ في تنسيق الإيميل');
    }

    if (!_isValidPassword(password)) {
      throw ArgumentError('كلمة المرور يجب ان تحتوي على 6 احرف على الاقل');
    }

    try {
      final user = await _authRepository.login(email, password);
      return user;
    } catch (e) {
      throw Exception(' تسجيل الدخول فاشل : ${e.toString()}');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
