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

              // Display grievance progress based on data from Hive
              _buildProgressCards(),

              SizedBox(height: 20),

              // Grievance type cards
              _buildGrievanceTypeCards(context),

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

  // Build progress cards for grievances
  Widget _buildProgressCards() {
    if (grievanceBox == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (grievanceBox!.isEmpty) {
      return Center(child: Text('No grievances available'));
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 3.0,
          children: grievanceBox!.values.map((grievance) {
            // Adjusted for GrievanceSubmission model
            return _buildProgressBar(grievance.grievanceType, grievance.grievanceID);
          }).toList(),
        ),
      ),
    );
  }

  // Build grievance type cards
  Widget _buildGrievanceTypeCards(BuildContext context) {
    return Container(
      height: 500,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8.0),
            children: [
              _buildGrievanceCard(context, 'Academic'),
              _buildGrievanceCard(context, 'Administration'),
              _buildGrievanceCard(context, 'Disciplinary'),
              _buildGrievanceCard(context, 'Harassment'),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build individual progress bars (showing grievanceID as the unique identifier)
  Widget _buildProgressBar(String grievanceType, String grievanceID) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            grievanceType,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 20,
                width: 150, // Example fixed width since progress isn't tracked here
                decoration: BoxDecoration(
                  color: Color(0xFF082D74),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    grievanceID,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to build grievance type cards
  Widget _buildGrievanceCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Academic':
            Navigator.pushNamed(context, '/academic');
            break;
          case 'Administration':
            Navigator.pushNamed(context, '/administration');
            break;
          case 'Disciplinary':
            Navigator.pushNamed(context, '/disciplinary');
            break;
          case 'Harassment':
            Navigator.pushNamed(context, '/harassment');
            break;
        }
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Icon(
                Icons.report_problem,
                size: 40,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
