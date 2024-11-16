import 'package:flutter/material.dart';


class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to #FFFFFF
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF082D74), Color(0xFFFC4F00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0), // Add padding around the text
              alignment: Alignment.centerLeft, // Align text to the left
              child: Text(
                "Welcome to Student's Grievance App. ",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF), // Text color #FC4F00
                ),
                textAlign: TextAlign.left, // Align text to the left within the container
              ),
            ),
            SizedBox(height: 5),
            // Placeholder for image
            Image.asset('assets/b2.png', height: 300, width: 200),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF082D74), // Button text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: Text('Get Started'),
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
