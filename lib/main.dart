import 'package:flutter/material.dart';
import 'app_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final app = await AppInitializer.initialize();
    runApp(app);
  } catch (error, stackTrace) {
    debugPrint('Error initializing app: $error');
    debugPrint('Stack trace: $stackTrace');
    
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $error'),
          ),
        ),
      ),
    );
  }
}