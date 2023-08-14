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
                        Image.network(widget.product.image),
                        SizedBox(height: 10),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.product.description,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 240),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
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
                              child: Text('Ajouter au panier'),
                            ),
                          ),
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