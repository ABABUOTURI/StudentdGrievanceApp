import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class HarassmentPage extends StatefulWidget {
  @override
  _HarassmentPageState createState() => _HarassmentPageState();
}

class _HarassmentPageState extends State<HarassmentPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> harassmentCases = [];
  String selectedFilter = 'Date'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadHarassmentCases();
  }

  Future<void> _loadHarassmentCases() async {
    // Load grievances of type "Harassment" from Hive box
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    harassmentCases = grievanceBox!.values
        .where((g) => g.grievanceType == 'Harassment')
        .toList();
    _sortCases(); // Sort cases based on the default filter
    setState(() {});
  }

  // Method to sort cases based on selected filter
  void _sortCases() {
    switch (selectedFilter) {
      case 'Date':
        harassmentCases.sort((a, b) => b.submissionDate.compareTo(a.submissionDate));
        break;
      case 'Name':
        harassmentCases.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Case ID':
        harassmentCases.sort((a, b) => a.grievanceID.compareTo(b.grievanceID));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard', // Navigate to GrievanceReviewStudentPage
            );
          },
        ),
        title: Text(
          'Harassment Cases',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082D74), Color(0xFFFFC107)],
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
                  'Sort By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: <String>['Date', 'Name', 'Case ID']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      _sortCases(); // Re-sort cases based on selected filter
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: harassmentCases.isEmpty
                ? Center(
                    child: Text(
                      'No harassment cases available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: harassmentCases.length,
                    itemBuilder: (context, index) {
                      final caseItem = harassmentCases[index];
                      return HarassmentCard(
                        grievanceType: caseItem.grievanceType,
                        submissionDate: caseItem.submissionDate,
                        name: caseItem.name,
                        description: caseItem.description,
                        grievanceID: caseItem.grievanceID,
                        status: caseItem.status,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class HarassmentCard extends StatelessWidget {
  final String grievanceType;
  final DateTime submissionDate;
  final String name;
  final String description;
  final String grievanceID;
  final String status;

  const HarassmentCard({
    required this.grievanceType,
    required this.submissionDate,
    required this.name,
    required this.description,
    required this.grievanceID,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(submissionDate);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grievance Type: $grievanceType',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Submission Date: $formattedDate',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Submitted By: $name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Grievance ID: $grievanceID',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
