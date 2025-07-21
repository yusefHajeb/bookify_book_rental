import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failures.dart';
import '../repositories/book_repository.dart';

class DeleteBookUseCase {
  final BookRepository repository;

  DeleteBookUseCase(this.repository);

  Future<Either<Failure, void>> call(int bookId) async {
    return await repository.deleteBook(bookId);
  }
}
