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
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
      if (grievanceBox != null) {
        setState(() {
          notifications = grievanceBox!.values.toList();
          _applyFilter();
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter == 'All') {
        notifications = grievanceBox!.values.toList();
      } else {
        notifications = grievanceBox!.values
            .where((g) => g.status == selectedFilter)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
        ),
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter By:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ['All', 'Submitted', 'In Progress', 'Resolved', 'Resubmitted']
                      .map((filter) => DropdownMenuItem<String>(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _applyFilter();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(child: Text('No notifications available.', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationCard(
                        grievanceType: notification.grievanceType,
                        submissionDate: notification.submissionDate,
                        name: notification.name,
                        description: notification.description,
                        grievanceID: notification.grievanceID,
                        status: notification.status,
                        resolutionDate: notification.status == 'Resolved' ? notification.resolutionDate : null,
                        comments: _getCommentsForStatus(notification.status),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Returns sample comments based on status
  List<String> _getCommentsForStatus(String status) {
    switch (status) {
      case 'Submitted':
        return ["Your grievance has been submitted and is under review."];
      case 'In Progress':
        return ["The department is working on resolving your grievance."];
      case 'Resolved':
        return ["Your grievance has been resolved. Please check the resolution details."];
      case 'Resubmitted':
        return ["The grievance has been resubmitted for further review."];
      default:
        return [];
    }
  }
}

class NotificationCard extends StatelessWidget {
  final String grievanceType;
  final DateTime submissionDate;
  final String name;
  final String description;
  final String grievanceID;
  final String status;
  final DateTime? resolutionDate;
  final List<String> comments;

  const NotificationCard({
    required this.grievanceType,
    required this.submissionDate,
    required this.name,
    required this.description,
    required this.grievanceID,
    required this.status,
    this.resolutionDate,
    required this.comments,
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
            Text('Grievance Type: $grievanceType', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Submitted By: $name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Submission Date: $formattedSubmissionDate', style: TextStyle(fontSize: 14)),
            if (resolutionDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Resolved On: $formattedResolutionDate', style: TextStyle(fontSize: 14)),
              ),
            SizedBox(height: 8),
            Text('Description: $description', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Grievance ID: $grievanceID', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Status: $status', style: TextStyle(fontSize: 14, color: Colors.blue)),
            SizedBox(height: 16),
            Text('Comments:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            for (var comment in comments)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('- $comment', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }
}
