import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class Recherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {

    final suggestions = <String>["T-shirt", "Tasse", "Casquette", "Gourde", "Banderole", "Roll up"]; // Liste pour stocker les suggestions de recherche

    // Obtenez la chaîne de recherche saisie par l'utilisateur
    final query = super.query.toLowerCase(); // Utilisez super.query pour accéder à la variable query de SearchDelegate

    // Obtenir les résultats de recherche à partir du serveur PHP
    getSearchResultsFromServer(query).then((results) {
      suggestions.addAll(results);
    }).catchError((error) {
      // Gérer les erreurs éventuelles lors de la requête HTTP
      print('Erreur lors de la recherche : $error');
    });

    // Construire une liste de ListTile pour afficher les suggestions de recherche
    return ListView(
      children: suggestions.map((suggestion) {
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            // Lorsque l'utilisateur appuie sur une suggestion, effectuez l'action souhaitée ici (par exemple, naviguer vers une autre page avec les détails du produit ou de la catégorie).
            // Vous pouvez utiliser le résultat de la requête pour obtenir les détails du produit ou de la catégorie correspondant à la suggestion sélectionnée.
            // Remplacez cette action par votre propre action souhaitée.
            print('Suggestion sélectionnée: $suggestion');
            close(context, suggestion);
          },
        );
      }).toList(),
    );
  }



  // Méthode de requête HTTP pour obtenir les résultats de recherche à partir du serveur
  Future<List<String>> getSearchResultsFromServer(String query) async {
    final url = 'http://karlmichel.alwaysdata.net/recherche.php'; // Remplacez par l'URL de votre fichier PHP

    final response = await http.post(
      Uri.parse(url),
      body: {
        'click': 'rech',
        'query': query,
      },
    );

    if (response.statusCode == 200) {
      // Analyser les données JSON renvoyées par l'API
      final data = json.decode(response.body);

      // Traiter les résultats et retourner la liste de noms ou toute autre donnée que vous souhaitez afficher dans les suggestions.
      List<String> names = [];
      names.addAll(
          data['produits'].map((item) => item['NOM_PROD'] as String));
      names.addAll(
          data['categories'].map((item) => item['NOM_CAT'] as String));

      return names;
    } else {
      // Gérer les erreurs en cas de requête échouée
      throw Exception('Échec de la requête : ${response.statusCode}');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Ici, vous pouvez retourner une liste de widgets d'actions pour la barre de recherche, si nécessaire.
    // Par exemple, vous pouvez ajouter un bouton pour effacer le texte de recherche ou filtrer les résultats.
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Ici, vous pouvez retourner un widget pour l'icône de retour en arrière dans la barre de recherche.
    // Par exemple, vous pouvez utiliser le widget IconButton avec l'icône de retour en arrière.
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Lorsque l'utilisateur appuie sur l'icône de retour en arrière, vous pouvez choisir de fermer simplement la barre de recherche ou d'effectuer une autre action.
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Vérifiez si la requête de recherche est vide
    if (query.isEmpty) {
      return Center(
        child: Text('Entrez un terme de recherche'),
      );
    }

    // Obtenez les résultats de recherche à partir du serveur PHP
    return FutureBuilder<List<String>>(
      future: getSearchResultsFromServer(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erreur lors de la recherche'),
          );
        } else {
          final suggestions = snapshot.data ?? [];

          if (suggestions.isEmpty) {
            return Center(
              child: Text('Aucun résultat trouvé'),
            );
          }

          // Construire une liste de ListTile pour afficher les résultats de recherche
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  // Lorsque l'utilisateur appuie sur une suggestion, effectuez l'action souhaitée ici (par exemple, naviguer vers une autre page avec les détails du produit ou de la catégorie).
                  // Vous pouvez utiliser le résultat de la requête pour obtenir les détails du produit ou de la catégorie correspondant à la suggestion sélectionnée.
                  // Remplacez cette action par votre propre action souhaitée.
                  print('Suggestion sélectionnée: $suggestion');
                  close(context, suggestion);
                },
              );
            },
          );
        }
      },
    );

  }


// Le reste des méthodes buildActions, buildLeading et buildResults peut rester inchangé pour le moment
// Vous pouvez les implémenter si vous en avez besoin à l'avenir.
}
