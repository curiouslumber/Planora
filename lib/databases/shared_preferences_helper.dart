import 'package:flutter/material.dart';
import 'package:planora/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String themeKey = "theme";
  static const String eventsHomeBoxesRandomHeightsKey =
      "eventsHomeBoxesRandomHeights";

  static Future<ThemeData> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(themeKey);
    if (themeString == null) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme
              .lightTheme; // Return a default theme if the stored theme is null
    }
    return themeString == "light" ? AppTheme.lightTheme : AppTheme.darkTheme;
  }

  static Future<void> saveTheme(ThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      themeKey,
      theme.brightness == Brightness.light ? "light" : "dark",
    );
  }

  static Future<void> saveEventsHomeBoxesRandomHeights(
    List<double> heights,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      eventsHomeBoxesRandomHeightsKey,
      heights.map((height) => height.toString()).toList(),
    );
  }

  static Future<List<double>> getEventsHomeBoxesRandomHeights() async {
    final prefs = await SharedPreferences.getInstance();
    final heightsStringList = prefs.getStringList(
      eventsHomeBoxesRandomHeightsKey,
    );
    if (heightsStringList == null) {
      return [];
    }
    return heightsStringList.map((height) => double.parse(height)).toList();
  }
}
