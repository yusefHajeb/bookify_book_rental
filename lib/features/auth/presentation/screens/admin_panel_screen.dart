import 'package:bookify_book_rental/core/utils/animated_fade_in.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/presentation/bloc/book_bloc.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../../../books/domain/entities/rental_entity.dart';
import '../../../books/presentation/widgets/book_card.dart';
import '../../../books/presentation/widgets/rental_card.dart';
import '../widgets/book_dialog.dart';
import '../widgets/rental_status_dialog.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data loading
    context.read<BookBloc>()..add(const LoadBooksEvent());

    return DefaultTabController(
      length: 2,
      child: BlocListener<BookBloc, BookState>(
        listener: (context, state) {
          if (state is BookAdded ||
              state is BookUpdated ||
              state is BookDeleted ||
              state is RentalStatusUpdated) {
            // Refresh data after any CRUD operation
            context.read<BookBloc>()
              ..add(const LoadBooksEvent())
              ..add(const LoadAllRentalsEvent());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
            elevation: 2,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
            bottom: TabBar(
              indicatorWeight: 3,
              tabs: [
                Tab(
                  icon: AnimatedFadeScale(child: const Icon(Icons.book)),
                  text: 'Books',
                ),
                Tab(
                  icon: AnimatedFadeScale(
                    child: const Icon(Icons.receipt_long),
                  ),
                  text: 'Rentals',
                ),
              ],
            ),
          ),
          body: const TabBarView(children: [_BooksTab(), _RentalsTab()]),
          floatingActionButton: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);
              return AnimatedBuilder(
                animation: tabController,
                builder: (context, child) {
                  return tabController.index == 0
                      ? FloatingActionButton.extended(
                          onPressed: () => _showAddBookDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Book'),
                        )
                      : const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BooksTab extends StatelessWidget {
  const _BooksTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BooksLoaded) {
          return GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];
              return AnimatedFadeIn(
                delay: Duration(milliseconds: index * 100),
                child: BookCard(
                  book: book,
                  onTap: () => _showEditBookDialog(context, book),
                ),
              );
            },
          );
        } else if (state is BookError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  'خطأ في تحميل الكتب',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  state.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<BookBloc>().add(const LoadBooksEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        return Center(child: Text('لا توجد كتب متاحة ${state.runtimeType}'));
      },
    );
  }
}

class _RentalsTab extends StatelessWidget {
  const _RentalsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllRentalsLoaded) {
          if (state.rentals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No rentals yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Rentals will appear here when users rent books',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: state.rentals.length,
            itemBuilder: (context, index) {
              final rental = state.rentals[index];
              return RentalCard(
                rental: rental,
                onTap: () => _showUpdateStatusDialog(context, rental),
              );
            },
          );
        } else if (state is BookError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  'Error loading rentals',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  state.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<BookBloc>().add(const LoadAllRentalsEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Center(child: Text('No rentals available ${state.runtimeType}'));
      },
    );
  }
}

void _showAddBookDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          controller: scrollController,
          child: BookDialog(),
        ),
      ),
    ),
  );
}

void _showEditBookDialog(BuildContext context, BookEntity book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<BookBloc>(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 1,
          minChildSize: 0.3,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: BookDialog(book: book),
            );
          },
        ),
      ),
    ),
  );
}

void _showUpdateStatusDialog(BuildContext context, RentalEntity rental) {
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<BookBloc>(),
      child: RentalStatusDialog(
        rental: rental,
        // You can pass book title and user name if available
        // bookTitle: 'Book Title',
        // userName: 'User Name',
      ),
    ),
  );
}
