import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Adjust the height as needed
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF082D74), Color(0xFFFC4F00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)), // White color for back arrow
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
              },
            ),
            title: Text(
              'Reset Password',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              // Add any additional actions if needed
            ],
          ),
        ),
      ),
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
                children: [
                  Icon(
                    Icons.key,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Enter your email to receive a reset password link',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent, // Transparent background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Border radius
                  borderSide: BorderSide(color: Colors.white), // White border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Border radius
                  borderSide: BorderSide(color: Colors.white), // White border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Border radius
                  borderSide: BorderSide(color: Colors.white), // White border color
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.white70), // Optional hint text color
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
              style: TextStyle(color: Colors.white), // Text color
            ),
            SizedBox(height: 24.0),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle send reset password link logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC107), // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
