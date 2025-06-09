import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/bloc/auth_bloc.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
  await Hive.initFlutter();
  final initialTheme = await SharedPreferencesHelper.getTheme();
  Hive.registerAdapter(EventModelAdapter());
  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(MeetingsModelAdapter());
  Hive.registerAdapter(PeopleModelAdapter());
  runApp(MyApp(initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialTheme});

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
            home: BlocProvider(
              create: (context) => AuthBloc(AuthRepository()),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    final msg = state.message;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
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
                  } else {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
