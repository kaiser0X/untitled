import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation.dart';

class AutrePage extends StatefulWidget {
  const AutrePage({super.key});

  @override
  State<AutrePage> createState() => _AutrePageState();
}

class _AutrePageState extends State<AutrePage> {
  int? userId = 0;
  String? Pseudo = '';
  String? Email = '';
  String? Telephone = '';
  void session() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      Pseudo = prefs.getString('userPseudo');
      Email = prefs.getString('userEmail');
      Telephone = prefs.getString('userTelephone');
    });
  }
  @override
  Widget build(BuildContext context) {
    session();
    return Scaffold(
      appBar: AppBar(
        title: Text('Autre Page'),
      ),
      body: ListView(
      children: [
        const SizedBox(height: 50,),

        const Icon(Icons.person,
              size: 72,
        ),
        const SizedBox(height: 10,),

        Text('Email: $Email',
              textAlign: TextAlign.center,
        ),

        Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Détails',
              style: TextStyle(color: Colors.grey[600],
                fontSize: 15.0,),
            ),
        ),
        const SizedBox(height: 10,),

        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            height: 70,
            width: 100.0, // Définissez la largeur souhaitée ici
            decoration: BoxDecoration(// Correction de cette ligne
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: <Widget>[
                  Text('Pseudonyme:',
                  style: TextStyle(
                    fontSize: 20.0, // Définissez la taille de police souhaitée ici
                    // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                  ),),
                  SizedBox(width: 6,),
                  Text('$Pseudo',
                    style: TextStyle(
                      fontSize: 18.0, // Définissez la taille de police souhaitée ici
                      // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                    ),),
                  SizedBox(width: 110.0), // Espace entre l'icône et le texte
                  Icon(
                    Icons.mode_edit, // Choisissez l'icône que vous souhaitez utiliser
                    color: Colors.blue, // Choisissez la couleur de l'icône
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            height: 70,
            width: 40.0, // Définissez la largeur souhaitée ici
            decoration: BoxDecoration(// Correction de cette ligne
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: <Widget>[
                  Text('Numéro:',
                    style: TextStyle(
                      fontSize: 20.0, // Définissez la taille de police souhaitée ici
                      // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                    ),),
                  SizedBox(width: 1,),
                  Text('$Telephone',
                    style: TextStyle(
                      fontSize: 18.0, // Définissez la taille de police souhaitée ici
                      // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                    ),),
                  SizedBox(width: 120.0), // Espace entre l'icône et le texte
                  Icon(
                    Icons.mode_edit, // Choisissez l'icône que vous souhaitez utiliser
                    color: Colors.blue, // Choisissez la couleur de l'icône
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            height: 70,
            width: 20.0, // Définissez la largeur souhaitée ici
            decoration: BoxDecoration(// Correction de cette ligne
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: <Widget>[
                  Text('Email: ',
                    style: TextStyle(
                      fontSize: 20.0, // Définissez la taille de police souhaitée ici
                      // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                    ),),
                  Text('$Email',
                    style: TextStyle(
                      fontSize: 18.0, // Définissez la taille de police souhaitée ici
                      // Vous pouvez également définir d'autres propriétés de style ici si nécessaire
                    ),),
                  SizedBox(width: 40.0), // Espace entre l'icône et le texte
                  Icon(
                    Icons.mode_edit, // Choisissez l'icône que vous souhaitez utiliser
                    color: Colors.blue, // Choisissez la couleur de l'icône
                  ),

                ],
              ),
            ),
          ),
        ),


      ],
    ));
  }
}
//Text('User ID: $userId'),
//Text('Pseudo: $Pseudo'),
//Text('Email: $Email'),
//Text('Téléphone: $Telephone'),
