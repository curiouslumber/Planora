import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final lightColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xff3b4c42),
    brightness: Brightness.light,
  ).copyWith(primary: Color(0xff3b4c42));

  final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xff3b4c42),
    brightness: Brightness.dark,
  ).copyWith(primary: Color(0xff3b4c42));

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: GetMaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        title: 'Planora',
        debugShowCheckedModeBanner: false,
        home: LayoutPage(),
      ),
    );
  }
}
