import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class AcademicPage extends StatefulWidget {
  @override
  _AcademicPageState createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> grievances = [];
  String selectedFilter = 'Date'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');

    // Filter grievances of type "Academic"
    grievances = grievanceBox!.values
        .where((g) => g.grievanceType == 'Academic')
        .toList();

    _sortGrievances(); // Sort grievances based on the default filter
    setState(() {});
  }

  // Method to sort grievances based on selected filter
  void _sortGrievances() {
    switch (selectedFilter) {
      case 'Date':
        grievances.sort((a, b) => b.submissionDate.compareTo(a.submissionDate));
        break;
      case 'Name':
        grievances.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Grievance ID':
        grievances.sort((a, b) => a.grievanceID.compareTo(b.grievanceID));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard', // Navigate to GrievanceReviewStudentPage
            );
          },
        ),
        title: Text(
          'Academic Grievances',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082D74), Color(0xFFFFC107)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Filter dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: <String>['Date', 'Name', 'Grievance ID']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      _sortGrievances(); // Re-sort grievances based on selected filter
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: grievances.isEmpty
                ? Center(
                    child: Text(
                      'No grievances available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: grievances.length,
                    itemBuilder: (context, index) {
                      final grievance = grievances[index];
                      return GrievanceCard(
                        grievanceType: grievance.grievanceType,
                        submissionDate: grievance.submissionDate,
                        name: grievance.name,
                        description: grievance.description,
                        grievanceID: grievance.grievanceID,
                        status: grievance.status,
                        onMessageSend: (newMessage) {
                          // Update grievance description and save it to Hive
                          grievance.description += '\n$newMessage';
                          grievance.save(); // Save updated grievance
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class GrievanceCard extends StatelessWidget {
  final String grievanceType;
  final DateTime submissionDate;
  final String name;
  final String description;
  final String grievanceID;
  final String status;
  final Function(String) onMessageSend;

  const GrievanceCard({
    required this.grievanceType,
    required this.submissionDate,
    required this.name,
    required this.description,
    required this.grievanceID,
    required this.status,
    required this.onMessageSend,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(submissionDate);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grievance Type: $grievanceType',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Submission Date: $formattedDate',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Submitted By: $name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Grievance ID: $grievanceID',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.message, color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController _messageController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Add Message'),
                        content: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(hintText: 'Enter your message'),
                          maxLines: 3,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              String message = _messageController.text;
                              if (message.isNotEmpty) {
                                // Send the message and save it in Hive
                                onMessageSend(message);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Message sent successfully'),
                                  ),
                                );
                              }
                            },
                            child: Text('Send'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
