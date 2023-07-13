import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/page2.dart';

void main() {
  runApp(Karl());
}

class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaiser Test 2",
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: New(),
    );
  }
}

class New extends StatefulWidget {
  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New>{
  int currentIndex = 0;
  stati const List body = [
    Icon(Icons.home)
  ]
  @override
  Widget build(BuildContext context){
    return Scaffold(
      
    )
  }
}