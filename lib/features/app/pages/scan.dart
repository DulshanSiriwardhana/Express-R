import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/global/common/toast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;
  String scannedData = '';
  String lastScan = '';
  bool isDataProcessed = false;

  @override
  void initState() {
    super.initState();
    // Fetch the last scanned data before scanning
    _fetchLastScan();
    print("Last Scanned Data :${lastScan}");
    //showToast(message: lastScan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR scan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: _qrKey,
              onQRViewCreated: (controller) {
                _qrViewController = controller;
                _qrViewController.scannedDataStream.listen((scanData) {
                  if (!isDataProcessed) {
                    setState(() {
                      scannedData = scanData.code ?? '';
                      if ((scannedData.endsWith('in') &&
                              lastScan.endsWith('out')) ||
                          (scannedData.endsWith('out') &&
                              lastScan.endsWith('in')) ||
                          (scannedData.endsWith('in') && lastScan == '')) {
                        isDataProcessed = true;
                        _storeScannedData(scannedData);
                        Navigator.pop(context, scannedData);
                        //MaterialPageRoute(builder: (context) => Scan());
                      }
                    });
                  }
                });
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.teal,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.circle_outlined),
                  iconSize: 100,
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
                SizedBox(height: 5.0),
                Text(
                  scannedData,
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _storeScannedData(String data) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('drive')
            .add({
          'data': data,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error storing scanned data: $e');
    }
  }

  void _fetchLastScan() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .collection('drive')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            lastScan = querySnapshot.docs.first['data'];
            showToast(message: lastScan);
          });
        }
      }
    } catch (e) {
      print('Error fetching last scan: $e');
    }
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }
}
