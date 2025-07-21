import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failures.dart';
import '../entities/rental_entity.dart';
import '../repositories/book_repository.dart';

class RentBookUseCase {
  final BookRepository repository;

  RentBookUseCase(this.repository);

  Future<Either<Failure, RentalEntity>> call({
    required int userId,
    required int bookId,
    required DateTime rentalDate,
    required DateTime dueDate,
  }) async {
    return await repository.rentBook(
      userId: userId,
      bookId: bookId,
      rentalDate: rentalDate,
      dueDate: dueDate,
    );
  }
}
