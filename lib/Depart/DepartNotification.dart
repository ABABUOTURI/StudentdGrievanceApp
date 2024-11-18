import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studentgrievanceapp/Depart/grievancereviewdep.dart';

class DepartNotificationPage extends StatefulWidget {
  @override
  _DepartNotificationPageState createState() => _DepartNotificationPageState();
}

class _DepartNotificationPageState extends State<DepartNotificationPage> {
  Box? notificationBox; // Replace with your specific box type
  List notifications = []; // Replace with your notification model
  String selectedFilter = 'All'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    notificationBox = await Hive.openBox('notificationBox'); // Open the box for notifications
    setState(() {
      notifications = notificationBox!.values.toList();
      _applyFilter(); // Apply the default filter on load
    });
  }

  // Apply selected filter to notifications
  void _applyFilter() {
    if (selectedFilter == 'All') {
      notifications = notificationBox!.values.toList();
    } else {
      notifications = notificationBox!.values
          .where((n) => n['status'] == selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GrievanceReviewDepartPage()),
          ), // Navigate back to GrievanceReviewDepartPage
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
                  items: ['All', 'Pending', 'Resolved', 'Submitted', 'Resubmission']
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
                        title: notification['title'], // Replace with actual fields
                        description: notification['description'],
                        status: notification['status'],
                        timestamp: notification['timestamp'], // DateTime field
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
  final String title;
  final String description;
  final String status;
  final DateTime timestamp;

  const NotificationCard({
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(timestamp);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $formattedDate',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
