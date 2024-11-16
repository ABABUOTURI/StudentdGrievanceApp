import 'package:hive/hive.dart';

part 'grievance_submission.g.dart'; // Hive code generation file

@HiveType(typeId: 1) // Unique TypeId for GrievanceSubmission
class GrievanceSubmission {
  @HiveField(0)
  final String grievanceID;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String grievanceType;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String? documentPath; // Optional document path

  @HiveField(5)
  final String? imagePath; // Optional image path

  @HiveField(6)
  final DateTime submissionDate;

   @HiveField(7)
  final String status; // Example statuses: Submitted, In Progress, Resolved

  @HiveField(8)
  final DateTime? resolutionDate;

  var commentFrom;

  var timeline;

  var comment;


  GrievanceSubmission({
    required this.grievanceID,
    required this.name,
    required this.grievanceType,
    required this.description,
    this.documentPath,
    this.imagePath,
    required this.submissionDate,
    this.status = "Submitted", // Default status
    this.resolutionDate,
  });
}
