import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> notifications = [];
  String selectedFilter = 'All'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    setState(() {
      notifications = grievanceBox!.values.toList();
      _applyFilter(); // Apply the default filter on load
    });
  }

  // Apply selected filter to notifications
  void _applyFilter() {
    if (selectedFilter == 'All') {
      notifications = grievanceBox!.values.toList();
    } else {
      notifications = grievanceBox!.values
          .where((g) => g.status == selectedFilter)
          .toList();
    }
  }

  // Function to update the status of a grievance and save it to the Hive box
  void _sendNotificationToStudent(Map grievance, String status) {
    grievance['status'] = status; // Update grievance status
    grievanceBox?.put(grievance['grievanceID'], grievance as GrievanceSubmission); // Save the updated grievance in the box
    setState(() {
      _applyFilter(); // Reapply filter to reflect the change in the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/dashboard'), // Navigate back to dashboard
        ),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082D74), Color(0xFFFC4F00)],
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
                  'Filter By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ['All', 'Submitted', 'In Progress', 'Resolved']
                      .map((filter) => DropdownMenuItem<String>(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _applyFilter(); // Filter notifications based on selected option
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'No notifications available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationCard(
                        grievanceType: notification.grievanceType,
                        submissionDate: notification.submissionDate,
                        name: notification.name ?? 'Anonymous', // Default if name is null
                        description: notification.description,
                        grievanceID: notification.grievanceID,
                        status: notification.status,
                        resolutionDate: notification.status == 'Resolved'
                            ? notification.resolutionDate
                            : null,
                        // Add action to update the status
                        onUpdateStatus: (status) {
                          final updatedGrievance = {
                            'grievanceID': notification.grievanceID,
                            'status': status,
                          };
                          _sendNotificationToStudent(updatedGrievance, status);
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

// Card widget to display individual notifications
class NotificationCard extends StatelessWidget {
  final String grievanceType;
  final DateTime submissionDate;
  final String name;
  final String description;
  final String grievanceID;
  final String status;
  final DateTime? resolutionDate;
  final Function(String) onUpdateStatus;

  const NotificationCard({
    required this.grievanceType,
    required this.submissionDate,
    required this.name,
    required this.description,
    required this.grievanceID,
    required this.status,
    this.resolutionDate,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    String formattedSubmissionDate = DateFormat('yyyy-MM-dd HH:mm').format(submissionDate);
    String formattedResolutionDate =
        resolutionDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(resolutionDate!) : '';

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
              'Submitted By: $name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Submission Date: $formattedSubmissionDate',
              style: TextStyle(fontSize: 14),
            ),
            if (resolutionDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Resolved On: $formattedResolutionDate',
                  style: TextStyle(fontSize: 14),
                ),
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
            // Button to update status
            if (status != 'Resolved')
              ElevatedButton(
                onPressed: () => onUpdateStatus('Resolved'),
                child: Text('Mark as Resolved'),
              ),
          ],
        ),
      ),
    );
  }
}
