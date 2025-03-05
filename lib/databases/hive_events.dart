import 'package:easy_scheduler/models/event_model.dart';
import 'package:hive/hive.dart';

class HiveEvents {
  static const String eventsBox = 'eventsBox';

  static Future<void> addEventToHive(EventModel event) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.add(event);
  }

  static Future<List<EventModel>> getEventsFromHive() async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    return box.values.toList();
  }
}
