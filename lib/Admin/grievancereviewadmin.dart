import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';
import 'package:studentgrievanceapp/Admin/My_Database.dart';

class GrievanceReviewAdminPage extends StatefulWidget {
  @override
  _GrievanceReviewAdminPageState createState() => _GrievanceReviewAdminPageState();
}

class _GrievanceReviewAdminPageState extends State<GrievanceReviewAdminPage> {
  String selectedCategory = 'Academic'; // Default category
  Box<GrievanceSubmission>? grievanceBox; // Box to hold grievances

  final grievanceCategories = [
    'Academic',
    'Disciplinary',
    'Harassment',
    'Administrative',
  ];

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  // Method to load grievances from Hive
  Future<void> _loadGrievances() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    setState(() {}); // Trigger a UI refresh after loading data
  }

  // Filter grievances based on the selected category and sort by latest
  List<GrievanceSubmission> _getFilteredGrievances() {
    if (grievanceBox == null) return [];
    return grievanceBox!.values
        .where((grievance) => grievance.grievanceType.contains(selectedCategory))
        .toList()
        ..sort((a, b) => b.submissionDate.compareTo(a.submissionDate)); // Sort by latest
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => DatabasePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Grievances...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // Category buttons as text with underline on hover or selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: grievanceCategories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16, // Smaller font size
                        fontWeight: FontWeight.bold,
                        decoration: selectedCategory == category
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        color: selectedCategory == category ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Title of the section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$selectedCategory Grievances',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Grievance List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _getFilteredGrievances().length,
              itemBuilder: (context, index) {
                final grievance = _getFilteredGrievances()[index];
                return _buildGrievanceItem(context, grievance);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a grievance item with action buttons
  Widget _buildGrievanceItem(BuildContext context, GrievanceSubmission grievance) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grievance title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grievance.grievanceType,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    'Pending', // You can change this to dynamic status if needed
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 10),

            // View Details button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showGrievanceDetails(context, grievance);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  backgroundColor: Colors.blue,
                ),
                child: Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show details of a grievance and allow admin actions
  void _showGrievanceDetails(BuildContext context, GrievanceSubmission grievance) {
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
              Text(
                grievance.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              if (grievance.documentPath != null)
                Text('Document: ${grievance.documentPath}'),
              if (grievance.imagePath != null)
                Text('Image: ${grievance.imagePath}'),
              SizedBox(height: 20),

              // Action buttons for the admin
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close details and "approve"
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${grievance.grievanceID} Approved')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Approve'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close details and "reject"
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${grievance.grievanceID} Rejected')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Reject'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close details and comment
                      _showCommentDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Comment'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show a dialog for admin comments
  void _showCommentDialog(BuildContext context) {
    TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Enter your comment'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the comment submission
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Comment submitted')),
                );
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
