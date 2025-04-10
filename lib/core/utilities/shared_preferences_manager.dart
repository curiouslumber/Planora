import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class that manages all SharedPreferences operations.
class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  static SharedPreferences? _preferences;

  // Private constructor
  SharedPreferencesManager._();

  /// Gets the singleton instance of [SharedPreferencesManager].
  static Future<SharedPreferencesManager> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Keys for different types of data stored in SharedPreferences
  static const String _themeKey = 'theme_mode';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _notificationSettingsKey = 'notification_settings';
  static const String _calendarViewKey = 'calendar_view_type';

  /// Theme Mode Operations
  Future<bool> setThemeMode(String themeMode) async {
    return await _preferences!.setString(_themeKey, themeMode);
  }

  String? getThemeMode() {
    return _preferences?.getString(_themeKey);
  }

  /// Last Sync Operations
  Future<bool> setLastSyncTimestamp(DateTime timestamp) async {
    return await _preferences!.setString(
      _lastSyncKey,
      timestamp.toIso8601String(),
    );
  }

  DateTime? getLastSyncTimestamp() {
    final timestamp = _preferences?.getString(_lastSyncKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  /// User Preferences Operations
  Future<bool> setUserPreferences(Map<String, dynamic> preferences) async {
    return await _preferences!.setString(
      _userPreferencesKey,
      jsonEncode(preferences),
    );
  }

  Map<String, dynamic>? getUserPreferences() {
    final prefs = _preferences?.getString(_userPreferencesKey);
    if (prefs == null) return null;
    return Map<String, dynamic>.from(jsonDecode(prefs));
  }

  /// Notification Settings Operations
  Future<bool> setNotificationSettings(Map<String, bool> settings) async {
    return await _preferences!.setString(
      _notificationSettingsKey,
      jsonEncode(settings),
    );
  }

  Map<String, bool>? getNotificationSettings() {
    final settings = _preferences?.getString(_notificationSettingsKey);
    if (settings == null) return null;
    return Map<String, bool>.from(jsonDecode(settings));
  }

  /// Calendar View Type Operations
  Future<bool> setCalendarViewType(String viewType) async {
    return await _preferences!.setString(_calendarViewKey, viewType);
  }

  String? getCalendarViewType() {
    return _preferences?.getString(_calendarViewKey);
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  /// Remove specific data
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }
}
