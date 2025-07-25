import 'dart:async';

class ImageUpdateEvent {
  final String eventId;
  
  ImageUpdateEvent(this.eventId);
}

class EventBus {
  static final EventBus _instance = EventBus._internal();
  final _eventController = StreamController<ImageUpdateEvent>.broadcast();

  factory EventBus() {
    return _instance;
  }

  EventBus._internal();

  Stream<ImageUpdateEvent> get onImageUpdated => _eventController.stream;

  void fireImageUpdated(String eventId) {
    if (!_eventController.isClosed) {
      _eventController.add(ImageUpdateEvent(eventId));
    }
  }

  void dispose() {
    _eventController.close();
  }
}
