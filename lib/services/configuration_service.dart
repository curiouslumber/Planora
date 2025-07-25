import 'package:shared_preferences/shared_preferences.dart';
import 'package:planora/utils/app_config.dart';

class ConfigurationService {
  final SharedPreferences _prefs;
  
  ConfigurationService(this._prefs);
  
  /// Initialize app configuration
  Future<void> initialize() async {
    await AppConfig.init();
  }
  
  /// Get the current theme mode
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  
  /// Toggle theme mode
  Future<void> toggleTheme(bool isDark) async {
    await _prefs.setBool('isDarkMode', isDark);
  }
  
  /// Check if cloud sync is enabled
  bool get isCloudSyncEnabled => AppConfig.isCloudSyncEnabled;
  
  /// Toggle cloud sync
  Future<void> toggleCloudSync(bool enabled) async {
    await AppConfig.setCloudSyncEnabled(enabled);
  }
}
