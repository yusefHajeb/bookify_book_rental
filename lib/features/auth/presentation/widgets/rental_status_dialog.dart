import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../books/domain/entities/rental_entity.dart';
import '../../../books/presentation/bloc/book_bloc.dart';

class RentalStatusDialog extends StatefulWidget {
  final RentalEntity rental;
  final String? bookTitle;
  final String? userName;

  const RentalStatusDialog({
    super.key,
    required this.rental,
    this.bookTitle,
    this.userName,
  });

  @override
  State<RentalStatusDialog> createState() => _RentalStatusDialogState();
}

class _RentalStatusDialogState extends State<RentalStatusDialog> {
  late RentalStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.rental.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'تحديث حالة الإيجار',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.bookTitle != null)
            Text(
              'الكتاب: ${widget.bookTitle}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          if (widget.bookTitle != null) SizedBox(height: 8.h),
          if (widget.userName != null)
            Text(
              'المستخدم: ${widget.userName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          if (widget.userName != null) SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RentalStatus>(
                value: selectedStatus,
                isExpanded: true,
                items: RentalStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          color: _getStatusColor(status),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          status.displayName,
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              ),
            ),
          ),
          if (selectedStatus == RentalStatus.returned)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Text(
                'ملاحظة: تعيين الحالة إلى "مرتجع" سيجعل الكتاب متاحًا للمستخدمين الآخرين.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: selectedStatus != widget.rental.status
              ? () {
                  context.read<BookBloc>().add(
                    UpdateRentalStatusEvent(
                      rentalId: widget.rental.id!,
                      status: selectedStatus,
                      returnDate: selectedStatus == RentalStatus.returned
                          ? DateTime.now()
                          : null,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم تحديث حالة الإيجار إلى ${selectedStatus.displayName}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              : null,
          child: const Text('تحديث الحالة'),
        ),
      ],
    );
  }

  IconData _getStatusIcon(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return Icons.hourglass_empty;
      case RentalStatus.approved:
        return Icons.book;
      case RentalStatus.returned:
        return Icons.check_circle;
      case RentalStatus.overdue:
        return Icons.warning;
      case RentalStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return Colors.orange;
      case RentalStatus.approved:
        return Colors.blue;
      case RentalStatus.returned:
        return Colors.green;
      case RentalStatus.overdue:
        return Colors.red;
      case RentalStatus.cancelled:
        return Colors.grey;
    }
  }
}
