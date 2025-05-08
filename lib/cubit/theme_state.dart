part of 'theme_cubit.dart';

class ThemeState {
  final ThemeData? theme;

  ThemeState(this.theme);

  ThemeState.systemTheme(initialTheme) : theme = initialTheme;

  ThemeState.lightTheme() : theme = AppTheme.lightTheme;

  ThemeState.darkTheme() : theme = AppTheme.darkTheme;
}
