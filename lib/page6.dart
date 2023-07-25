import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }
}
