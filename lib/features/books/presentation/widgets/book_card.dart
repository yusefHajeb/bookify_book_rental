import 'package:bookify_book_rental/core/utils/animated_fade_in.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/book_entity.dart';

class BookCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    book.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.book,
                          size: 48.sp,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedFadeIn(
                      delay: Duration(milliseconds: 200),
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 14.sp,

                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    AnimatedFadeScale(
                      duration: Duration(milliseconds: 400),
                      child: Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    AnimatedFadeScale(
                      duration: Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 16.sp, color: Colors.amber),
                          SizedBox(width: 4.w),
                          Text(
                            book.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: book.isAvailable
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: AnimatedFadeScale(
                              duration: Duration(seconds: 1),
                              child: Text(
                                book.isAvailable ? 'متوفر' : 'مستأجر',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
