import 'package:hive/hive.dart';

part 'grievance_submission.g.dart'; // Hive code generation file

@HiveType(typeId: 1) // Unique TypeId for GrievanceSubmission
class GrievanceSubmission extends HiveObject {
  @HiveField(0)
  final String grievanceID;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String grievanceType;

  @HiveField(3)
  String description; // Change to String to update it dynamically

  @HiveField(4)
  final String? documentPath;

  @HiveField(5)
  final String? imagePath;

  @HiveField(6)
  final DateTime submissionDate;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final DateTime? resolutionDate;

  @HiveField(9)
  final String? assignedMember;

  @HiveField(10)
  final List<Comment> comments;

  @HiveField(11) // New Hive field for timestamp
  final DateTime? timestamp; // Nullable DateTime

  GrievanceSubmission({
    required this.grievanceID,
    required this.name,
    required this.grievanceType,
    required this.description,
    this.documentPath,
    this.imagePath,
    required this.submissionDate,
    this.status = "Submitted",
    this.resolutionDate,
    this.assignedMember,
    this.comments = const [],
    this.timestamp, // Nullable
  });

  // Method to add a new comment (message) to the grievance
  void addMessage(String newMessage) {
    description += '\n$newMessage'; // Append the new message to the description
    comments.add(Comment(message: newMessage, timestamp: DateTime.now())); // Save the message as a comment
  }
}

// Comment class to store individual comments/messages
@HiveType(typeId: 2)
class Comment {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final DateTime timestamp;

  Comment({
    required this.message,
    required this.timestamp,
  });
}
