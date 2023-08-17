import 'package:flutter/material.dart';
import 'package:untitled/page4.dart'; // Importez votre classe Cart ici

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Cart cart;
  final Future<List<Product>> Function() fetchProducts;

  ProductDetailPage({required this.product, required this.cart, required this.fetchProducts});



  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(cart: widget.cart, fetchProducts: widget.fetchProducts),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.blueAccent,),
                ),
                Text('Doc\'Shop',style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18
                ),),
                IconButton(
                  onPressed: (){
                    // Ajoutez l'action du profil ici
                  },
                  icon: Icon(Icons.person, color: Colors.blueAccent,),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      widget.product.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Vous pouvez ajuster le rayon selon vos préférences
                          child: Image.network(widget.product.image),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width/1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,
                          ),
                          child: Text(
                            '${widget.product.description}',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 260),
                        Row( // Utilisation de Row pour aligner horizontalement le prix et le bouton
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajustez l'alignement selon vos préférences
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '\$${widget.product.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.cart.addToCart(widget.product);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${widget.product.name} ajouté au panier'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(90, 60),
                              ),
                              child: Text('Ajouter au panier',
                                style: TextStyle(fontSize: 18
                                )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}