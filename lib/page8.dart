import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/page4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PanierPage extends StatefulWidget {
  final Produit produit;

  PanierPage({required this.produit});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<String> panierItems = [];
  List<Produit> listeProduits = [];


  Future<void> commanderPanier(BuildContext context) async {
    // Récupérer l'ID de l'utilisateur depuis SharedPreferences (à adapter selon votre implémentation)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    if (id == null) {
      // Si l'ID de l'utilisateur n'est pas disponible, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ID de l\'utilisateur non trouvé')),
      );
      return;
    }

    // Les détails de la commande (ID du produit et quantité) pour chaque produit dans le panier
    List<Map<String, dynamic>> detailsCommande = [];

    for (var produitId in panierItems) {
      Produit produitDetails = listeProduits.firstWhere((produit) => produit.id == produitId);
      if (produitDetails != null) {
        detailsCommande.add({
          'id_produit': produitDetails.id,
          'quantite': 1, // Vous pouvez adapter ici la quantité commandée
        });
      }
    }

    // Les données à envoyer au serveur
    Map<String, dynamic> data = {
      'click': 'com',
      'id_user': id,
      'details_commande': jsonEncode(detailsCommande),
    };

    // URL du serveur où se trouve le code PHP
    final String url = 'http://karlmichel.alwaysdata.net/uploading.php';

    // Envoyer la requête HTTP POST
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );

      // Vérifier la réponse du serveur
      if (response.statusCode == 200) {
        // Afficher un message pour indiquer que la commande a été enregistrée avec succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Commande enregistrée avec succès')),
        );
        // Vider le panier après la commande réussie
        setState(() {
          panierItems.clear();
        });
      } else {
        // Afficher un message d'erreur en cas de problème avec la commande
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la commande')),
        );
      }
    } catch (e) {
      // En cas d'erreur lors de la requête HTTP
      print('Erreur lors de la requête HTTP : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la commande')),
      );
    }
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
