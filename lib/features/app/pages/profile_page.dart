import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/features/app/pages/login_page.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();

    // Fetch user data and set the initial values in controllers
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _ageController.text = userData['age']?.toString() ?? '';
          _addressController.text = userData['address'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                backgroundImage:
                    AssetImage('assets/images/profile_picture.png'),
              ),
            ),
            SizedBox(height: 20.0),
            _buildEditableFormField('Name', _nameController),
            _buildDivider(),
            _buildFormField('Email', _auth.currentUser!.email ?? ''),
            _buildDivider(),
            _buildEditableFormField('Age', _ageController),
            _buildDivider(),
            _buildEditableFormField('Address', _addressController),
            _buildDivider(),
            _buildFormField('UID', _auth.currentUser!.uid),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await _updateUserData();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
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

  Widget _buildEditableFormField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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

  Widget _buildFormField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
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

  Future<void> _updateUserData() async {
    try {
      await _firestore.collection('user').doc(_auth.currentUser!.uid).set({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? null,
        'address': _addressController.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user data'),
        ),
      );
    }
  }
}
