import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';
import 'package:studentgrievanceapp/Models/user.dart';

class DatabasePage extends StatefulWidget {
  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  String selectedRole = ''; // Stores the role filter (e.g., "Student", "Admin")
  String searchQuery = '';  // Search query for filtering

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082D74), Color(0xFFFFC107)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('User and Grievance Database', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder(
        future: Future.wait([
          Hive.openBox<User>('userBox'),
          Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox'),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            var userBox = snapshot.data![0] as Box<User>;
            var grievanceBox = snapshot.data![1] as Box<GrievanceSubmission>;

            // Filtered users based on selected role and search query
            var filteredUsers = userBox.values.where((user) {
              bool matchesRole = selectedRole.isEmpty || user.role == selectedRole;
              bool matchesSearch = searchQuery.isEmpty ||
                  user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  user.email.toLowerCase().contains(searchQuery.toLowerCase());
              return matchesRole && matchesSearch;
            }).toList();

            // Filtered grievances based on search query
            var filteredGrievances = grievanceBox.values.where((grievance) {
              bool matchesSearch = searchQuery.isEmpty ||
                  grievance.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  grievance.grievanceID.toLowerCase().contains(searchQuery.toLowerCase());
              return matchesSearch;
            }).toList();

            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),

                // Role filter buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterButton('All', ''),
                      _buildFilterButton('Student', 'Student'),
                      _buildFilterButton('Admin', 'Admin'),
                      _buildFilterButton('Department Member', 'Department Member'),
                    ],
                  ),
                ),

                // Display filtered users and grievances
                Expanded(
                  child: ListView(
                    children: [
                      // Display users
                      if (filteredUsers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('Users:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      for (var user in filteredUsers)
                        Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Email: ${user.email}'),
                                Text('Role: ${user.role}'),
                                Text('Credential: ${user.credential}'),
                              ],
                            ),
                          ),
                        ),

                      // Display grievances
                      if (filteredGrievances.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('Grievances:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      if (filteredGrievances.isNotEmpty)
                        for (var grievance in filteredGrievances)
                          Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grievance ID: ${grievance.grievanceID}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Name: ${grievance.name}'),
                                  Text('Grievance Type: ${grievance.grievanceType}'),
                                  Text('Description: ${grievance.description}'),
                                  if (grievance.documentPath != null)
                                    Text('Document: ${grievance.documentPath}'),
                                  if (grievance.imagePath != null)
                                    Text('Image: ${grievance.imagePath}'),
                                  Text(
                                    'Submission Date: ${grievance.submissionDate.toLocal().toString().split(" ")[0]}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Helper method to create filter buttons
  Widget _buildFilterButton(String title, String role) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedRole = role; // Set the selected role to filter users
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedRole == role ? Colors.blue : Colors.grey, // Highlight selected button
      ),
      child: Text(title),
    );
  }
}
