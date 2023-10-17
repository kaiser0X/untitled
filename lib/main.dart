import 'package:flutter/material.dart';
import 'package:untitled/presentation.dart';
import 'package:untitled/Calendrier.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'login.dart';
import 'new_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? userId;

  void session() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userId != null?Boutique():Presentation(),
    );
  }
}
