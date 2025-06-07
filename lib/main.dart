import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/databases/shared_preferences_helper.dart';
import 'package:planora/utils/globals.dart';
import 'package:planora/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  Globals.initializeSupabase();
  Globals.initializeHive();
  final initialTheme = await SharedPreferencesHelper.getTheme();

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
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
