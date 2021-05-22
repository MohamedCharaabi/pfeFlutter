import 'package:flutter/material.dart';

class Directions extends StatefulWidget {
  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add direction'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Directions'),
      ),
    );
  }
}
