import 'package:flutter/material.dart';
import 'package:planora/utilities/font_weights.dart';

class AppTheme {
  static const String fontFamily = 'Poppins';
  static const Color _seedColor = Color(0xff3b4c42);
  static const Color _seedColorDark = Color(
    0xff4a5d52,
  ); // Slightly lighter for dark mode

  static final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.black,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.extraBold,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.semiBold,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.medium,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.regular,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.light,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.extraLight,
    ),
    bodyLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeights.thin),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.regular,
    ),
    bodySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeights.light),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.medium,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.regular,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeights.light,
    ),
  );

  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      fontFamily: fontFamily,
      textTheme: _textTheme,
      colorScheme: baseScheme.copyWith(
        primary: _seedColor,
        onPrimary: const Color(0xffF2F0EF),
        secondary: const Color(0xff5d7d6e),
        onSecondary: const Color(0xffF2F0EF),
        tertiary: const Color(0xffC4B8A5),
        onTertiary: const Color(0xff2A2E28),
        surface: const Color(0xffF8F5F2),
        onSurface: const Color(0xff2A2E28),
        surfaceContainer: const Color(0xffD8E0DD), // More distinct from surface
        error: const Color(0xffB71C1C),
        onError: const Color(0xffFFFFFF),
        outline: const Color(0xff85958c),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _seedColorDark,
      brightness: Brightness.dark,
    );

    return ThemeData(
      fontFamily: fontFamily,
      textTheme: _textTheme,
      colorScheme: baseScheme.copyWith(
        primary: _seedColorDark,
        onPrimary: const Color(0xffF2F0EF),
        secondary: const Color(
          0xff6d9382,
        ), // Slightly brighter for better visibility
        onSecondary: const Color(0xffe8f4ee),
        tertiary: const Color(0xff9aada4),
        onTertiary: const Color(0xff121a17),
        surface: const Color(0xff121a17),
        onSurface: const Color(0xffF2F0EF),
        surfaceContainer: const Color(0xff1e2a24), // More distinct from surface
        error: const Color(0xffCF6679),
        onError: const Color(0xffF2F0EF),
        outline: const Color(0xff5a6d64),
      ),
      useMaterial3: true,
    );
  }
}
