import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:planora/utilities/app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.systemTheme()) {
    _initTheme();
  }

  void _initTheme() async {
    final isDarkMode = await _isDarkMode();
    if (isDarkMode) {
      emit(ThemeState.darkTheme());
    } else {
      emit(ThemeState.lightTheme());
    }
  }

  Future<bool> _isDarkMode() async {
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return platformBrightness == Brightness.dark;
  }

  void changeToLightTheme() {
    emit(ThemeState.lightTheme());
  }

  void changeToDarkTheme() {
    emit(ThemeState.darkTheme());
  }

  void toggleTheme() {
    if (state.theme == AppTheme.lightTheme) {
      emit(ThemeState.darkTheme());
    } else {
      emit(ThemeState.lightTheme());
    }
  }
}
