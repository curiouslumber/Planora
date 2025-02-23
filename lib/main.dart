import 'package:easy_scheduler/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final lightColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xffF0857A),
    brightness: Brightness.light,
  ).copyWith(primary: Color(0xffF0857A));

  final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xffF0857A),
    brightness: Brightness.dark,
  ).copyWith(primary: Color(0xffF0857A));

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      title: 'Easy Scheduler',
      debugShowCheckedModeBanner: false,
      home: LayoutPage(),
    );
  }
}
