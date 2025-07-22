import 'package:bookify_book_rental/core/theme/cubit/theme_cubit.dart';
import 'package:bookify_book_rental/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookify_book_rental/features/books/data/datasources/book_local_data_source.dart';
import 'package:bookify_book_rental/features/books/data/repositories/book_repository_impl.dart';
import 'package:bookify_book_rental/features/books/domain/repositories/book_repository.dart';
import 'package:bookify_book_rental/features/books/domain/usecases/delete_book_use_case.dart';
import 'package:bookify_book_rental/features/books/domain/usecases/get_all_books_use_case.dart';
import 'package:bookify_book_rental/features/books/domain/usecases/rent_book_use_case.dart';
import 'package:bookify_book_rental/features/books/domain/usecases/search_books_use_case.dart';
import 'package:bookify_book_rental/features/books/domain/usecases/update_book_use_case.dart';
import 'package:bookify_book_rental/features/books/presentation/bloc/book_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));

  // Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<BookLocalDataSource>(() => BookLocalDataSource());

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(localDataSource: sl<BookLocalDataSource>()),
  );

  sl.registerLazySingleton<GetAllBooksUseCase>(
    () => GetAllBooksUseCase(sl<BookRepository>()),
  );

  sl.registerLazySingleton<SearchBooksUseCase>(
    () => SearchBooksUseCase(sl<BookRepository>()),
  );

  sl.registerLazySingleton<RentBookUseCase>(
    () => RentBookUseCase(sl<BookRepository>()),
  );

  sl.registerLazySingleton<DeleteBookUseCase>(
    () => DeleteBookUseCase(sl<BookRepository>()),
  );
  sl.registerLazySingleton<UpdateBookUseCase>(
    () => UpdateBookUseCase(sl<BookRepository>()),
  );
  sl.registerFactory<BookBloc>(
    () => BookBloc(
      deleteBookUseCase: sl<DeleteBookUseCase>(),
      updateBookUseCase: sl<UpdateBookUseCase>(),
      getAllBooksUseCase: sl<GetAllBooksUseCase>(),
      searchBooksUseCase: sl<SearchBooksUseCase>(),
      rentBookUseCase: sl<RentBookUseCase>(),
      bookRepository: sl<BookRepository>(),
    ),
  );

  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl<SharedPreferences>()));
}
