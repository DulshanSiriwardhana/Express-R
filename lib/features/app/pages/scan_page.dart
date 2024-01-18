import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/app/pages/scan.dart'; // Import the new ScanPage

class Scan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Navigate to the ScanPage and wait for the result (scanned data)
                String? scannedData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );

                // Process the scanned data as needed
                if (scannedData != null) {
                  print('Scanned Data: $scannedData');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: Text(
                'Scan',
                style: TextStyle(
                    fontSize: 18.0, color: Colors.white), // Adjust color here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
