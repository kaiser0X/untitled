import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/page4.dart';
import 'package:http/http.dart' as http;

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
      home: Conn(),
    );
  }
}

class Conn extends StatefulWidget {
  @override
  _ConnState createState() => _ConnState();
}

class _ConnState extends State<Conn> {
  var titre = "Kaiser est Sommet";
  String name = '';
  String mdp = '';
  DateTime? date;
  final formKey = GlobalKey<FormState>();

  TextEditingController Mail = TextEditingController();
  TextEditingController Mdp = TextEditingController();

  void connexion(Mail, Mdp) async {
    var url = 'http://karlmichel.alwaysdata.net/api.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'con',
      'email': Mail,
      'mdp': Mdp,
    });
    print(response.body.split(',')[0]);
    print(response.body.split(',')[1]);
    print(response.body.split(',')[2]);
    print(response.body.split(',')[3]);
    print(response.body.split(',')[4]);
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Les données de connexion sont incorrectes, afficher un message d'erreur
        setState(() {
          titre = "Données de connexion incorrectes";
        });
      } else {
        // Les données de connexion sont valides
        // Naviguer vers la page 3
        killForm();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', response.body.split(',')[0]);
        await prefs.setString('nom', response.body.split(',')[1]);
        await prefs.setString('prenom', response.body.split(',')[2]);
        await prefs.setString('telephone', response.body.split(',')[3]);
        await prefs.setString('email', response.body.split(',')[4]);
      }
    } else {
      // La requête a échoué
      print('Échec de la requête avec le code ${response.statusCode}');
    }
  }

  void killForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Shopping ()), // Remplacez "Page2" par le nom de votre page cible
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 2.0),
                    color: Colors.white, // Couleur d'arrière-plan
                  ),
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Saisir votre mail',
                        icon: Icon(Icons.person, color: Colors.blue, size: 25),
                      ),
                      controller: Mail,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Saisir votre mot de passe',
                        icon: Icon(Icons.lock, color: Colors.brown, size: 25),
                      ),
                      controller: Mdp,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ])),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  connexion(Mail.text, Mdp.text);
                  setState(() {
                    titre = "Tu vas y arriver";
                  });
                  print('J\'ai réussi');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(70, 40),
                ),
                child: Text(
                  "Connexion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: killForm,
                  style: TextButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text('Inscription'))
            ],
          ),
        ),
      ),
    );
  }
}
