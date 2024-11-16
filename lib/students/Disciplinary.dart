import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        disciplinaryCases.sort((a, b) => b.timeline.compareTo(a.timeline));
        break;
      case 'Name':
        disciplinaryCases.sort((a, b) => a.commentFrom.compareTo(b.commentFrom));
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
          onPressed: () => Navigator.pop(context),
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: disciplinaryCases.isEmpty
                    ? Center(
                        child: Text(
                          'No disciplinary cases available.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Column(
                        children: disciplinaryCases.map((caseItem) {
                          return DisciplinaryCard(
                            caseType: caseItem.grievanceType,
                            timeline: caseItem.timeline,
                            commentFrom: caseItem.commentFrom,
                            comment: caseItem.comment,
                            caseID: caseItem.grievanceID,
                            status: caseItem.status,
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

class DisciplinaryCard extends StatelessWidget {
  final String caseType;
  final String timeline;
  final String commentFrom;
  final String comment;
  final String caseID;
  final String status;

  const DisciplinaryCard({
    required this.caseType,
    required this.timeline,
    required this.commentFrom,
    required this.comment,
    required this.caseID,
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
              'Case Type: $caseType',
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
              'Case ID: $caseID',
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
