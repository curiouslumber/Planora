import 'package:get_it/get_it.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/repository/events_repository.dart';
import 'package:planora/repository/meetings_repository.dart';
import 'package:planora/repository/notes_repository.dart';
import 'package:planora/services/configuration_service.dart';
import 'package:planora/services/network/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Initializes all the dependencies
Future<void> setupLocator() async {
  // Register core services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Register configuration service
  getIt.registerLazySingleton<ConfigurationService>(
    () => ConfigurationService(getIt<SharedPreferences>()),
  );
  
  // Initialize configuration
  await getIt<ConfigurationService>().initialize();

  // Register connectivity service
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService()..initialize());
  
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<EventsRepository>(() => EventsRepository());
  getIt.registerLazySingleton<MeetingsRepository>(() => MeetingsRepository());
  getIt.registerLazySingleton<NotesRepository>(() => NotesRepository());
}

/// Helper method to get a service from the getIt
T getService<T extends Object>() => getIt<T>();
