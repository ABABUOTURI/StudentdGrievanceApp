import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
                Text('Filter By:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    child: Text('No notifications available.', style: TextStyle(fontSize: 16)),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: notifications.map((notification) {
                          return NotificationCard(
                            type: notification.grievanceType,
                            detail: notification.description,
                            submittedOn: notification.submissionDate.toString(),
                            resolvedOn: notification.status == 'Resolved'
                                ? notification.resolutionDate?.toString() ?? ''
                                : '',
                            status: notification.status,
                            grievanceID: notification.grievanceID,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String type;
  final String detail;
  final String submittedOn;
  final String resolvedOn;
  final String status;
  final String grievanceID;

  const NotificationCard({
    required this.type,
    required this.detail,
    required this.submittedOn,
    required this.resolvedOn,
    required this.status,
    required this.grievanceID,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: $type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Detail: $detail',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Submitted On: $submittedOn',
              style: TextStyle(fontSize: 14),
            ),
            if (resolvedOn.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Resolved On: $resolvedOn',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Grievance ID: $grievanceID',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
