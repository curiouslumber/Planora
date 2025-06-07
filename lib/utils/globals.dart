import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/people_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Globals {
  static late final SupabaseClient supabase;

  static void initializeSupabase() {
    Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    supabase = Supabase.instance.client;
  }

  static void initializeHive() {
    Hive.initFlutter();
    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(NotesModelAdapter());
    Hive.registerAdapter(MeetingsModelAdapter());
    Hive.registerAdapter(PeopleModelAdapter());
  }
}
