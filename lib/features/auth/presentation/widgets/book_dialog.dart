import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../../../books/presentation/bloc/book_bloc.dart';

class BookDialog extends StatefulWidget {
  final BookEntity? book;

  const BookDialog({super.key, this.book});

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  late final TextEditingController titleController;
  late final TextEditingController authorController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageUrlController;
  late double rating;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book?.title);
    authorController = TextEditingController(text: widget.book?.author);
    descriptionController = TextEditingController(
      text: widget.book?.description,
    );
    imageUrlController = TextEditingController(text: widget.book?.imageUrl);
    rating = widget.book?.rating ?? 0.0;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return AlertDialog(
      title: Text(isEdit ? 'تعديل الكتاب' : 'إضافة كتاب'),
      content: SingleChildScrollView(
        child: Form(key: _formKey, child: _buildFormFields(context)),
      ),
      actions: _buildDialogActions(context, isEdit),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'العنوان',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى ادخال عنوان الكتاب';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: authorController,
          decoration: InputDecoration(
            labelText: 'المؤلف',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى ادخال اسم المؤلف';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'الوصف',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى ادخال الوصف';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: imageUrlController,
          decoration: InputDecoration(
            labelText: 'رابط صورة الكتاب',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى ادخال رابط الصورة';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقييم: ${rating.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Slider(
              value: rating,
              min: 0.0,
              max: 5.0,
              divisions: 10,
              onChanged: (value) => setState(() => rating = value),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildDialogActions(BuildContext context, bool isEdit) {
    return [
      if (isEdit)
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (dialogContext) => BlocProvider.value(
                value: context.read<BookBloc>(),
                child: AlertDialog(
                  title: const Text('حذف الكتاب'),
                  content: const Text('هل أنت متأكد أنك تريد حذف هذا الكتاب؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: widget.book?.id != null
                          ? () {
                              context.read<BookBloc>().add(
                                DeleteBookEvent(widget.book!.id!),
                              );
                              Navigator.pop(dialogContext);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(),
                      child: const Text('حذف'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('حذف الكتاب', style: TextStyle(color: Colors.red)),
        ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final newBook = BookEntity(
              id: isEdit ? widget.book!.id : null,
              title: titleController.text,
              author: authorController.text,
              description: descriptionController.text,
              imageUrl: imageUrlController.text,
              rating: rating,
              isAvailable: isEdit
                  ? widget.book!.isAvailable
                  : true, // Explicit default for new books
              createdAt: isEdit ? widget.book!.createdAt : DateTime.now(),
              updatedAt: isEdit ? DateTime.now() : DateTime.now(),
            );

            if (isEdit) {
              context.read<BookBloc>().add(UpdateBookEvent(newBook));
            } else {
              context.read<BookBloc>().add(AddBookEvent(newBook));
            }
            Navigator.pop(context);
          }
        },
        child: Text(isEdit ? 'تحديث' : 'إضافة'),
      ),
    ];
  }
}
