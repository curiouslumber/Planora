import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/services/network/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planora/bloc/auth_bloc/auth_bloc.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/service_locator.dart';
import 'package:planora/views/home_page.dart';
import 'firebase_options.dart';

class AppInitializer {
  static Future<Widget> initialize() async {
    // Initialize environment variables
    await dotenv.load();
    
    // Initialize Firebase if not on web
    if (!kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register Hive adapters
    _registerHiveAdapters();
    
    // Open Hive boxes
    await _openHiveBoxes();

    // Set up dependency injection first
    await setupLocator();
    
    // Now we can safely get the connectivity service
    getIt<ConnectivityService>();
    
    // Get initial theme
    final initialTheme = await _getInitialTheme();
    
    // Create and return the app widget
    return _buildApp(initialTheme);
  }
  
  static void _registerHiveAdapters() {
    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(NotesModelAdapter());
    Hive.registerAdapter(MeetingsModelAdapter());
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(TodoModelAdapter());
  }
  
  static Future<void> _openHiveBoxes() async {
    await Future.wait([
      Hive.openBox<EventModel>('events'),
      Hive.openBox<NotesModel>('notes'),
      Hive.openBox<MeetingsModel>('meetings'),
      Hive.openBox<TaskModel>('tasks'),
      Hive.openBox<TodoModel>('todos'),
    ]);
  }
  
  static Future<ThemeData?> _getInitialTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode') ?? false;
      return isDark ? ThemeData.dark() : null;
    } catch (e) {
      debugPrint('Error getting initial theme: $e');
      return null;
    }
  }
  
  static Widget _buildApp(ThemeData? initialTheme) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(initialTheme: initialTheme),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(getService<AuthRepository>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            theme: themeState.theme,
            title: 'Planora',
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                // Show loading indicator if theme is still loading
                if (themeState.isLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return _buildHome(authState);
              },
            ),
          );
        },
      ),
    );
  }
  
  static Widget _buildHome(AuthState state) {
    if (state is AuthLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is Authenticated) {
      return HomeScreen(user: state.user);
    } else if (state is Unauthenticated) {
      return HomeScreen(user: null);
    } else if (state is AuthError) {
      // Show error state and retry option
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.message}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry authentication
                  // This assumes you have access to the AuthBloc
                  // You might need to adjust this based on your actual auth flow
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Default loading state
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
