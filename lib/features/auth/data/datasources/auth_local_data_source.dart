import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Local data source for authentication using SQLite
/// Handles all database operations for user authentication
class AuthLocalDataSource {
  static final AuthLocalDataSource _instance = AuthLocalDataSource._internal();
  Database? _database;

  factory AuthLocalDataSource() => _instance;

  AuthLocalDataSource._internal();

  /// Gets the database instance, initializing if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bookify.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            role TEXT NOT NULL DEFAULT 'user',
            createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
      version: 1,
    );
  }

  /// Inserts a new user into the database
  Future<UserModel> insertUser(UserModel user, String password) async {
    final db = await database;

    // Hash the password before storing
    final hashedPassword = _hashPassword(password);

    // Prepare user data for insertion
    final userData = user.toMapForInsertion();
    userData['password'] = hashedPassword;

    try {
      final id = await db.insert('users', userData);
      return user.copyWith(id: id);
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('الايميل موجود بالفعل');
      }
      throw Exception('فشل في انشاء المستخدم: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    final db = await database;

    final hashedPassword = _hashPassword(password);

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  /// Retrieves a user by ID
  Future<UserModel?> getUserById(int id) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  Future<void> updatePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    final db = await database;

    // Verify current password
    final user = await getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    final currentHashedPassword = _hashPassword(currentPassword);
    final result = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, currentHashedPassword],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('كلمة المرور الحالية غير صحيحة');
    }

    final newHashedPassword = _hashPassword(newPassword);
    await db.update(
      'users',
      {'password': newHashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Gets all users (admin functionality)
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;

    final result = await db.query('users', orderBy: 'createdAt DESC');

    return result.map((map) => UserModel.fromMap(map)).toList();
  }

  /// Hashes password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /*******  9daf14da-35bd-4ffd-bf62-cd86969f09c5  *******/
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
