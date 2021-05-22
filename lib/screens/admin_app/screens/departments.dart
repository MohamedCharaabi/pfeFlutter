import 'package:flutter/material.dart';

class Departments extends StatefulWidget {
  @override
  _DepartmentsState createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Departments'),
      ),
    );
  }
}
