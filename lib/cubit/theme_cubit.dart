import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/utils/app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({ThemeData? initialTheme}) : super(ThemeState.loading()) {
    _initTheme(initialTheme);
  }

  Future<void> _initTheme(ThemeData? initialTheme) async {
    try {
      // If we have an initial theme, use it immediately to prevent flash of default theme
      if (initialTheme != null) {
        emit(ThemeState(initialTheme));
      }
      
      // Then check if the user has a saved theme in SharedPreferences
      final savedTheme = await SharedPreferencesHelper.getTheme();
      emit(ThemeState(savedTheme));
    } catch (e) {
      debugPrint('Error initializing theme: $e');
      // Fallback to light theme if there's an error
      emit(ThemeState(AppTheme.lightTheme));
    }
  }

  // Method to toggle between light and dark themes
  Future<void> toggleTheme() async {
    try {
      final newTheme = state.theme == AppTheme.lightTheme 
          ? AppTheme.darkTheme 
          : AppTheme.lightTheme;
          
      await SharedPreferencesHelper.saveTheme(newTheme);
      emit(ThemeState(newTheme));
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }
}
