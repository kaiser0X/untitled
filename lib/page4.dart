import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:untitled/page5.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:untitled/page6.dart';
import 'package:untitled/page7.dart';
import 'package:untitled/page8.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';


class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaiser Test 2",
      debugShowCheckedModeBanner: false,
   
    );
  }
}


class New extends StatefulWidget {
  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  int currentIndex = 0;

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Menu();
      case 1:
        return Recherche();
      case 2:
        return Container();
      case 3:
        return Profil();
      default:
        return Container();
    }
  }

  void Ajout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Visual()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[300],
        elevation: 4,
        centerTitle: true,
        title: Text(
          'F D T C',
          textAlign: TextAlign.center,
        ),
        leading: Builder( // Utiliser un Builder ici
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Utiliser le context du Builder
            },
            icon: Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Ajout();
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        // Le contenu du menu
        child: ListView(
          children: [
            // L'en-tête du menu
            DrawerHeader(
              child: Container(
                width: 200,
                height: 150,
                child: Text('Menu'),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            // Les éléments du menu
            ListTile(
              leading: Icon(Icons.shopping_basket_outlined),
              title: Text('Panier'),
              onTap: () {
                Navigator.pop(context); // Fermer le menu après avoir cliqué
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PanierPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notification_add_outlined),
              title: Text('Notification'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getPage(currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        index: currentIndex,
        items: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
          Icon(Icons.add_shopping_cart, color: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}


class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? id;
  String? nom;
  String? prenom;
  String? telephone;
  String? mail;
  String? pseudo;


  @override
  void initState() {
    super.initState();
    profil();
  }

  void profil() async {
    // Obtention des préférences partagées.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id');
      nom = prefs.getString('nom');
      prenom = prefs.getString('prenom');
      telephone = prefs.getString('telephone');
      mail = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 2.0),
                    color: Colors.white, // Couleur d'arrière-plan
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Nom : $nom',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Prénom : $prenom',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Telphone : $telephone',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Mail : $mail',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Produit> produits = []; // Liste des produits à afficher dans la GridView


  @override
  void initState() {
    super.initState();
    chargerProduits(); // Charger les données des produits depuis la base de données
  }

  void chargerProduits() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'affiche',
    });

    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez accéder aux données renvoyées par l'API
      var data = json.decode(response.body);

      // Parcourir les données et créer des objets Produit
      List<Produit> listeProduits = [];
      for (var item in data) {
        var produit = Produit(
          id: item['ID_PROD'],
          nom: item['NOM_PROD'],
          description: item['DESCRIP'],
          prix: double.parse(item['PRIX']),
          imagePath: item['PHOTO_PROD'],
        );
        listeProduits.add(produit);
      }

      setState(() {
        produits = listeProduits;
      });
    } else {
      // La requête a échoué
      print('Échec de la requête avec le code ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          var produit = produits[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProduitDetailPage(produit: produit),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // Alignez le contenu en haut de la colonne
                  children: [
                    Expanded(
                      child: ClipRRect( // Ajoutez ClipRRect pour ajouter des bords arrondis à l'image
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          produit.imagePath, // Utilisez le chemin de l'image du produit
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover, // Ajustez l'image pour qu'elle remplisse l'espace
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      produit.nom,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      produit.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '\$${produit.prix.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: produits.length,
      )


    );
  }
}


class Produit {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final String imagePath; // Chemin de l'image du produit

  Produit({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.imagePath,
  });
}

















