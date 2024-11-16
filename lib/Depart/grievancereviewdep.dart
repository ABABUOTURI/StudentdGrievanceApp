import 'package:flutter/material.dart';

class GrievanceReviewStudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Implement drawer or sidebar functionality if needed
              },
            ),
            Expanded(
              child: Text(
                'Grievance Review',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
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
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title at the center
            Text(
              'Grievance Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Progress bars in 2 columns, 2 rows
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                _buildProgressBar('Academic Progress'),
                _buildProgressBar('Administration Progress'),
                _buildProgressBar('Disciplinary Progress'),
                _buildProgressBar('Harassment Progress'),
              ],
            ),
            SizedBox(height: 20),

            // Container for cards arranged in 2 columns and 2 rows
            Container(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  _buildGrievanceCard('Academic'),
                  _buildGrievanceCard('Administration'),
                  _buildGrievanceCard('Disciplinary'),
                  _buildGrievanceCard('Harassment'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Title for buttons
            Text(
              'Actions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Submit New Grievance & Comment buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement submit new grievance functionality
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Submit New Grievance'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement comment functionality
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build progress bars
  Widget _buildProgressBar(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.7, // This would represent the current progress (customize as needed)
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method to build grievance cards
  Widget _buildGrievanceCard(String title) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
    );
  }
}
