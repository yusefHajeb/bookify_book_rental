import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error_handler/failures.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class AddBookUseCase implements UseCase<BookEntity, AddBookParams> {
  final BookRepository repository;

  AddBookUseCase(this.repository);

  @override
  Future<Either<Failure, BookEntity>> call(AddBookParams params) async {
    return await repository.addBook(params.book);
  }
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class AddBookParams extends Equatable {
  final BookEntity book;

  const AddBookParams({required this.book});

  @override
  List<Object> get props => [book];
}
