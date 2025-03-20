import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class EventData{
  int code;
  int? intValue;
  EventData({
    required this.code,
    this.intValue,
  });

  send(){
    eventBus.fire(this);
  }
}