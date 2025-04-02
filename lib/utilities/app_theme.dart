import 'package:flutter/material.dart';
import 'package:planora/utilities/font_weights.dart';

class AppTheme {
  static const String fontFamily = 'Poppins';

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
    return ThemeData(
      fontFamily: fontFamily,
      textTheme: _textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xff3b4c42),
        brightness: Brightness.light,
      ).copyWith(
        primary: Color(0xff3b4c42),
        onPrimary: Color(0xffF2F0EF),
        secondary: Color(0xff6B8E7E),
        onSecondary: Color(0xffF2F0EF),
        tertiary: Color(0xffD4C8B5),
        onTertiary: Color(0xff2A2E28),
        surface: Color(0xffF8F5F2),
        onSurface: Color(0xff2A2E28),
        surfaceContainer: Color(0xffE3E8E5), // Renamed property
        error: Color(0xffB71C1C),
        onError: Color(0xffFFFFFF),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: fontFamily,
      textTheme: _textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xff3b4c42),
        brightness: Brightness.dark,
      ).copyWith(
        primary: Color(0xff3b4c42),
        onPrimary: Color(0xffF2F0EF),
        secondary: Color(0xff6b8e7e),
        onSecondary: Color(0xffe8f4ee),
        tertiary: Color(0xff8a9d94),
        onTertiary: Color(0xff121a17), // Fixed contrast
        surface: Color(0xff121a17),
        onSurface: Color(0xffF2F0EF),
        surfaceContainer: Color(0xff2a3a34), // Renamed property
        error: Color(0xffCF6679),
        onError: Color(0xffF2F0EF), // Fixed contrast
        outline: Color(0xff4a5d54),
      ),
      useMaterial3: true,
    );
  }
}
