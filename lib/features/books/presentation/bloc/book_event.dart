part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BookEvent {
  const LoadBooksEvent();
}

class SearchBooksEvent extends BookEvent {
  final String query;

  const SearchBooksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadBookDetailsEvent extends BookEvent {
  final int bookId;

  const LoadBookDetailsEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class RentBookEvent extends BookEvent {
  final int userId;
  final int bookId;
  final DateTime rentalDate;
  final DateTime dueDate;

  const RentBookEvent({
    required this.userId,
    required this.bookId,
    required this.rentalDate,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [userId, bookId, rentalDate, dueDate];
}

class LoadUserRentalsEvent extends BookEvent {
  final int userId;

  const LoadUserRentalsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddBookEvent extends BookEvent {
  final BookEntity book;

  const AddBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class UpdateBookEvent extends BookEvent {
  final BookEntity book;

  const UpdateBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class DeleteBookEvent extends BookEvent {
  final int bookId;

  const DeleteBookEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class LoadAllRentalsEvent extends BookEvent {
  const LoadAllRentalsEvent();
}

class UpdateRentalStatusEvent extends BookEvent {
  final int rentalId;
  final RentalStatus status;
  final DateTime? returnDate;

  const UpdateRentalStatusEvent({
    required this.rentalId,
    required this.status,
    this.returnDate,
  });

  @override
  List<Object?> get props => [rentalId, status, returnDate];
}
