import 'package:flutter/material.dart';
import 'package:planora/core/utilities/font_weights.dart';

class AppTheme {
  static const String fontFamily = 'Poppins';
  static const Color _seedColor = Color(0xff3b4c42); // Verdant Green
  static const Color _seedColorDark = Color(0xff2d3e33); // Moss Green

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
        primary: Color(0xff3b4c42), // Verdant Green
        onPrimary: Color(0xfff0f1eb), // Off-White Mist
        secondary: Color(0xffa0b49d), // Sage Green
        onSecondary: Color(0xff1F2D25), // Charcoal
        tertiary: Color(0xffd8d7c7), // Clay Beige
        onTertiary: Color(0xff2b2b2b), // Charcoal
        surface: Color(0xfff0f1eb), // Off-White Mist
        onSurface: Color(0xff2b2b2b), // Charcoal
        surfaceContainer: Color(
          0xffe7ede8,
        ), // A lighter neutral tone for contrast
        error: Color(0xffB71C1C),
        onError: Color(0xffffffff),
        outline: Color(0xffb4b8b1), // Ash Grey
        shadow: Color(0x143b4c42), // Subtle shadow with primary tint
        secondaryContainer: Color(0xff7e9d83), // Sky Sage (Accent)
        onSecondaryContainer: Color(0xff2b2b2b),
        surfaceContainerHighest: Color(0xfff0f1eb),
        onSurfaceVariant: Color(0xff2b2b2b),
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
        primary: Color(0xff2d3e33), // Moss Green
        onPrimary: Color(0xfff0f1eb), // Off-White Mist
        secondary: Color(0xff7e9d83), // Sky Sage (Accent)
        onSecondary: Color(0xffe8f4ee), // Soft tint of Off-White
        tertiary: Color(0xffa0b49d), // Sage Green
        onTertiary: Color(0xfff0f1eb),
        surface: Color(0xff121a17), // Deep background
        onSurface: Color(0xfff0f1eb), // Off-White Mist
        surfaceContainer: Color(0xff1e2a24),
        error: Color(0xffcf6679),
        onError: Color(0xfff0f1eb),
        outline: Color(0xff5a6d64), // Muted outline
        shadow: Color(0x143b4c42),
        secondaryContainer: Color(0xffa9d676), // Evergreen (Success)
        onSecondaryContainer: Color(0xff2d3e33),
        surfaceContainerHighest: Color(0xff121a17),
        onSurfaceVariant: Color(0xfff0f1eb),
      ),
      useMaterial3: true,
    );
  }
}
