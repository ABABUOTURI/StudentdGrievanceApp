import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        harassmentCases.sort((a, b) => b.timeline.compareTo(a.timeline));
        break;
      case 'Name':
        harassmentCases.sort((a, b) => a.commentFrom.compareTo(b.commentFrom));
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
          onPressed: () => Navigator.pop(context),
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: harassmentCases.isEmpty
                    ? Center(
                        child: Text(
                          'No harassment cases available.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Column(
                        children: harassmentCases.map((caseItem) {
                          return HarassmentCard(
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

class HarassmentCard extends StatelessWidget {
  final String caseType;
  final String timeline;
  final String commentFrom;
  final String comment;
  final String caseID;
  final String status;

  const HarassmentCard({
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
