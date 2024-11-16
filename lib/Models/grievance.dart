import 'package:hive/hive.dart';

part 'grievance.g.dart'; // Hive code generation file

@HiveType(typeId: 0) // Unique TypeId for GrievanceProgress
class GrievanceProgress {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double progress;

  @HiveField(2)
  final String status; // 'Pending', 'In Progress', 'Resolved'

  GrievanceProgress({
    required this.title,
    required this.progress,
    required this.status,
  });
}
