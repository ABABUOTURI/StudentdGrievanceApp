import 'package:flutter/material.dart';
import 'dart:math'; // For generating tracking ID
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Models/grievance_submission.dart';

class SubmitGrievancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Grievance', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GrievanceFormBody(),
      ),
    );
  }
}

class GrievanceFormBody extends StatefulWidget {
  @override
  _GrievanceFormBodyState createState() => _GrievanceFormBodyState();
}

class _GrievanceFormBodyState extends State<GrievanceFormBody> {
  String grievanceType = 'Academic';
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedDocument;
  String? _selectedImage;

  String _generateTrackingID() {
    var rng = Random();
    return 'GRV-${rng.nextInt(900000) + 100000}'; // Example format: GRV-123456
  }

  Future<void> _submitForm() async {
    String trackingID = _generateTrackingID();

    var grievanceBox = await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');

    GrievanceSubmission newGrievance = GrievanceSubmission(
  grievanceID: trackingID,
  name: _nameController.text,
  grievanceType: grievanceType,
  description: _descriptionController.text,
  documentPath: _selectedDocument,
  imagePath: _selectedImage,
  submissionDate: DateTime.now(),
  assignedMember: 'Unassigned', // Default value
  timestamp: DateTime.now(), // Default value
);


    await grievanceBox.add(newGrievance);

    _showSuccessDialog(trackingID);
  }

  void _showSuccessDialog(String trackingID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Text('Your grievance has been successfully submitted.'),
            SizedBox(height: 10),
            Text('Tracking ID: $trackingID', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Return to the previous page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        _selectedDocument = result.files.single.path;
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedImage = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: grievanceType,
                decoration: InputDecoration(labelText: 'Type of Grievance'),
                items: [
                  DropdownMenuItem(child: Text('Academic'), value: 'Academic'),
                  DropdownMenuItem(child: Text('Administration'), value: 'Administrative'),
                  DropdownMenuItem(child: Text('Harassment'), value: 'Harassment'),
                  DropdownMenuItem(child: Text('Disciplinary'), value: 'Disciplinary'),
                ],
                onChanged: (value) {
                  setState(() {
                    grievanceType = value!;
                  });
                },
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text('Upload Document (Optional)'),
                subtitle: Text(_selectedDocument ?? 'No document selected'),
                trailing: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: _pickDocument,
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text('Upload Image (Optional)'),
                subtitle: Text(_selectedImage ?? 'No image selected'),
                trailing: IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFFFC107),
                backgroundColor: Color(0xFF082D74),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Submit Grievance'),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }
}
