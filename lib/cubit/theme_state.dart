part of 'theme_cubit.dart';

class ThemeState {
  final ThemeData theme;

  ThemeState.systemTheme()
    : theme =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme;

  ThemeState.lightTheme() : theme = AppTheme.lightTheme;

  ThemeState.darkTheme() : theme = AppTheme.darkTheme;
}
