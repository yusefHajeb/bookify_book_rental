import 'package:bookify_book_rental/core/constants/app_constants.dart';
import 'package:bookify_book_rental/core/helper/sheard_prefrence_healper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Manages authentication using local (SQLite) data source only
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final SharedPreferences _sharedPreferences;
  AuthRepositoryImpl({
    required SharedPreferences sharedPreferences,
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _sharedPreferences = sharedPreferences;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user == null) {
        throw Exception('خطـأ في الايميل او كلمة المرور ');
      }

      if (user.id != null) {
        await SharedPrefrenceHelper.setData(AppConstants.userToken, user.id);
      }
      return user;
    } catch (e) {
      throw Exception('تسجيل دخول فاشل: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      final existingUser = await _localDataSource.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('الإيميل موجود ب الفعل');
      }

      final newUser = UserModel(
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );

      final createdUser = await _remoteDataSource
          .createUserWithEmailAndPassword(newUser: newUser, password: password);

      SharedPrefrenceHelper.setData(AppConstants.userToken, createdUser.id);

      return createdUser;
    } catch (e) {
      throw Exception('إنشاء حساب فاشل: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    _remoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userId = await _sharedPreferences.getInt(AppConstants.userToken);
    if (userId != null && userId != '') {
      return _localDataSource.getUserById(userId);
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedd = await SharedPrefrenceHelper.isUserLoggedIn();
    // log('isLoggedIn');
    print(isLoggedd);
    return isLoggedd;
  }
}
