part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {
  const BookInitial();
}

class BookLoading extends BookState {
  const BookLoading();
}

class BooksLoaded extends BookState {
  final List<BookEntity> books;

  const BooksLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BookDetailsLoaded extends BookState {
  final BookEntity book;

  const BookDetailsLoaded(this.book);

  @override
  List<Object?> get props => [book];
}

class BookRented extends BookState {
  final RentalEntity rental;

  const BookRented(this.rental);

  @override
  List<Object?> get props => [rental];
}

class UserRentalsLoaded extends BookState {
  final List<RentalEntity> rentals;

  const UserRentalsLoaded(this.rentals);

  @override
  List<Object?> get props => [rentals];
}

class BookAdded extends BookState {
  final BookEntity book;

  const BookAdded(this.book);

  @override
  List<Object?> get props => [book];
}

class BookUpdated extends BookState {
  final BookEntity book;

  const BookUpdated(this.book);

  @override
  List<Object?> get props => [book];
}

class BookDeleted extends BookState {
  const BookDeleted();
}

class AllRentalsLoaded extends BookState {
  final List<RentalEntity> rentals;

  const AllRentalsLoaded(this.rentals);

  @override
  List<Object?> get props => [rentals];
}

class RentalStatusUpdated extends BookState {
  final RentalEntity rental;

  const RentalStatusUpdated(this.rental);

  @override
  List<Object?> get props => [rental];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}
