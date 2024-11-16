// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grievance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrievanceProgressAdapter extends TypeAdapter<GrievanceProgress> {
  @override
  final int typeId = 0;

  @override
  GrievanceProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrievanceProgress(
      title: fields[0] as String,
      progress: fields[1] as double,
      status: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GrievanceProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.progress)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrievanceProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
