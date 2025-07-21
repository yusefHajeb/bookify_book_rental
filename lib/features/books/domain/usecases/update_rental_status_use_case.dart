import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error_handler/failures.dart';
import '../entities/rental_entity.dart';
import '../repositories/book_repository.dart';

class UpdateRentalStatusUseCase {
  final BookRepository repository;

  UpdateRentalStatusUseCase(this.repository);

  Future<Either<Failure, RentalEntity>> call(
    UpdateRentalStatusParams params,
  ) async {
    return await repository.updateRentalStatus(
      rentalId: params.rentalId,
      status: params.status,
      returnDate: params.returnDate,
    );
  }
}

class UpdateRentalStatusParams extends Equatable {
  final int rentalId;
  final RentalStatus status;
  final DateTime? returnDate;

  const UpdateRentalStatusParams({
    required this.rentalId,
    required this.status,
    this.returnDate,
  });

  @override
  List<Object?> get props => [rentalId, status, returnDate];
}
