import 'package:flutter/material.dart';
import 'package:studentgrievanceapp/Depart/DepartNotification.dart';

class GrievanceReviewDepartPage extends StatelessWidget {
  // Mock data for real-time progress
  final Map<String, double> grievanceProgress = {
    'Academic': 0.75, // 75% progress
    'Administration': 0.50, // 50% progress
    'Disciplinary': 0.25, // 25% progress
    'Harassment': 0.90, // 90% progress
  };

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
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Implement search functionality
              },
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_photo.jpg'), // Replace with profile photo
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF082D74)),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
           ListTile(
  leading: Icon(Icons.notifications, color: Colors.blue),
  title: Text('Notifications'),
  onTap: () {
    // Navigate directly to the DepartNotificationPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepartNotificationPage()), // Directly create an instance of the page
    );
  },
),

            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.blue),
              title: Text('Profile'),
              onTap: () {
                // Implement profile functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              onTap: () {
                // Implement settings functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text('Logout'),
              onTap: () {
                // Implement logout functionality
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title at the center
              Text(
                'Grievance Progress Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082D74),
                ),
              ),
              SizedBox(height: 20),

              // Progress Card
              _buildGrievanceProgressCard(context),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build grievance progress card
  Widget _buildGrievanceProgressCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display progress bars for each grievance type
            for (var entry in grievanceProgress.entries) ...[
              Text(
                '${entry.key} Progress: ${(entry.value * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF082D74)),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: entry.value, // Progress percentage
                backgroundColor: Colors.grey[300],
                color: Color(0xFF082D74),
              ),
              SizedBox(height: 20),
            ],
            Divider(color: Colors.grey),

            // Buttons for each grievance type
            Text(
              'Explore Grievances:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF082D74)),
            ),
            SizedBox(height: 10),

            // Horizontal scrollable row of buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/academic'); // Navigate to Academic Page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF082D74)),
                    child: Text('Academic', style: TextStyle(color: Color(0xFFFFC107))),
                  ),
                  SizedBox(width: 10), // Spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/administration'); // Navigate to Administration Page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF082D74)),
                    child: Text('Administration', style: TextStyle(color: Color(0xFFFFC107))),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/disciplinary'); // Navigate to Disciplinary Page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF082D74)),
                    child: Text('Disciplinary', style: TextStyle(color: Color(0xFFFFC107))),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/harassment'); // Navigate to Harassment Page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF082D74)),
                    child: Text('Harassment', style: TextStyle(color: Color(0xFFFFC107))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
