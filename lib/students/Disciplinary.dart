import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class DisciplinaryPage extends StatefulWidget {
  @override
  _DisciplinaryPageState createState() => _DisciplinaryPageState();
}

class _DisciplinaryPageState extends State<DisciplinaryPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> disciplinaryCases = [];
  String selectedFilter = 'Date'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadDisciplinaryCases();
  }

  Future<void> _loadDisciplinaryCases() async {
    // Load grievances of type "Disciplinary" from Hive box
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    disciplinaryCases = grievanceBox!.values
        .where((g) => g.grievanceType == 'Disciplinary')
        .toList();
    _sortCases(); // Sort cases based on the default filter
    setState(() {});
  }

  // Method to sort cases based on selected filter
  void _sortCases() {
    switch (selectedFilter) {
      case 'Date':
        disciplinaryCases.sort((a, b) => b.submissionDate.compareTo(a.submissionDate));
        break;
      case 'Name':
        disciplinaryCases.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Case ID':
        disciplinaryCases.sort((a, b) => a.grievanceID.compareTo(b.grievanceID));
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
          'Disciplinary Cases',
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
            child: disciplinaryCases.isEmpty
                ? Center(
                    child: Text(
                      'No disciplinary cases available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: disciplinaryCases.length,
                    itemBuilder: (context, index) {
                      final caseItem = disciplinaryCases[index];
                      return DisciplinaryCard(
                        grievanceType: caseItem.grievanceType,
                        submissionDate: caseItem.submissionDate,
                        name: caseItem.name,
                        description: caseItem.description,
                        grievanceID: caseItem.grievanceID,
                        status: caseItem.status, // Add status dynamically
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DisciplinaryCard extends StatelessWidget {
  final String grievanceType;
  final DateTime submissionDate;
  final String name;
  final String description;
  final String grievanceID;
  final String status;

  const DisciplinaryCard({
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
