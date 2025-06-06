// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingsModelAdapter extends TypeAdapter<MeetingsModel> {
  @override
  final int typeId = 2;

  @override
  MeetingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingsModel(
      id: fields[0] as String,
      meetingTitle: fields[1] as String,
      meetingLink: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.meetingTitle)
      ..writeByte(2)
      ..write(obj.meetingLink)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
