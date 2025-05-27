import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
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
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
