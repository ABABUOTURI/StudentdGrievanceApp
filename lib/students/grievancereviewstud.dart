import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class GrievanceReviewStudentPage extends StatefulWidget {
  @override
  _GrievanceReviewStudentPageState createState() => _GrievanceReviewStudentPageState();
}

class _GrievanceReviewStudentPageState extends State<GrievanceReviewStudentPage> {
  Box<GrievanceSubmission>? grievanceBox;

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    setState(() {}); // Refresh the UI once the data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFF082D74)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            Expanded(
              child: Text(
                'Grievance Review',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Grievance Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Display grievance progress and buttons
              _buildProgressGrid(),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/submit_grievance');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFFFC107),
                      backgroundColor: Color(0xFF082D74),
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    child: Text('Submit New Grievance'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/student_grievance');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFFFC107),
                      backgroundColor: Color(0xFF082D74),
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    child: Text('Comment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF082D74)),
            child: Center(
              child: Text(
                'Student Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blue),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.blue),
            title: Text('Submit Grievance'),
            onTap: () {
              Navigator.pushNamed(context, '/submit_grievance');
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt, color: Colors.blue),
            title: Text('Receipts'),
            onTap: () {
              Navigator.pushNamed(context, '/page2');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('Notifications'),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
    );
  }

  // Build progress grid dynamically
  Widget _buildProgressGrid() {
    if (grievanceBox == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (grievanceBox!.isEmpty) {
      return Center(child: Text('No grievances available'));
    }

    // Total number of grievances
    int grievanceCount = grievanceBox!.length;

    // Calculate progress percentages for each category
    double progressAcademic = (grievanceBox!.values.where((g) => g.grievanceType == 'Academic').length / grievanceCount) * 100;
    double progressAdministration = (grievanceBox!.values.where((g) => g.grievanceType == 'Administration').length / grievanceCount) * 100;
    double progressDisciplinary = (grievanceBox!.values.where((g) => g.grievanceType == 'Disciplinary').length / grievanceCount) * 100;
    double progressHarassment = (grievanceBox!.values.where((g) => g.grievanceType == 'Harassment').length / grievanceCount) * 100;

    // Create a grid of progress bars and buttons
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: [
        _buildProgressRowWithButton('Academic', progressAcademic, '/academic'),
        _buildProgressRowWithButton('Administration', progressAdministration, '/administration'),
        _buildProgressRowWithButton('Disciplinary', progressDisciplinary, '/disciplinary'),
        _buildProgressRowWithButton('Harassment', progressHarassment, '/harassment'),
      ],
    );
  }

  // Method to build progress rows with buttons
  Widget _buildProgressRowWithButton(String title, double progressPercentage, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title - ${progressPercentage.toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: Colors.grey[300],
              color: Color(0xFF082D74),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF082D74),
                ),
                child: Text(title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
