import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'grievancereviewdep.dart'; // Grievance review page


class DepartNotificationPage extends StatefulWidget {
  @override
  _DepartNotificationPageState createState() => _DepartNotificationPageState();
}

class _DepartNotificationPageState extends State<DepartNotificationPage> {
  Box? notificationBox;
  List notifications = [];
  String selectedFilter = 'All';
  Map<String, int> memberGrievanceCount = {}; // Track grievances per department member
  List waitingList = []; // Store grievances waiting to be assigned

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Load notifications from Hive
  Future<void> _loadNotifications() async {
    notificationBox = await Hive.openBox('notificationBox');
    setState(() {
      notifications = notificationBox!.values.toList();
      print(notifications);  // Debug print
      _applyFilter();
      _assignGrievances(); // Assign grievances initially
    });
  }

  // Assign grievances to members with <4 grievances
  void _assignGrievances() {
    for (var grievance in notifications) {
      if (grievance['status'] == 'Submitted') {
        String? assignedMember = grievance['assignedMember'];

        if (assignedMember != null && memberGrievanceCount[assignedMember]! < 4) {
          continue;
        }

        assignedMember = memberGrievanceCount.keys.firstWhere(
          (member) => memberGrievanceCount[member]! < 4,
          orElse: () => '',
        );

        if (assignedMember.isEmpty) {
          grievance['assignedMember'] = assignedMember;
          memberGrievanceCount[assignedMember] = memberGrievanceCount[assignedMember]! + 1;
        } else {
          waitingList.add(grievance);
        }
      }
    }

    _updateHiveStorage();
  }

  void _reassignGrievances() {
    while (waitingList.isNotEmpty) {
      var grievance = waitingList.first;
      String? assignedMember = memberGrievanceCount.keys.firstWhere(
        (member) => memberGrievanceCount[member]! < 4,
        orElse: () => '',
      );

      if (assignedMember.isEmpty) {
        grievance['assignedMember'] = assignedMember;
        memberGrievanceCount[assignedMember] = memberGrievanceCount[assignedMember]! + 1;
        waitingList.remove(grievance);
      } else {
        break;
      }
    }
    _updateHiveStorage();
  }

  // Update Hive storage with the latest grievance data
  void _updateHiveStorage() {
    for (int i = 0; i < notifications.length; i++) {
      notificationBox!.putAt(i, notifications[i]);
    }
  }

  // Apply filter to notifications
  void _applyFilter() {
    if (selectedFilter == 'All') {
      notifications = notificationBox!.values.toList();
    } else {
      notifications = notificationBox!.values
          .where((n) => n['status'] == selectedFilter)
          .toList();
    }
  }

  void _updateStatus(int index, String newStatus) {
    setState(() {
      notifications[index]['status'] = newStatus;
      if (newStatus == 'InProgress') {
        String assignedMember = notifications[index]['assignedMember'];
        memberGrievanceCount[assignedMember] = memberGrievanceCount[assignedMember]! - 1;
        _reassignGrievances();
      }
    });
    _updateHiveStorage();
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
          ),
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
                      _applyFilter();
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
                        title: notification['title'],
                        description: notification['description'],
                        status: notification['status'],
                        timestamp: notification['timestamp'],
                        onStatusChange: (newStatus) => _updateStatus(index, newStatus),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Notification card widget with status change handler
class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final DateTime timestamp;
  final Function(String) onStatusChange;

  const NotificationCard({
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
    required this.onStatusChange,
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
            Text('Description: $description', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: status,
                  items: ['Submitted', 'InProgress', 'Resolved']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      onStatusChange(newStatus);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Date: $formattedDate', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
