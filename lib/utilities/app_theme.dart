import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'Poppins';

  static final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w900,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
    titleMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w300),
    titleSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w200),
    bodyLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w100),
    bodyMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w300),
    labelLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w300),
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
      ).copyWith(primary: Color(0xff3b4c42)),
      useMaterial3: true,
    );
  }
}
