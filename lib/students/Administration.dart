import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class AdministrationPage extends StatefulWidget {
  @override
  _AdministrationPageState createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {
  Box<GrievanceSubmission>? grievanceBox;
  List<GrievanceSubmission> grievances = [];
  String selectedFilter = 'Date'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
    grievances = grievanceBox!.values.where((g) => g.grievanceType == 'Administration').toList();
    _sortGrievances(); // Sort grievances based on the default filter
    setState(() {});
  }

  // Method to sort grievances based on selected filter
  void _sortGrievances() {
    switch (selectedFilter) {
      case 'Date':
        grievances.sort((a, b) => b.timeline.compareTo(a.timeline));
        break;
      case 'Name':
        grievances.sort((a, b) => a.commentFrom.compareTo(b.commentFrom));
        break;
      case 'Grievance ID':
        grievances.sort((a, b) => a.grievanceID.compareTo(b.grievanceID));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Administration Grievances',
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
                  items: <String>['Date', 'Name', 'Grievance ID']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      _sortGrievances(); // Re-sort grievances based on selected filter
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: grievances.isEmpty
                    ? Center(
                        child: Text(
                          'No grievances available.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Column(
                        children: grievances.map((grievance) {
                          return GrievanceCard(
                            grievanceType: grievance.grievanceType,
                            timeline: grievance.timeline,
                            commentFrom: grievance.commentFrom,
                            comment: grievance.comment,
                            grievanceID: grievance.grievanceID,
                            status: grievance.status,
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GrievanceCard extends StatelessWidget {
  final String grievanceType;
  final String timeline;
  final String commentFrom;
  final String comment;
  final String grievanceID;
  final String status;

  const GrievanceCard({
    required this.grievanceType,
    required this.timeline,
    required this.commentFrom,
    required this.comment,
    required this.grievanceID,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
              'Timeline: $timeline',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Comment From: $commentFrom',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Comment: $comment',
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
