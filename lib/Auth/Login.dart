import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentgrievanceapp/Admin/grievancereviewadmin.dart';
import 'package:studentgrievanceapp/Depart/grievancereviewdep.dart';
import 'package:studentgrievanceapp/Models/user.dart';
import 'package:studentgrievanceapp/students/grievancereviewstud.dart';
import 'package:studentgrievanceapp/students/submitgrievance.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errorText = '';

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Function to check credentials in Hive
  Future<void> _validateAndLogin() async {
    setState(() {
      _errorText = ''; // Clear any previous error
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Validate input
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      } else if (password.length < 8) {
        throw Exception('Password must be at least 8 characters long.');
      }

      // Open the Hive box
      var box = await Hive.openBox<User>('userBox');

      // Check if user exists in the database
      bool userFound = false;
      User? loggedInUser;

      for (int i = 0; i < box.length; i++) {
        final user = box.getAt(i);
        if (user!.email == email && user.password == password) {
          userFound = true;
          loggedInUser = user;
          break;
        }
      }

      // If user not found, throw error
      if (!userFound) {
        throw Exception('Invalid email or password.');
      }

      // Navigate based on user role
      if (loggedInUser!.role == 'Student') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GrievanceReviewStudentPage()), // Replace with the appropriate page
        );
      } else if (loggedInUser.role == 'Department Member') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GrievanceReviewDepartPage()), // Replace with the department page
        );
      } else if (loggedInUser.role == 'Admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GrievanceReviewAdminPage()), // Replace with the admin page
        );
      }
    } catch (e) {
      // Display the error message
      setState(() {
        _errorText = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Icons.person,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFFFFC107),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 90.0),

            // Email input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.white70),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),

            // Password input
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.white70),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8.0),

            // Error message display
            Text(
              _errorText,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            SizedBox(height: 24.0),

            // Login button
            Center(
              child: ElevatedButton(
                onPressed: _validateAndLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC107),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 16.0),

            // Forgot password and registration links
            Center(
              child: Column(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/resetPassword');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Don’t have an account? Register',
                      style: TextStyle(color: Colors.white),
                    ),
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
