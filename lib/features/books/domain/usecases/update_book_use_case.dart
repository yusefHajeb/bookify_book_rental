import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error_handler/failures.dart';
import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class UpdateBookUseCase implements UseCase<BookEntity, UpdateBookParams> {
  final BookRepository repository;

  UpdateBookUseCase(this.repository);

  @override
  Future<Either<Failure, BookEntity>> call(UpdateBookParams params) async {
    return await repository.updateBook(params.book);
  }
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class UpdateBookParams extends Equatable {
  final BookEntity book;

  const UpdateBookParams({required this.book});

  @override
  List<Object> get props => [book];
}
