// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeopleModelAdapter extends TypeAdapter<PeopleModel> {
  @override
  final int typeId = 3;

  @override
  PeopleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeopleModel(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      email: (fields[3] as List).cast<String>(),
      phone: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PeopleModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeopleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
