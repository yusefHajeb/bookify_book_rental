import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book_model.dart';
import '../models/rental_model.dart';

class BookLocalDataSource {
  static final BookLocalDataSource _instance = BookLocalDataSource._internal();
  Database? _database;

  factory BookLocalDataSource() => _instance;
  BookLocalDataSource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bookie.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE books (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          description TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          rating REAL NOT NULL,
          isAvailable INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE rentals (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          bookId INTEGER NOT NULL,
          rentalDate TEXT NOT NULL,
          returnDate TEXT,
          status TEXT NOT NULL DEFAULT 'rented',
          FOREIGN KEY (userId) REFERENCES users (id),
          FOREIGN KEY (bookId) REFERENCES books (id)
        )
      ''');

        // Insert sample books
        await insertSampleBooks(db);
      },
    );
  }

  static Future<void> insertSampleBooks(Database db) async {
    final sampleBooks = [
      {
        'title': 'REMINDER OF HIM COLLEEN HOOVER',
        'author': 'ديفيد لودج',
        'description':
            'دليل شامل لفن كتابة القصص الخيالية، يغطي جوانب مثل تطوير الشخصية، وبناء الحبكة، وتقنيات السرد.',
        'imageUrl':
            'https://m.media-amazon.com/images/I/418HLIXlxCL._SY291_BO1,204,203,200_QL40_FMwebp_.jpg',
        'rating': 4.2,
        'isAvailable': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'title': 'الشركات الناشئة الهزيلة',
        'author': 'يوسف حاجب',
        'description':
            'نهج مبتكر لبناء وتنمية الشركات الناشئة، مع التركيز على التجريب السريع، والتعلم المعتمد، وتطوير المنتجات التكرارية.',
        'imageUrl':
            'https://m.media-amazon.com/images/I/51mFoFmu0EL._SY291_BO1,204,203,200_QL40_FMwebp_.jpg',
        'rating': 4.5,
        'isAvailable': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'title': '1984',
        'author': 'الاستاذ خالد فرحان',
        'description': 'الكتاب فقط للعرض',
        'imageUrl':
            'https://m.media-amazon.com/images/I/41pTqRlersL._SY291_BO1,204,203,200_QL40_FMwebp_.jpg',
        'rating': 4.4,
        'isAvailable': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    ];

    for (final book in sampleBooks) {
      await db.insert('books', book);
    }
  }

  Future<List<BookModel>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => BookModel.fromJson(maps[i]));
  }

  Future<List<BookModel>> searchBooks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => BookModel.fromJson(maps[i]));
  }

  Future<BookModel?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return BookModel.fromJson(maps.first);
    }
    return null;
  }

  Future<BookModel> insertBook(BookModel book) async {
    final db = await database;
    final id = await db.insert('books', book.toJson());
    return book.copyWith(id: id);
  }

  Future<BookModel> updateBook(BookModel book) async {
    final db = await database;
    await db.update(
      'books',
      book.toJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
    return book;
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<RentalModel> insertRental(RentalModel rental) async {
    final db = await database;
    final id = await db.insert('rentals', rental.toJson());
    return rental.copyWith(id: id);
  }

  Future<List<RentalModel>> getUserRentals(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rentals',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => RentalModel.fromJson(maps[i]));
  }

  Future<List<RentalModel>> getAllRentals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rentals');
    return List.generate(maps.length, (i) => RentalModel.fromJson(maps[i]));
  }

  Future<RentalModel> updateRental(RentalModel rental) async {
    final db = await database;
    await db.update(
      'rentals',
      rental.toJson(),
      where: 'id = ?',
      whereArgs: [rental.id],
    );
    return rental;
  }

  Future<RentalModel?> getRentalById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rentals',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return RentalModel.fromJson(maps.first);
    }
    return null;
  }

  Future<bool> isBookAvailable(int bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ? AND isAvailable = 1',
      whereArgs: [bookId],
    );
    return maps.isNotEmpty;
  }
}
