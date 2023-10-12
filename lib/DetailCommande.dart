import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Details_Commandes_Users {
  final String prod_id;
  final String nom_prod;
  final String prix;
  final String nom_taille;
  final String code_couleur;
  final String chemin_image;
  late final int quantite;

  Details_Commandes_Users(this.prod_id, this.nom_prod, this.prix, this.nom_taille, this.code_couleur, this.chemin_image, this.quantite);

}

class Details_Commande extends StatefulWidget {
  var commande_id, total;
  Details_Commande({this.commande_id, this.total});

  @override
  State<Details_Commande> createState() => _Details_CommandeState();
}

class _Details_CommandeState extends State<Details_Commande> {

  Future<List<Details_Commandes_Users>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'details_user_commande',
      'commande_id': widget.commande_id,
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['prod_id']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Details_Commandes_Users(item['prod_id'], item['nom_prod'], item['prix'], item['nom_taille'], item['code_couleur'], item['chemin_image'], item['quantite'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Total',style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38
                  ),),
                  Text(
                    '${widget.total} Fcfa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 15,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Définit la couleur de fond à noir
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Supprime les bordures
                    ),
                  ),
                ),
                onPressed: () async {
                  // // Récupérer les items du panier
                  // List<CartItem> cartItems = widget.cart.items;
                  //
                  // ConvertColor(Color? selectedColor) {
                  //   final rgb = selectedColor!.red.toString() +
                  //       '. ' +
                  //       selectedColor.green.toString() +
                  //       '. ' +
                  //       selectedColor.blue.toString();
                  //   return rgb;
                  // }
                  // // Récupérer les informations sur les produits, tailles et couleurs depuis le panier
                  // List<Product> products = cartItems.map((item) => item.product).toList();
                  // List<String?> tailles = cartItems.map((item) => item.size).toList();
                  // List<String> couleurs = cartItems.map((item) => ConvertColor(item.color)).toList();
                  // List<int> quantites = cartItems.map((item) => item.quantity).toList();
                  //
                  // // Convertir les listes en chaînes de caractères séparées par des virgules
                  // String idProduitsString = products.map((product) => product.id).join(",");
                  // String quantitesString = quantites.join(",");
                  // String taillesString = tailles.join(",");
                  // String couleursString = couleurs.join(",");
                  //
                  // // Prix total depuis le panier
                  // double prixTotal = widget.cart.totalPrice;
                  //
                  // // ID utilisateur (remplacez par votre logique d'authentification)
                  // int idUtilisateur = 1; // Exemple d'ID utilisateur
                  //
                  // // Construire le corps de la requête POST
                  // var requestBody = {
                  //   'id_utilisateur': idUtilisateur.toString(),
                  //   'id_produits': idProduitsString,
                  //   'quantites': quantitesString,
                  //   'tailles': taillesString, // Ajoutez la taille
                  //   'couleurs': couleursString, // Ajoutez la couleur
                  //   'prix_total': prixTotal.toString(),
                  // };
                  // print(requestBody);
                  // // Envoyer la requête POST à l'API
                  // var response = await http.post(Uri.parse('http://karlmichel.alwaysdata.net/Commander.php'), body: requestBody);
                  // print(response.body);
                  // if (response.statusCode == 200) {
                  //   // La commande a été enregistrée avec succès
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('Commande enregistrée avec succès.'),
                  //     ),
                  //   );
                  //   // Effacer le panier après la commande
                  //   setState(() {
                  //     widget.cart.items.clear();
                  //   });
                  // } else {
                  //   // Erreur lors de l'enregistrement de la commande
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('Erreur lors de l\'enregistrement de la commande.'),
                  //     ),
                  //   );
                  // }
                }, child: null,

              ),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: () async {
                final phone = '+24162704058'; // Remplacez par le numéro de téléphone auquel vous souhaitez envoyer un message WhatsApp
                final url = 'https://wa.me/$phone';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  // Gérer le cas où l'ouverture de WhatsApp échoue
                  print('Impossible d\'ouvrir WhatsApp');
                  }
                  },
                child: Text('Ouvrir WhatsApp'),)
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: FutureBuilder<List<Details_Commandes_Users>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Aucun produit n\'a ete commandé.'),);
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var details_commandeItem = snapshot.data![index];
                    final colorValues =
                    details_commandeItem.code_couleur.split('.').map((value) => int.parse(value)).toList();
                    final color =
                    Color.fromARGB(255, colorValues[0], colorValues[1], colorValues[2]);
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width/3.5,
                                height: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(details_commandeItem.chemin_image),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(details_commandeItem.nom_prod,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),),
                                Text('Taille: '+details_commandeItem.nom_taille),
                                Row(
                                  children: [
                                    Text('Couleur: '),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Text('${(int.parse(details_commandeItem.prix) * details_commandeItem.quantite)} Fcfa',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueAccent
                                ),),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(height: 40,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (details_commandeItem.quantite > 1) {
                                                details_commandeItem.quantite--;
                                              } else {

                                              }
                                            });
                                          },
                                        ),
                                        Text('${(details_commandeItem.quantite)}'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              details_commandeItem.quantite++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),),
        ],
      ),
    );
  }
}