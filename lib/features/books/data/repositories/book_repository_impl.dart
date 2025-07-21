import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failures.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/entities/rental_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_data_source.dart';
import '../models/book_model.dart';
import '../models/rental_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource localDataSource;

  BookRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    try {
      final books = await localDataSource.getAllBooks();
      return Right(books);
    } catch (e) {
      log('خطأ في جلب كل الكتب: $e');
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    try {
      final books = await localDataSource.searchBooks(query);
      return Right(books);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> getBookById(int id) async {
    try {
      final book = await localDataSource.getBookById(id);
      if (book != null) {
        return Right(book);
      } else {
        return Left(DatabaseFailure('لايوجد كتب'));
      }
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> addBook(BookEntity book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      final result = await localDataSource.insertBook(bookModel);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> updateBook(BookEntity book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      final result = await localDataSource.updateBook(bookModel);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(int id) async {
    try {
      await localDataSource.deleteBook(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalEntity>> rentBook({
    required int userId,
    required int bookId,
    required DateTime rentalDate,
    required DateTime dueDate,
  }) async {
    try {
      final isAvailable = await localDataSource.isBookAvailable(bookId);
      if (!isAvailable) {
        return Left(DatabaseFailure('Book is not available'));
      }

      final rental = RentalModel(
        userId: userId,
        bookId: bookId,
        rentalDate: rentalDate,
        dueDate: dueDate,
        status: RentalStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await localDataSource.insertRental(rental);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RentalEntity>>> getUserRentals(int userId) async {
    try {
      final rentals = await localDataSource.getUserRentals(userId);
      return Right(rentals);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RentalEntity>>> getAllRentals() async {
    try {
      final rentals = await localDataSource.getAllRentals();
      return Right(rentals);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalEntity>> updateRentalStatus({
    required int rentalId,
    required RentalStatus status,
    DateTime? returnDate,
  }) async {
    try {
      final rental = await localDataSource.getRentalById(rentalId);
      if (rental == null) {
        return Left(DatabaseFailure('لا يوجد كتب مؤجره'));
      }

      final updatedRental = rental.copyWith(
        status: status,
        returnDate: returnDate,
        updatedAt: DateTime.now(),
      );

      final result = await localDataSource.updateRental(updatedRental);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalEntity>> getRentalById(int id) async {
    try {
      final rental = await localDataSource.getRentalById(id);
      if (rental != null) {
        return Right(rental);
      } else {
        return Left(DatabaseFailure('Rental not found'));
      }
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookAvailable(int bookId) async {
    try {
      final isAvailable = await localDataSource.isBookAvailable(bookId);
      return Right(isAvailable);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
