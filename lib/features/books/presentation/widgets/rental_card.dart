import 'package:bookify_book_rental/core/utils/animated_fade_in.dart';
import 'package:bookify_book_rental/core/utils/animated_fade_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/rental_entity.dart';

class RentalCard extends StatelessWidget {
  final RentalEntity rental;
  final VoidCallback onTap;

  const RentalCard({super.key, required this.rental, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedFadeScale(
      duration: const Duration(milliseconds: 350),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        elevation: 4,
        shadowColor: Colors.blueGrey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedFadeIn(
                  delay: Duration(milliseconds: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكتاب: #${rental.bookId}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      _buildStatusChip(rental.status),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                AnimatedFadeIn(
                  delay: Duration(milliseconds: 120),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18.sp,
                        color: Colors.indigo[400],
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'تاريخ الإيجار: ${_formatDate(rental.rentalDate)}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.indigo[400],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                AnimatedFadeIn(
                  delay: Duration(milliseconds: 160),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 18.sp,
                        color: Colors.deepOrange[400],
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'تاريخ الاستحقاق: ${_formatDate(rental.dueDate)}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: _isDueToday(rental.dueDate)
                              ? Colors.orange
                              : Colors.deepOrange[400],
                          fontWeight: _isDueToday(rental.dueDate)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (rental.returnDate != null) ...[
                  SizedBox(height: 6.h),
                  AnimatedFadeIn(
                    delay: Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18.sp,
                          color: Colors.green,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'تاريخ الإرجاع: ${_formatDate(rental.returnDate!)}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_isDueToday(rental.dueDate) &&
                    rental.status == RentalStatus.approved) ...[
                  SizedBox(height: 12.h),
                  AnimatedFadeIn(
                    delay: Duration(milliseconds: 240),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            size: 16.sp,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'تاريخ الاستحقاق: ${_formatDate(rental.dueDate)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(RentalStatus status) {
    Color color;
    String text;

    switch (status) {
      case RentalStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case RentalStatus.approved:
        color = Colors.blue;
        text = 'Active';
        break;
      case RentalStatus.returned:
        color = Colors.green;
        text = 'Returned';
        break;
      case RentalStatus.overdue:
        color = Colors.red;
        text = 'Overdue';
        break;
      case RentalStatus.cancelled:
        color = Colors.grey;
        text = 'Cancelled';
        break;
    }

    return AnimatedFadeIn(
      delay: Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isDueToday(DateTime dueDate) {
    final today = DateTime.now();
    return dueDate.year == today.year &&
        dueDate.month == today.month &&
        dueDate.day == today.day;
  }
}
