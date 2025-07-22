// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import '../../../../../lib/core/error_handler/failures.dart';
// import '../../../../../lib/features/books/domain/entities/book_entity.dart';
// import '../../../../../lib/features/books/domain/repositories/book_repository.dart';
// import '../../../../../lib/features/books/domain/usecases/add_book_use_case.dart';
// import 'add_book_use_case_test.mocks.dart';

// @GenerateNiceMocks([MockSpec<BookRepository>()])
// void main() {
//   late AddBookUseCase useCase;
//   late MockBookRepository mockRepository;

//   setUp(() {
//     mockRepository = MockBookRepository();
//     useCase = AddBookUseCase(mockRepository);
//   });

//   final tBook = BookEntity(
//     title: 'Test Book',
//     author: 'Test Author',
//     description: 'Test Description',
//     imageUrl: 'test.jpg',
//     rating: 4.5,
//     isAvailable: true,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   );

//   test('should add book to the repository', () async {
//     when(mockRepository.addBook(any)).thenAnswer((_) async => Right(tBook));

//     final result = await useCase(AddBookParams(book: tBook));

//     expect(result, Right(tBook));
//     verify(mockRepository.addBook(tBook));
//     verifyNoMoreInteractions(mockRepository);
//   });

//   test('should return failure when repository fails', () async {
//     final tFailure = DatabaseFailure('Add failed');
//     when(mockRepository.addBook(any)).thenAnswer((_) async => Left(tFailure));

//     final result = await useCase(AddBookParams(book: tBook));

//     expect(result, Left(tFailure));
//     verify(mockRepository.addBook(tBook));
//     verifyNoMoreInteractions(mockRepository);
//   });
// }
