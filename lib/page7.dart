import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaiser Test 2",
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Recherche(),
    );
  }
}

class Recherche extends StatefulWidget {
  String? get title => null;

  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche"),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context,
            delegate: CustomSearchDelegate(),);
          },
              icon: const Icon(Icons.search),),
        ],
      ),
    );
       // Définissez l'AppBar à null pour masquer l'AppBar lorsque showAppBar est false
  }
}

class  CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

}
