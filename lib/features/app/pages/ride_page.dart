import 'package:flutter/material.dart';

class Ride extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expressway Ride'),
      ),
      body: Center(
        child: Text(
          'Expressway Ride Screen',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
