import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/page4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PanierPage extends StatefulWidget {


  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<String> panierItems = [];



  Future<void> commanderPanier(BuildContext context) async {
    // Récupérer l'ID de l'utilisateur depuis SharedPreferences (à adapter selon votre implémentation)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? panier = prefs.getStringList('panier');

  }


  @override
  void initState() {
    super.initState();
    chargerPanier();
  }

  void chargerPanier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? panier = prefs.getStringList('panier');

    if (panier != null) {
      setState(() {
        panierItems = panier;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              // Ajoutez ici la logique pour vider complètement le panier
              panierItems.clear();
            },
          ),
        ],
      ),
      body: panierItems.isEmpty
          ? Center(
        child: Text('Le panier est vide.'),
      )
          : ListView.builder(
        itemCount: panierItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  panierItems[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Détails du produit ici',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Ajoutez ici la logique pour supprimer l'élément du panier
                    if (index >= 0 && index < panierItems.length) {
                      // L'index est valide, supprimez l'élément du panier
                      setState(() {
                        panierItems.removeAt(index);
                      });
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (panierItems.isNotEmpty) {
              commanderPanier(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Le panier est vide')),
              );
            }// Ajoutez ici la logique pour le bouton en bas de la page
          },
          child: Text('Commander'),
        ),
      ),
    );
  }
}
