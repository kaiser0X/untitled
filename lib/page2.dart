import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/page3.dart';
import 'package:http/http.dart' as http;



class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaiser Test 2",
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Soir(),
    );
  }
}

class Soir extends StatefulWidget {
  @override
  _SoirState createState() => _SoirState();
}

class _SoirState extends State<Soir> {
  var titre = "Kaiser est Sommet";
  String name = '';
  String prenom = '';
  DateTime? date;
  final formKey = GlobalKey<FormState>();

  TextEditingController Nom = TextEditingController();
  TextEditingController Prenom = TextEditingController();
  TextEditingController Telephone = TextEditingController();

  TextEditingController Mail = TextEditingController();
  TextEditingController Pseudo = TextEditingController();
  TextEditingController Mdp = TextEditingController();
  void inscription(Nom, Prenom, Telephone,  Mail, Pseudo, Mdp)async{
    var url = 'http://karlmichel.alwaysdata.net/api.php'; // Remplacez par votre URL d'API

    var response = await http.post(Uri.parse(url),
        body:  {
          'click': 'ins',
          'nom': Nom,
          'prenom': Prenom,
          'telephone': Telephone,
          'email': Mail,
          'pseudo': Pseudo,
          'mdp': Mdp,
        }
    );
    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données renvoyées par l'API
      print(response.body);
    } else {
      // La requête a échoué
      print('Échec de la requête avec le code ${response.statusCode}');
    }
  }


  void switchForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Conn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    TextFormField(

                      decoration: InputDecoration(
                        labelText: 'Nom',
                        labelStyle: TextStyle(
                          color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre nom',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Nom,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        labelStyle: TextStyle(
                            color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre prénom',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Prenom,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Numéro',
                        labelStyle: TextStyle(
                            color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre numéro de téléphone',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Telephone,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre adresse mail',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Mail,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Pseudo',
                        labelStyle: TextStyle(
                            color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre pseudo',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Pseudo,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(
                            color: Colors.blue
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Saisir votre mot de passe',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: Mdp,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                  ],
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  inscription(Nom.text, Prenom.text, Telephone.text, Mail.text, Pseudo.text, Mdp.text);
                  setState(() {
                    titre = "Tu vas y arriver";
                  });
                  print('J\'ai réussi');
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
                  "Inscription",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: switchForm,
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
