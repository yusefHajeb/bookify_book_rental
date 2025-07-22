import 'dart:async';
import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/core/theme/theme_card.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_in.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_scale.dart';
import 'package:bookify_book_rental/core/widgets/app_test_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/book_entity.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(const LoadBooksEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        context.read<BookBloc>().add(const LoadBooksEvent());
      } else {
        context.read<BookBloc>().add(SearchBooksEvent(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(Routes.profilePage);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),

          ThemeCard(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AnimatedFadeScale(
              child: AppTextFormField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: 'ابحث ب اسم الكتاب أو الكاتب...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                prefixIcon: AnimatedFadeScale(
                  duration: const Duration(milliseconds: 560),
                  child: const Icon(Icons.search),
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BooksLoaded) {
                  if (state.books.isEmpty) {
                    return const Center(child: Text('لا يوجد كتب!'));
                  }
                  return _BookGrid(books: state.books);
                } else if (state is BookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(': ${state.message}'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BookBloc>().add(
                              const LoadBooksEvent(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('Welcome to Bookify!'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({required this.books});

  final List<BookEntity> books;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return AnimatedFadeIn(
              delay: Duration(milliseconds: index * 100),
              child: BookCard(
                book: books[index],
                onTap: () {
                  context.push(Routes.bookDetailsPage, extra: books[index]);
                },
              ),
            );
          },
        );
      },
    );
  }
}
