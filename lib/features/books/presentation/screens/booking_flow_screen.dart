import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/book_entity.dart';
import '../bloc/book_bloc.dart';

class BookingFlowScreen extends StatefulWidget {
  final BookEntity book;

  const BookingFlowScreen({super.key, required this.book});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  DateTime? _selectedDate;
  int _rentalDays = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rent Book')),
      body: BlocListener<BookBloc, BookState>(
        listener: (context, state) {
          if (state is BookRented) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Book rented successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is BookError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookInfoCard(),
              SizedBox(height: 24.h),
              _buildDateSelectorCard(),
              SizedBox(height: 24.h),
              _buildDurationSelectorCard(),
              SizedBox(height: 24.h),
              _selectedDate != null
                  ? _buildSummaryCard()
                  : const SizedBox.shrink(),
              SizedBox(height: 32.h),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  widget.book.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.book,
                      size: 30.sp,
                      color: Colors.grey[600],
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'لـ ${widget.book.author}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        widget.book.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectorCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تأريخ بدء الإيجار',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'حدد التأريخ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _selectedDate != null
                            ? Colors.black
                            : Colors.grey[600],
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

  Widget _buildDurationSelectorCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مدة الإيجار',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              children: [7, 14, 21, 30].map((days) {
                return ChoiceChip(
                  label: Text('$days يوم'),
                  selected: _rentalDays == days,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _rentalDays = days;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص الإيجار',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            _buildSummaryRow(
              'بداية الإيجار',
              '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            ),
            _buildSummaryRow('المدة', '$_rentalDays يوما'),
            _buildSummaryRow(
              'إنتهاء الإيجار',
              '${_selectedDate!.add(Duration(days: _rentalDays)).day}/${_selectedDate!.add(Duration(days: _rentalDays)).month}/${_selectedDate!.add(Duration(days: _rentalDays)).year}',
            ),
            Divider(height: 24.h),
            Text(
              'لتجنب رسوم التأخير ،يرجى إعادة الكتاب في الموعد المحدد.',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedDate != null && authState is AuthAuthenticated
                ? () {
                    context.read<BookBloc>().add(
                      RentBookEvent(
                        userId: authState.user.id!,
                        bookId: widget.book.id!,
                        rentalDate: _selectedDate!,
                        dueDate: _selectedDate!.add(
                          Duration(days: _rentalDays),
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                return Text(
                  'Confirm Rental',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
