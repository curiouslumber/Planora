// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 0;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String,
      eventTileImage: fields[1] as String,
      eventTileImageLocalUrl: fields[2] as String,
      isImageProcessing: fields[3] as bool,
      name: fields[4] as String,
      description: fields[5] as String,
      startDate: fields[6] as String,
      endDate: fields[7] as String?,
      startTime: fields[8] as String,
      endTime: fields[9] as String,
      people: (fields[10] as List?)?.cast<String>(),
      meeting: fields[11] as String?,
      eventStatus: fields[12] as String,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventTileImage)
      ..writeByte(2)
      ..write(obj.eventTileImageLocalUrl)
      ..writeByte(3)
      ..write(obj.isImageProcessing)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.startTime)
      ..writeByte(9)
      ..write(obj.endTime)
      ..writeByte(10)
      ..write(obj.people)
      ..writeByte(11)
      ..write(obj.meeting)
      ..writeByte(12)
      ..write(obj.eventStatus)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
