import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _boxName = 'settingsBox';
  static const String _themeKey = 'isDarkMode';

  ThemeCubit() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final isDark = box.get(_themeKey, defaultValue: false) as bool;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox(_boxName);
    final isDark = state == ThemeMode.dark;
    await box.put(_themeKey, !isDark);
    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
