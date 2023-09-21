import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarApp(),
    );
  }
}

class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Créez une clé pour les événements dans SharedPreferences.
  final String _eventsKey = 'events';

  Map<String, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // Charge les événements depuis SharedPreferences.
  void _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsString = prefs.getString(_eventsKey);
    Map<String, dynamic>? eventsMap = eventsString != null ? json.decode(eventsString) : null;


    if (eventsMap != null) {
      setState(() {
        _events = Map<String, List<String>>.from(eventsMap);
      });
    }
  }

  // Enregistre les événements dans SharedPreferences.
  void _saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_eventsKey, _events.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier Flutter'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                // Personnalisez le style du calendrier ici.
              ),
              headerStyle: HeaderStyle(
                // Personnalisez le style de l'en-tête ici.
              ),
            ),
            // Champ de texte pour ajouter un événement
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Ajouter un événement'),
                onFieldSubmitted: (value) {
                  _addEvent(value);
                },
              ),
            ),
            // Liste des événements pour la date sélectionnée
            if (_selectedDay != null)
              ..._buildEventList(),
          ],
        ),
      ),
    );
  }

  // Ajoute un événement pour la date sélectionnée.
  void _addEvent(String event) {
    if (_selectedDay != null) {
      final formattedDate = "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

      setState(() {
        if (_events.containsKey(formattedDate)) {
          _events[formattedDate]!.add(event);
        } else {
          _events[formattedDate] = [event];
        }
        _saveEvents();
      });
    }
  }

  // Construit la liste des événements pour la date sélectionnée.
  List<Widget> _buildEventList() {
    final formattedDate = "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

    return (_events[formattedDate] ?? []).map((event) => ListTile(title: Text(event))).toList();
  }
}
