import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/AllProduit.dart';
import 'package:untitled/Produit_categories.dart';
import 'package:untitled/Recherche.dart';
import 'package:untitled/new_details.dart';
import 'package:untitled/panier.dart';
import 'package:untitled/Commande.dart';
import 'package:untitled/Profil_User.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Messenger.dart';


class Product {
  final String id;
  final String name;
  final String cheminImage; // Utilisez le nom correct de la clé
  final String price;

  Product(this.id, this.name, this.cheminImage, this.price);

}

class Category {
  final String id;
  final String name;

  Category(this.id, this.name);
}


class CartItem {
  final Product product;
  int quantity;
  String? size;
  Color? color;

  CartItem(this.product, this.quantity, {this.size, this.color});
}

class Cart {
  List<CartItem> items = [];

  double get totalPrice =>
      items.fold(0, (total, item) => total + int.parse(item.product.price) * item.quantity);

  void addToCart(Product product, String size, Color color, int quantite) {
    CartItem? cartItem;

    for (var item in items) {
      if (item.product.id == product.id && item.size == size && item.color == color) {
        cartItem = item;
        break;
      }
    }

    if (cartItem != null) {
      cartItem.quantity+=quantite;
    } else {
      items.add(CartItem(product, quantite, size: size, color: color));
    }
  }


  void removeFromCart(CartItem cartItem) {
    items.remove(cartItem);
  }
}


class Boutique extends StatefulWidget {
  const Boutique({super.key});

  @override
  State<Boutique> createState() => _BoutiqueState();
}

class _BoutiqueState extends State<Boutique> {
  final Cart cart = Cart();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Product>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'affiche',
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['prod_id']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['prod_id'], item['nom_prod'], item['chemin_image'], item['prix'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';
    var response = await http.post(Uri.parse(url), body: {
      'click': 'CAT',
    });
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category(item['cat_id'], item['nom_cat'])).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: GNav(
        //rippleColor: Colors.grey[800]!,
        //hoverColor: Colors.grey[700]!,
        // tab button hover color
        haptic: true, // haptic feedback
        tabBorderRadius: 15,
        //tabActiveBorder: Border.all(color: Colors.blueAccent, width: 1), // tab button border
        //tabBorder: Border.all(color: Colors.white, width: 1), // tab button border
        //tabShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8)], // tab button shadow
        curve: Curves.easeOutExpo, // tab animation curves
        duration: Duration(milliseconds: 90), // tab animation duration
        gap: 8, // the tab button gap between icon and text
        color: Colors.black, // unselected icon color
        activeColor: Colors.black, // selected icon and text color
        //iconSize: 24, // tab button icon size
        tabBackgroundColor: Colors.blueAccent.withOpacity(0.3), // selected tab background color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Acceuil',),
          GButton(
            icon: Icons.comment,
            text: 'Commande',),
          GButton(
              icon: Icons.shopping_cart,
              text: 'Pannier',
                ),
          GButton(
            icon: Icons.person,
            text: 'Profil',),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Boutique()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => User_commande()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>CartPage(cart: cart,)),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AutrePage()),
              );
              break;
            default:
              setState(() {
                _selectedIndex = index;
              });
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.messenger),
              title: Text('Message'),
              onTap: () {
                Navigator.pop(context); // Ferme le menu
                //Navigator.push(
                  //context,
                 // MaterialPageRoute(builder: (context) => Messagerie()),
               // ); // Navigue vers la page des commandes
              },
            ),
            ListTile(
              leading: Icon(Icons.heart_broken),
              title: Text('Like'),
              onTap: () {
                Navigator.pop(context); // Ferme le menu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AutrePage()),
                ); // Navigue vers la page des commandes
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  _scaffoldKey.currentState?.openDrawer();
                }, icon: Icon(Icons.menu_rounded)),
                Text('Doc\'Shop',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,

                  ),)
                ,
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(cart: cart,)));
                      },
                      icon: Icon(CupertinoIcons.cart_fill),
                    ),
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, SizeTransition5(SecondPage()));
                        },
                        icon: Icon(Icons.search)
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Nouveauté',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),),

                  ],
                ),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ToutProduits(cart: cart,)));
                    },
                    child: Text('Tout voir',style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueAccent,
                    ),))
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width / 1.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 190.0, // Hauteur du carousel
                viewportFraction: 1.0, // Fraction de la largeur de l'écran occupée par l'image
                autoPlay: true, // Activer le défilement automatique
                autoPlayInterval: Duration(seconds: 5), // Intervalle de temps entre les diapositives
                autoPlayAnimationDuration: Duration(milliseconds: 800), // Durée de l'animation
                autoPlayCurve: Curves.fastOutSlowIn, // Courbe d'animation
                pauseAutoPlayOnTouch: true, // Mettre en pause le défilement automatique lorsqu'on touche le carousel
                enlargeCenterPage: false, // Agrandir la diapositive centrale
              ),
              items: [
                // Liste des éléments du carousel
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black26,
                    image: DecorationImage(
                      image: AssetImage('lib/images/mugs.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black26,
                    image: DecorationImage(
                      image: AssetImage('lib/images/mugs.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Autres éléments du carousel...
              ],
            ),
          ),

          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 24),
            child: Row(
              children: [
                Text('Categories',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 50,
            child: FutureBuilder<List<Category>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var category = snapshot.data![index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryProductsPage(cart: cart, category: category),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 10,
                            width: 90,
                            decoration:
                            BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Center(
                              child: Text(category.name, style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 24),
            child: Row(
              children: [
                Text('Populaires',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(child: FutureBuilder<List<Product>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Aucun produit n\'a ete commandé.'),);
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var product = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => productDetailPage(product: product, cart: cart),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2.9,
                            decoration:
                            BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => productDetailPage(product: product, cart: cart),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      //color: Colors.red,
                                      width: MediaQuery.of(context).size.width/3.5,
                                      child: Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: MediaQuery.of(context).size.width/3.6,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          product.cheminImage
                                                      ),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Text(product.name,style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),),
                                            Text(product.price+" Fcfa",style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 18,
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}
