import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/bloc/auth_bloc/auth_bloc.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/firebase_options.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/views/home_page.dart';
import 'package:planora/views/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  // Initialize Firebase
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(MeetingsModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TodoModelAdapter());
  
  // Get initial theme
  final initialTheme = await SharedPreferencesHelper.getTheme();
  
  // Set system UI mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(PlanoraApp(initialTheme: initialTheme));
}

class PlanoraApp extends StatelessWidget {
  const PlanoraApp({super.key, required this.initialTheme});

  final ThemeData? initialTheme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(initialTheme: initialTheme),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.theme,
            title: 'Planora',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(
              child: BlocProvider(
                create: (context) => AuthBloc(AuthRepository()),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      final msg = state.message;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    } else if (state is Authenticated) {
                      return HomeScreen(user: state.user);
                    } else if (state is Unauthenticated) {
                      return HomeScreen(user: null);
                    }
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}