import 'package:flutter/material.dart';
import 'package:untitled/presentation.dart';
import 'package:untitled/Calendrier.dart';


import 'login.dart';
import 'new_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Presentation(),
    );
  }
}
