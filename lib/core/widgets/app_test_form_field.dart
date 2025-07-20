import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? labelText;
  TextInputType keyboardType;
  final Function(String?) validator;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;

  AppTextFormField({
    super.key,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.contentPadding = const EdgeInsets.all(18),
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.onChanged,
    this.labelText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding,
        labelText: labelText,
        // hintStyle: hintStyle ??
        //     context.theme.textTheme.bodyMedium!
        //         .copyWith(color: AppColors.lightGray),
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        prefixIcon: prefixIcon,
      ),
      obscureText: isObscureText ?? false,
      validator: (value) {
        return validator(value);
      },
    );
  }
}
