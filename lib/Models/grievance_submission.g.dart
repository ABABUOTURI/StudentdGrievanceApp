// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grievance_submission.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrievanceSubmissionAdapter extends TypeAdapter<GrievanceSubmission> {
  @override
  final int typeId = 1;

  @override
  GrievanceSubmission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrievanceSubmission(
      grievanceID: fields[0] as String,
      name: fields[1] as String,
      grievanceType: fields[2] as String,
      description: fields[3] as String,
      documentPath: fields[4] as String?,
      imagePath: fields[5] as String?,
      submissionDate: fields[6] as DateTime,
      status: fields[7] as String,
      resolutionDate: fields[8] as DateTime?,
      assignedMember: fields[9] as String?,
      comments: (fields[10] as List).cast<Comment>(),
      timestamp: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GrievanceSubmission obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.grievanceID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.grievanceType)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.documentPath)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.submissionDate)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.resolutionDate)
      ..writeByte(9)
      ..write(obj.assignedMember)
      ..writeByte(10)
      ..write(obj.comments)
      ..writeByte(11)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrievanceSubmissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 2;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      message: fields[0] as String,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
