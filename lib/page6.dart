import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/page4.dart';

class ProduitDetailPage extends StatelessWidget {
  final Produit produit;

  ProduitDetailPage({required this.produit});

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
    panier.add('Titre: ${produit.nom}, Prix: ${produit.prix.toStringAsFixed(2)}, Description: ${produit.description}');

    // Enregistrer la liste mise à jour dans SharedPreferences
    prefs.setStringList('panier', panier);
  }
}
