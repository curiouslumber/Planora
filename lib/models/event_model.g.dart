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
      userId: fields[1] as String,
      eventTileImage: fields[2] as String,
      eventTileImageLocalUrl: fields[3] as String,
      isImageProcessing: fields[4] as bool,
      name: fields[5] as String,
      description: fields[6] as String,
      startDate: fields[7] as String,
      endDate: fields[8] as String?,
      startTime: fields[9] as String,
      endTime: fields[10] as String,
      people: (fields[11] as List?)?.cast<String>(),
      meeting: fields[12] as String?,
      eventStatus: fields[13] as String,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
      attribution: (fields[16] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.eventTileImage)
      ..writeByte(3)
      ..write(obj.eventTileImageLocalUrl)
      ..writeByte(4)
      ..write(obj.isImageProcessing)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.startTime)
      ..writeByte(10)
      ..write(obj.endTime)
      ..writeByte(11)
      ..write(obj.people)
      ..writeByte(12)
      ..write(obj.meeting)
      ..writeByte(13)
      ..write(obj.eventStatus)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.attribution);
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
