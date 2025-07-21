import 'dart:io';

import 'package:bookify_book_rental/core/routes/routes.dart';
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
          BookImage(book: book, context: context),
          SizedBox(height: 16.h),
          BookInfo(book: book, context: context),
          SizedBox(height: 24.h),
          RentButton(book: book, context: context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: BookImage(book: book, context: context),
          ),
          SizedBox(width: 24.w),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookInfo(book: book, context: context),
                SizedBox(height: 24.h),
                RentButton(book: book, context: context),
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
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            book.isAvailable ? 'حجز الكتاب' : 'غير متوفر',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
        Text(
          book.title,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'by ${book.author}',
          style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(Icons.star, size: 20.sp, color: Colors.amber),
            SizedBox(width: 4.w),
            Text(
              book.rating.toStringAsFixed(1),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
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
        SizedBox(height: 16.h),
        Text(
          'Description',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(book.description, style: TextStyle(fontSize: 14.sp, height: 1.5)),
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
        child: Image.file(
          File(book.imageUrl),
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
