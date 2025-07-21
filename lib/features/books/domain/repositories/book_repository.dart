import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failures.dart';
import '../entities/book_entity.dart';
import '../entities/rental_entity.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks();
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query);
  Future<Either<Failure, BookEntity>> getBookById(int id);
  Future<Either<Failure, BookEntity>> addBook(BookEntity book);
  Future<Either<Failure, BookEntity>> updateBook(BookEntity book);
  Future<Either<Failure, void>> deleteBook(int id);
  Future<Either<Failure, RentalEntity>> rentBook({
    required int userId,
    required int bookId,
    required DateTime rentalDate,
    required DateTime dueDate,
  });
  Future<Either<Failure, List<RentalEntity>>> getUserRentals(int userId);
  Future<Either<Failure, List<RentalEntity>>> getAllRentals();
  Future<Either<Failure, RentalEntity>> updateRentalStatus({
    required int rentalId,
    required RentalStatus status,
    DateTime? returnDate,
  });
  Future<Either<Failure, RentalEntity>> getRentalById(int id);
  Future<Either<Failure, bool>> isBookAvailable(int bookId);
}
