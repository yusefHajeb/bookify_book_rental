import 'package:bookify_book_rental/core/routes/routes.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_in.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/book_entity.dart';
import '../bloc/book_bloc.dart';

class BookDetailsScreen extends StatelessWidget {
  final BookEntity book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الكتاب')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildTabletLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedFadeScale(
            child: BookImage(book: book, context: context),
          ),
          SizedBox(height: 16.h),
          AnimatedFadeIn(
            delay: const Duration(milliseconds: 300),
            child: BookInfo(book: book, context: context),
          ),
          SizedBox(height: 24.h),
          AnimatedFadeIn(
            delay: const Duration(milliseconds: 600),
            child: RentButton(book: book, context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AnimatedFadeScale(
              child: BookImage(book: book, context: context),
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: BookInfo(book: book, context: context),
                ),
                SizedBox(height: 24.h),
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 600),
                  child: RentButton(book: book, context: context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RentButton extends StatelessWidget {
  const RentButton({super.key, required this.book, required this.context});

  final BookEntity book;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listener: (context, state) {
        if (state is BookRented) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تقديم طلب تأجير الكتاب بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is BookError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: book.isAvailable
              ? () {
                  context.go(Routes.bookingFlowPage, extra: book);
                }
              : null,

          child: Text(
            book.isAvailable ? 'حجز الكتاب' : 'غير متوفر',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}

class BookInfo extends StatelessWidget {
  const BookInfo({super.key, required this.book, required this.context});

  final BookEntity book;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedFadeScale(child: Text(book.title)),
        SizedBox(height: 8.h),
        AnimatedFadeScale(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'للكاتب ${book.author}',
            style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
          ),
        ),
        SizedBox(height: 16.h),
        AnimatedFadeIn(
          delay: const Duration(milliseconds: 800),
          child: Row(
            children: [
              Icon(Icons.star, size: 20.sp, color: Colors.amber),
              SizedBox(width: 4.w),
              Text(book.rating.toStringAsFixed(1)),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: book.isAvailable ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  book.isAvailable ? 'متوفر' : 'غير متوفر',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'الوصف',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(book.description),
      ],
    );
  }
}

class BookImage extends StatelessWidget {
  const BookImage({super.key, required this.book, required this.context});

  final BookEntity book;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          book.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.book, size: 80.sp, color: Colors.grey[600]),
            );
          },
        ),
      ),
    );
  }
}
