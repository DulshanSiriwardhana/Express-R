import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/app/pages/sign_up_page.dart';
import 'package:flutter_firebase/main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Theme:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text('Light Mode', style: TextStyle(fontSize: 16.0)),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      _changeTheme(value);
                    });
                  },
                ),
                Text('Dark Mode', style: TextStyle(fontSize: 16.0)),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme(bool isDarkMode) {
    if (isDarkMode) {
      // Set Dark Mode
      _setDarkMode();
    } else {
      // Set Light Mode
      _setLightMode();
    }
  }

  void _setDarkMode() {
    ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.indigo,
      colorScheme: ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.indigoAccent,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.white),
      ),
    );
    _applyTheme(darkTheme);
  }

  void _setLightMode() {
    ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: Colors.teal,
      colorScheme: ColorScheme.light(
        primary: Colors.teal,
        secondary: Colors.tealAccent,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
      ),
    );
    _applyTheme(lightTheme);
  }

  void _applyTheme(ThemeData theme) {
    runApp(
      MaterialApp(
        theme: theme,
        home: SignUpPage(),
      ),
    );
  }
}
