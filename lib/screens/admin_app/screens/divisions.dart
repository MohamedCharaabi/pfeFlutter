import 'package:flutter/material.dart';

class Divisions extends StatefulWidget {
  @override
  _DivisionsState createState() => _DivisionsState();
}

class _DivisionsState extends State<Divisions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divisions'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Divisions'),
      ),
    );
  }
}
