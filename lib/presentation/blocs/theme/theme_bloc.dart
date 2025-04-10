import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/core/utilities/shared_preferences_manager.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Constructor
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeToggled>(_onThemeToggled);
    _loadThemeMode();
  }

  // Load the theme mode from the SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferencesManager.instance;
    final String? themeModeString = prefs.getThemeMode();
    if (themeModeString != null) {
      final themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
      add(ThemeChanged(themeMode));
    }
  }

  // Handle the ThemeChanged event
  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    final prefs = await SharedPreferencesManager.instance;
    await prefs.setThemeMode(event.themeMode.toString());
  }

  // Handle the ThemeToggled event
  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    add(ThemeChanged(newThemeMode));
  }
}
