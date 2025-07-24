// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 4;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      notes: fields[3] as String,
      doesRepeat: fields[4] as bool,
      repeatOption: fields[5] as String,
      selectedDays: (fields[6] as List).cast<String>(),
      taskStatus: fields[7] as String,
      attachments: (fields[8] as List).cast<File>(),
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      priority: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.doesRepeat)
      ..writeByte(5)
      ..write(obj.repeatOption)
      ..writeByte(6)
      ..write(obj.selectedDays)
      ..writeByte(7)
      ..write(obj.taskStatus)
      ..writeByte(8)
      ..write(obj.attachments)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
