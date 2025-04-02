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
      ).copyWith(primary: Color(0xff3b4c42)),
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
      ).copyWith(primary: Color(0xff3b4c42), onPrimary: Color(0xffF2F0EF)),
      useMaterial3: true,
    );
  }
}
