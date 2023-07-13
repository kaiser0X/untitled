import 'package:untitled/page2.dart';
import 'package:flutter/material.dart';
import 'package:untitled/page3.dart';
import 'package:flutter/src/material/colors.dart';


void main() {
  runApp(Karl());
}

class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kaiser Test 2",
      home: Inscription(),
    );
  }
}

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background bleu
      body: Center(
        child: Form(

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/images/person.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 1.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Soir()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Intérieur des boutons en bleu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // Contour des boutons en blanc
                    ),
                    elevation: 9, // Ajout d'une ombre
                    minimumSize: Size(350, 60),
          ),
                  child: const Text(
                    'Inscription',
                    style: TextStyle(
                      color: Colors.blue, // Texte en blanc
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Conn()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Intérieur des boutons en bleu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                       // Contour des boutons en blanc
                    ),
                    elevation: 9, // Ajout d'une ombre
                    minimumSize: Size(350, 60),
                  ),
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      color: Colors.blue, // Texte en blanc
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
