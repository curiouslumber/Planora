import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planora/data/models/event_model.dart';
import 'package:planora/domain/services/database_service.dart';

final GetIt getIt = GetIt.instance;

/// Setup all our dependencies
Future<void> setupDependencies() async {
  try {
    // App initialization
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    // Register the EventModel adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(EventModelAdapter());
    }

    // Initialize DatabaseService
    final databaseService = await DatabaseService.getInstance();

    // Register services as singletons
    if (!getIt.isRegistered<DatabaseService>()) {
      getIt.registerSingleton<DatabaseService>(databaseService);
    }
  } catch (e) {
    debugPrint('Error setting up dependencies: $e');
    rethrow; // Rethrow to ensure the error is not silently ignored
  }
}
