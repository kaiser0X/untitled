import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'details_produits.dart';


class Product {
  final int id;
  final String name;
  final String image;
  final int price;

  Product(this.id, this.name, this.image, this.price);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class Cart {
  List<CartItem> items = [];

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.product.price * item.quantity);

  void addToCart(Product product) {
    CartItem? cartItem;

    for (var item in items) {
      if (item.product.id == product.id) {
        cartItem = item;
        break;
      }
    }

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      items.add(CartItem(product, 1));
    }
  }

  void removeFromCart(CartItem cartItem) {
    items.remove(cartItem);
  }
}

class Shopping extends StatelessWidget {
  final Cart cart = Cart();

  Future<List<Product>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'affiche',
    });

    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['ID_PROD']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['ID_PROD'], item['NOM_PROD'], item['PHOTO_PROD'], item['PRIX'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cart: cart, fetchProducts: fetchProducts),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Cart cart;
  final Future<List<Product>> Function() fetchProducts;

  MyHomePage({required this.cart, required this.fetchProducts});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
int _calculateTotalItems(Cart cart) {
  int totalItems = 0;
  for (var cartItem in cart.items) {
    totalItems += cartItem.quantity;
  }
  return totalItems;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: widget.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                      ),
                    );
                  },
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  leading: Image.network(product.image),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        widget.cart.addToCart(product);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(cart: widget.cart)),
          );
        },
        label: Text('Cart (${_calculateTotalItems(widget.cart)})'), // Utilise la fonction _calculateTotalItems
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}


class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Future<void> placeOrder() async {
    // Liste des ID des produits dans le panier
    List<String> idProduitsStr = widget.cart.items.map((item) => item.product.id.toString()).toList();
    // Liste des quantités correspondantes
    List<String> quantitesStr = widget.cart.items.map((item) => item.quantity.toString()).toList();


    // Prix total du panier
    double prixTotal = widget.cart.totalPrice;

    // Récupérer l'ID de l'utilisateur connecté (vous devez l'obtenir de votre système d'authentification)
    int idUtilisateur = 7; // ID de l'utilisateur connecté

    // Créer les données à envoyer à l'API
    Map<String, dynamic> data = {
      'id_utilisateur': idUtilisateur.toString(),
      'id_produit': idProduitsStr,
      'quantite': quantitesStr,
      'prix_total': prixTotal.toString(),
    };

    // Envoyer la requête POST à l'API pour enregistrer la commande
    var response = await http.post(
      Uri.parse('http://karlmichel.alwaysdata.net/Commander.php'), // Remplacez par l'URL de votre API PHP
      body: data,
    );
    print(response.body);
    // Vérifier la réponse de l'API et afficher un message approprié
    if (response.statusCode == 200) {
      // La commande a été enregistrée avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    } else {
      // Il y a eu une erreur lors de l'enregistrement de la commande
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement de la commande.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                var cartItem = widget.cart.items[index];
                return ListTile(
                  title: Text(cartItem.product.name),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (cartItem.quantity > 1) {
                              cartItem.quantity--;
                            } else {
                              widget.cart.removeFromCart(cartItem);
                            }
                          });
                        },
                      ),
                      Text('${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            cartItem.quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Récupérer les ID des produits et les quantités depuis le panier
                    List<int> idProduits = widget.cart.items.map((item) => item.product.id).toList();
                    List<int> quantites = widget.cart.items.map((item) => item.quantity).toList();

                    // Convertir les listes en chaînes de caractères séparées par des virgules
                    String idProduitsString = idProduits.join(",");
                    String quantitesString = quantites.join(",");

                    // Prix total depuis le cart
                    double prixTotal = widget.cart.totalPrice;

                    // ID utilisateur (remplacez par votre logique d'authentification)
                    int idUtilisateur = 123; // Exemple d'ID utilisateur

                    // Construire le corps de la requête POST
                    var requestBody = {
                      'id_utilisateur': idUtilisateur.toString(),
                      'id_produits': idProduitsString,
                      'quantites': quantitesString,
                      'prix_total': prixTotal.toString(),
                    };

                    // Envoyer la requête POST à l'API
                    var response = await http.post(Uri.parse('http://karlmichel.alwaysdata.net/Commander.php'), body: requestBody);
                    print(response.body);
                    if (response.statusCode == 200) {
                      // La commande a été enregistrée avec succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Commande enregistrée avec succès.'),
                        ),
                      );
                      // Effacer le panier après la commande
                      setState(() {
                        widget.cart.items.clear();
                      });
                    } else {
                      // Erreur lors de l'enregistrement de la commande
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de l\'enregistrement de la commande.'),
                        ),
                      );
                    }
                  },
                  child: Text('Passer la commande'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}