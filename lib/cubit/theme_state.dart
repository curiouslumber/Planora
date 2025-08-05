part of 'theme_cubit.dart';

class ThemeState {
  final ThemeData theme;
  final bool isLoading;

  ThemeState(this.theme, {this.isLoading = false});
  
  // Factory constructor for loading state
  factory ThemeState.loading() => ThemeState(
    AppTheme.lightTheme, // Default theme while loading
    isLoading: true,
  );
}
