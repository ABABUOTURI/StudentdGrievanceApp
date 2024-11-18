import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Admin/My_Database.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';
import 'package:intl/intl.dart'; // Add this import

class GrievanceReviewAdminPage extends StatefulWidget {
  @override
  _GrievanceReviewAdminPageState createState() =>
      _GrievanceReviewAdminPageState();
}

class _GrievanceReviewAdminPageState extends State<GrievanceReviewAdminPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> grievances = [];
  List<GrievanceSubmission> filteredGrievances = [];

  String selectedCategory = 'All'; // Default category filter
  String selectedStatus = 'All'; // Default status filter
  final _searchController = TextEditingController(); // Search field controller

  final grievanceCategories = [
    'All',
    'Academic',
    'Disciplinary',
    'Harassment',
    'Administrative',
  ];

  final grievanceStatuses = [
    'All',
    'Submitted',
    'In Progress',
    'Resolved',
    'Resubmission',
  ];

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    grievances = grievanceBox!.values.toList();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredGrievances = grievances
          .where((grievance) =>
              (selectedCategory == 'All' || grievance.grievanceType == selectedCategory) &&
              (selectedStatus == 'All' || grievance.status == selectedStatus) &&
              (grievance.grievanceID
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())))
          .toList()
        ..sort((a, b) => b.submissionDate.compareTo(a.submissionDate)); // Sort by latest
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFF082D74)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Grievance Review', style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFC107), Color(0xFF082D74)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
        leading: Icon(Icons.store),
        title: Text('My Store'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatabasePage(),
            ),
          );
        },
      ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Perform logout
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search by Grievance ID...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // Filters Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Filter Dropdown
                DropdownButton<String>(
                  value: selectedCategory,
                  items: grievanceCategories
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      _applyFilters();
                    });
                  },
                ),

                // Status Filter Dropdown
                DropdownButton<String>(
                  value: selectedStatus,
                  items: grievanceStatuses
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),

          // Grievances Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filtered Grievances',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Display Grievances as Cards
          Expanded(
            child: filteredGrievances.isEmpty
                ? Center(
                    child: Text(
                      'No grievances match your criteria.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredGrievances.length,
                    itemBuilder: (context, index) {
                      final grievance = filteredGrievances[index];
                      return _buildGrievanceCard(grievance);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Build each grievance card
  Widget _buildGrievanceCard(GrievanceSubmission grievance) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(grievance.submissionDate);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grievance Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grievance.grievanceType,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    grievance.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(grievance.status),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Grievance Details
            Text(
              'Submitted By: ${grievance.name ?? 'Anonymous'}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Submitted On: $formattedDate',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Description: ${grievance.description}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Grievance ID: ${grievance.grievanceID}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showGrievanceDetails(grievance);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Get color for the status chip
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Resubmission':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Show grievance details
  void _showGrievanceDetails(GrievanceSubmission grievance) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                grievance.grievanceType,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(grievance.description),
              SizedBox(height: 10),
              Text('Grievance ID: ${grievance.grievanceID}'),
              if (grievance.documentPath != null)
                Text('Document: ${grievance.documentPath}'),
              if (grievance.imagePath != null)
                Text('Image: ${grievance.imagePath}'),
            ],
          ),
        );
      },
    );
  }
}
