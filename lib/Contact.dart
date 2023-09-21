import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CompanyInfoPage(),
    );
  }
}

class CompanyInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos de notre entreprise'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width/1,
          height: MediaQuery.of(context).size.width / 0.1,
          decoration: BoxDecoration(
            color: Colors.blueGrey[100]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Description de l\'entreprise :',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Votre entreprise a créé cette application pour vous fournir des informations utiles et des services de qualité.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Coordonnées de l\'entreprise :',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Adresse : 123 Rue de l\'Entreprise\nVille : Ville de l\'Entreprise\nTéléphone : +33 1 23 45 67 89\nE-mail : contact@entreprise.com',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
