import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/features/app/pages/login_page.dart';

class MyProfile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      // Handle the case where the user is not logged in
      return Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70.0,
                // You can use the user's profile picture URL if available
                // backgroundImage: NetworkImage(user.photoURL ?? ''),
                // For demonstration purposes, using a placeholder image
                backgroundImage:
                    AssetImage('assets/images/profile_picture.png'),
              ),
            ),
            SizedBox(height: 20.0),
            //_buildFormField('Name', user.displayName ?? ''),
            _buildDivider(),
            _buildFormField('Email', user.email ?? ''),
            _buildDivider(),
            //_buildFormField('UID', user.uid),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await _auth.signOut();
                // Navigate back to the sign-in page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(height: 20.0);
  }
}
