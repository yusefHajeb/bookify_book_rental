import 'package:bookify_book_rental/core/helper/sheard_prefrence_healper.dart';

import '../models/user_model.dart';
import 'auth_local_data_source.dart';

/// now I use Mock data with SQLite
/// Remote data source for authentication
class AuthRemoteDataSource {
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _localDataSource.getUserByEmailAndPassword(email, password);
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required UserModel newUser,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _localDataSource.insertUser(newUser, password);
  }

  /// Simulates sign out
  Future<void> signOut() async {
    SharedPrefrenceHelper.clear();
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges {
    // For mock, return empty stream
    return const Stream.empty();
  }
}
