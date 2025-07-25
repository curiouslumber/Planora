import 'package:shared_preferences/shared_preferences.dart';

/// Manages application-wide configuration settings
class AppConfig {
  static const String _cloudSyncKey = 'cloud_sync_enabled';
  static bool _cloudSyncEnabled = true;

  /// Initialize configuration from persistent storage
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cloudSyncEnabled = prefs.getBool(_cloudSyncKey) ?? true;
  }

  /// Check if cloud sync is enabled
  static bool get isCloudSyncEnabled => _cloudSyncEnabled;

  /// Toggle cloud sync and save the preference
  static Future<void> setCloudSyncEnabled(bool enabled) async {
    if (_cloudSyncEnabled != enabled) {
      _cloudSyncEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_cloudSyncKey, enabled);
    }
  }

  // Add other app-wide configuration getters/setters here as needed
}
