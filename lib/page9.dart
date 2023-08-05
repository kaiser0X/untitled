import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<String> panierItems = [];

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
      ),
      body: panierItems.isEmpty
          ? Center(
        child: Text('Le panier est vide.'),
      )
          : ListView.builder(
        itemCount: panierItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(panierItems[index]),
          );
        },
      ),
    );
  }
}
