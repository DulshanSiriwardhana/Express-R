// scan.dart

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;
  String scannedData = ''; // Store scanned data here

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
                  // Process the scanned data here
                  setState(() {
                    scannedData = scanData.code ?? '';
                  });
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
                    Navigator.pop(context, scannedData);
                  },
                ),
                /*SizedBox(height: 16.0),
                Text(
                  'Scanned Data:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),*/
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

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }
}
