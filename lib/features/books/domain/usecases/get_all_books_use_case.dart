import 'package:dartz/dartz.dart';

import '../../../../core/error_handler/failures.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetAllBooksUseCase {
  final BookRepository repository;

  GetAllBooksUseCase(this.repository);

  Future<Either<Failure, List<BookEntity>>> call() async {
    return await repository.getAllBooks();
  }
}
