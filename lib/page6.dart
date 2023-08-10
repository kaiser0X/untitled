import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/page4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProduitDetailPage extends StatelessWidget {
  final Produit produit;

  ProduitDetailPage({required this.produit});

  Future<void> commanderProduit(BuildContext context, Produit produit) async {
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

    // Les détails de la commande (ID du produit et quantité)
    List<Map<String, dynamic>> detailsCommande = [
      {
        'id_produit': produit.id, // Remplacez par l'ID du produit (ou tout autre identifiant unique du produit)
        'quantite': 1, // Vous pouvez adapter ici la quantité commandée
      },
    ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du produit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              produit.imagePath, // Utilisez le chemin de l'image du produit
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              produit.nom,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              produit.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${produit.prix.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Ajouter le produit au panier en utilisant SharedPreferences
                ajouterProduitAuPanier(produit);
                // Afficher un message pour indiquer que le produit a été ajouté au panier
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produit ajouté au panier')),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Intérieur des boutons en bleu
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // Contour des boutons en blanc
                ),
                elevation: 9, // Ajout d'une ombre
                minimumSize: Size(50, 50),
              ),
              child: Text(
                "Ajouter au panier",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 9,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                commanderProduit(context, produit); // Appel de la fonction de commande
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Intérieur des boutons en bleu
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // Contour des boutons en blanc
                ),
                elevation: 9, // Ajout d'une ombre
                minimumSize: Size(50, 50),
              ),
              child: Text(
                "Commander",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour ajouter le produit au panier en utilisant SharedPreferences
  void ajouterProduitAuPanier(Produit produit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Récupérer la liste des produits déjà présents dans le panier depuis SharedPreferences
    List<String>? panier = prefs.getStringList('panier');

    // Si le panier est vide, initialiser une nouvelle liste
    if (panier == null) {
      panier = [];
    }

    // Ajouter les informations du produit au panier (vous pouvez ajuster les informations que vous souhaitez enregistrer)
    panier.add(produit.id.toString());

    // Enregistrer la liste mise à jour dans SharedPreferences
    prefs.setStringList('panier', panier);
  }
}

