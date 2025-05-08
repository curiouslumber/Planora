import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/utilities/app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.systemTheme()) {
    _initTheme();
  }

  void _initTheme() async {
    // Check if the user has a saved theme in SharedPreferences
    final savedTheme = await SharedPreferencesHelper.getTheme();
    emit(
      savedTheme == AppTheme.lightTheme
          ? ThemeState.lightTheme()
          : ThemeState.darkTheme(),
    );
  }

  // Method to toggle between light and dark themes
  void toggleTheme() async {
    if (state.theme == AppTheme.lightTheme) {
      await SharedPreferencesHelper.saveTheme(AppTheme.darkTheme);
      emit(ThemeState.darkTheme());
    } else {
      await SharedPreferencesHelper.saveTheme(AppTheme.lightTheme);
      emit(ThemeState.lightTheme());
    }
  }
}
