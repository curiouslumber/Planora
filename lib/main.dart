import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/core/di/service_locator.dart';
import 'package:planora/core/utilities/app_theme.dart';
import 'package:planora/presentation/blocs/theme/theme_bloc.dart';
import 'package:planora/presentation/blocs/theme/theme_state.dart';
import 'package:planora/presentation/layout/layout_page.dart';

void main() async {
  try {
    // Initialize dependencies
    await setupDependencies();

    runApp(
      BlocProvider(create: (context) => ThemeBloc(), child: const MyApp()),
    );
  } catch (e) {
    debugPrint('Error initializing app: $e');
    // Show error UI if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // Set system navigation bar color based on theme
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor:
                state.themeMode == ThemeMode.dark
                    ? AppTheme.darkTheme.colorScheme.surface
                    : AppTheme.lightTheme.colorScheme.surface,
            systemNavigationBarIconBrightness:
                state.themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
        );

        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          title: 'Planora',
          debugShowCheckedModeBanner: false,
          home: const LayoutPage(),
        );
      },
    );
  }
}
