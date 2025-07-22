import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String defaultFontFamily = 'FormaDJRDisplay';
  static TextStyle get _baseStyle => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: defaultFontFamily,
  );

  /// The style for the body text.
  static TextStyle get bodyText =>
      _baseStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500);

  /// The style for the large body text.
  static TextStyle get largeBodyText =>
      _baseStyle.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700);

  /// The style for the small body text.
  static TextStyle get smallBodyText =>
      _baseStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w400);

  /// The style for the large headline.
  static TextStyle get largeHeadline =>
      _baseStyle.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700);

  /// The style for the headline 1.
  static TextStyle get headline1 =>
      _baseStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w300);

  /// The style for the headline 2.
  static TextStyle get headline2 =>
      _baseStyle.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w400);

  /// The style for the headline 3.
  static TextStyle get headline3 =>
      _baseStyle.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w300);

  /// The style for the small headline.
  static TextStyle get smallHeadline =>
      _baseStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600);

  /// The style for the medium title.
  static TextStyle get mediumTitle =>
      _baseStyle.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600);

  /// The style for the medium headline.
  static TextStyle get mediumHeadline =>
      _baseStyle.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500);

  /// The style for the headline 6.
  static TextStyle get headline6 =>
      _baseStyle.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500);

  /// The style for the button text.
  static TextStyle get buttonText =>
      _baseStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600);

  static TextStyle bodyLargeText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle bodyMediumText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle bodySmallText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  static TextStyle headerLarge = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle headerMedium = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle headerSmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
  static TextStyle headerExtraSmall = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle displaySmallText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle displayMediumText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle displayLargeText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle titleLargeText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle titleMediumText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: Colors.black,
  );

  static TextStyle titleSmallText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: Colors.black,
  );

  static TextStyle labelSmallText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: Colors.black,
  );

  static TextStyle labelMediumText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: Colors.black,
  );

  static TextStyle labelLargeText = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    height: 1.1,
    color: Colors.black,
  );
}
