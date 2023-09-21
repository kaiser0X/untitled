import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled/DetailCommande.dart';

class Commande {
  final String commande_id;
  final String numero_commande;
  final String total_commande;
  final String date_commande;
  final String statut;

  Commande(this.commande_id, this.numero_commande, this.total_commande, this.date_commande, this.statut);
}

class User_commande extends StatefulWidget {
  const User_commande({super.key});

  @override
  State<User_commande> createState() => _User_commandeState();
}

class _User_commandeState extends State<User_commande> {
  int? userId = 0;
  void session() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }
  Future<List<Commande>> fetchProducts(user_id) async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'users_commande',
      'user_id': user_id.toString()
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['prod_id']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Commande(item['commande_id'], item['numero_commande'], item['total_commande'], item['date_commande'], item['statut'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: FutureBuilder<List<Commande>>(
            future: fetchProducts(userId),
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
                    var commandeItem = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Details_Commande(commande_id : commandeItem.commande_id, total: commandeItem.total_commande,)));
                        },
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(commandeItem.numero_commande,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),),
                                  Text(commandeItem.date_commande),
                                  SizedBox(height: 15,),
                                  Text('${(commandeItem.total_commande)} Fcfa',style: TextStyle(
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
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
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