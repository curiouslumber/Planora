import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planora/data/models/event_model.dart';
import 'package:planora/services/database_service.dart';

final GetIt getIt = GetIt.instance;

/// Setup all our dependencies
Future<void> setupDependencies() async {
  // App initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Register the EventModel adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(EventModelAdapter());
  }

  // Register services as singletons
  final databaseService = await DatabaseService.getInstance();
  getIt.registerSingleton<DatabaseService>(databaseService);
}
