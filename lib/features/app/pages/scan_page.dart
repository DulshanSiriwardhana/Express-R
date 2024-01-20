import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/features/app/pages/scan.dart';
import 'package:flutter_firebase/global/common/toast.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  List<dynamic> scannedDataList = [];
  bool isTealColor = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 191, 244, 175).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanPage()),
                  ).then((result) {
                    if (result != null) {
                      print('Scanned Data: $result');
                      setState(() {
                        scannedDataList.add(result);
                        isTealColor = !isTealColor;
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              if (scannedDataList.isNotEmpty)
                Container(
                  height: 400,
                  child: ListView(
                    children: _buildScannedDataWidgets(),
                  ),
                ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _fetchAndDisplayAllDataFromFirestore();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text(
                  'Show',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          height: 700,
          width: 400,
        ),
      ),
    );
  }

  List<Widget> _buildScannedDataWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < scannedDataList.length - 1; i += 2) {
      String inData = scannedDataList[i];
      String outData = i + 1 < scannedDataList.length
          ? scannedDataList[i + 1]
          : 'On the way      ';
      inData = inData.substring(0, inData.length - 4);
      outData = outData.substring(0, outData.length - 5);

      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
              color: isTealColor
                  ? Color.fromRGBO(213, 245, 105, 1)
                  : Color.fromRGBO(146, 237, 201, 1),
            ),
            width: 300,
            child: Column(
              children: [
                Text('In: $inData', style: TextStyle(fontSize: 16.0)),
                Text('Exit: $outData', style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 8.0),
                // Add delete button for each scanned data except the last one
                if (i != scannedDataList.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _deleteScannedData(i);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      isTealColor = !isTealColor;
    }
    if (scannedDataList.last.toString().endsWith('in')) {
      String additionalInData = scannedDataList.last.toString();
      additionalInData =
          additionalInData.substring(0, additionalInData.length - 4);

      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), width: 5.0),
              borderRadius: BorderRadius.circular(10.0),
              color: isTealColor
                  ? Color.fromRGBO(239, 237, 97, 1)
                  : Color.fromRGBO(146, 237, 201, 1),
            ),
            width: 300,
            height: 100,
            child: Column(
              children: [
                Text('In: $additionalInData', style: TextStyle(fontSize: 16.0)),
                Text('Out: On the way', style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 8.0),
                // Add delete button for the additional scanned data
                /*ElevatedButton(
                    onPressed: () {
                      _deleteScannedData(i + 2);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  void _deleteScannedData(int index) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the corresponding data in Firestore
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('drive')
            .where('data', isEqualTo: scannedDataList[index])
            .get()
            .then((querySnapshot) {
          print(querySnapshot.docs);
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
            showToast(message: "Deleted Successfully");
          });
        });
        // Delete the corresponding data in Firestore
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('drive')
            .where('data', isEqualTo: scannedDataList[index + 1])
            .get()
            .then((querySnapshot) {
          print(querySnapshot.docs);
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
            showToast(message: "Deleted Successfully");
          });
        });
        // Remove the scanned data from the list
        setState(() {
          scannedDataList.removeRange(index, index + 2);
        });
      }
    } catch (e) {
      print('Error deleting data from Firestore: $e');
    }
  }

  void _fetchAndDisplayAllDataFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch all scanned data from Firestore in descending order
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .collection('drive')
                .orderBy('timestamp', descending: false)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            scannedDataList =
                querySnapshot.docs.map((doc) => doc['data']).toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }
}
