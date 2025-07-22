import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _themeKey = 'isDarkTheme';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeState(ThemeMode.dark));

  void toggleTheme() {
    final isDark = _prefs.getBool(_themeKey) ?? false;
    _prefs.setBool(_themeKey, !isDark);

    emit(ThemeState(isDark ? ThemeMode.light : ThemeMode.dark));
  }

  void getSaveTheme() {
    final isDark = _prefs.getBool(_themeKey) ?? false;
    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
