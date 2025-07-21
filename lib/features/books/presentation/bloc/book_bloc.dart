import 'package:bookify_book_rental/features/books/domain/entities/book_entity.dart';
import 'package:bookify_book_rental/features/books/domain/entities/rental_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_books_use_case.dart';
import '../../domain/usecases/search_books_use_case.dart';
import '../../domain/usecases/rent_book_use_case.dart';
import '../../domain/repositories/book_repository.dart';
part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetAllBooksUseCase getAllBooksUseCase;
  final SearchBooksUseCase searchBooksUseCase;
  final RentBookUseCase rentBookUseCase;
  final BookRepository bookRepository;

  BookBloc({
    required this.getAllBooksUseCase,
    required this.searchBooksUseCase,
    required this.rentBookUseCase,
    required this.bookRepository,
  }) : super(const BookInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadBookDetailsEvent>(_onLoadBookDetails);
    on<RentBookEvent>(_onRentBook);
    on<LoadUserRentalsEvent>(_onLoadUserRentals);
    on<AddBookEvent>(_onAddBook);
    on<UpdateBookEvent>(_onUpdateBook);
    on<DeleteBookEvent>(_onDeleteBook);
    on<LoadAllRentalsEvent>(_onLoadAllRentals);
    on<UpdateRentalStatusEvent>(_onUpdateRentalStatus);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await getAllBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BooksLoaded(books)),
    );
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await searchBooksUseCase(event.query);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BooksLoaded(books)),
    );
  }

  Future<void> _onLoadBookDetails(
    LoadBookDetailsEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.getBookById(event.bookId);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (book) => emit(BookDetailsLoaded(book)),
    );
  }

  Future<void> _onRentBook(RentBookEvent event, Emitter<BookState> emit) async {
    emit(const BookLoading());
    final result = await rentBookUseCase(
      userId: event.userId,
      bookId: event.bookId,
      rentalDate: event.rentalDate,
      dueDate: event.dueDate,
    );
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (rental) => emit(BookRented(rental)),
    );
  }

  Future<void> _onLoadUserRentals(
    LoadUserRentalsEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.getUserRentals(event.userId);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (rentals) => emit(UserRentalsLoaded(rentals)),
    );
  }

  Future<void> _onAddBook(AddBookEvent event, Emitter<BookState> emit) async {
    emit(const BookLoading());
    final result = await bookRepository.addBook(event.book);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (book) => emit(BookAdded(book)),
    );
  }

  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.updateBook(event.book);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (book) => emit(BookUpdated(book)),
    );
  }

  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.deleteBook(event.bookId);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (_) => emit(const BookDeleted()),
    );
  }

  Future<void> _onLoadAllRentals(
    LoadAllRentalsEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.getAllRentals();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (rentals) => emit(AllRentalsLoaded(rentals)),
    );
  }

  Future<void> _onUpdateRentalStatus(
    UpdateRentalStatusEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    final result = await bookRepository.updateRentalStatus(
      rentalId: event.rentalId,
      status: event.status,
      returnDate: event.returnDate,
    );
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (rental) => emit(RentalStatusUpdated(rental)),
    );
  }
}
