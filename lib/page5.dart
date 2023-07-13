import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;



class Karl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaiser Test 2",
      home: Visual(),
    );
  }
}

class Visual extends StatefulWidget {
  @override
  _VisualState createState() => _VisualState();
}

class _VisualState extends State<Visual> {
  TextEditingController nomProduitController = TextEditingController();
  TextEditingController descriptionProduitController = TextEditingController();
  TextEditingController prixProduitController = TextEditingController();
  late String choixCategorie = listItem[0];

  List<String> listItem = [
    "T-shirt", "Tasse", "Casquette", "Gourde", "Banderole", "Roll up"
  ];

  File? selectedPhoto;
  @override
  void initState() {
    super.initState();
    choixCategorie = listItem[0];
  }


  void enregistrerProduit() async {
    String nomProduit = nomProduitController.text;
    String descripProd = descriptionProduitController.text;
    String prixProd = prixProduitController.text;
    //String nomCategorie = choixCategorie;

    int indexCategorie = listItem.indexOf(choixCategorie);
    if(indexCategorie  != -1){
      String categorie = (indexCategorie + 1).toString();
      var url = 'http://karlmichel.alwaysdata.net/affiche.php';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['click'] = 'des';
      request.fields['nom_prod'] = nomProduit;
      request.fields['descrption'] = descripProd;
      request.fields['prix'] = prixProd;
      request.fields['nom_categorie'] = categorie;


      if (selectedPhoto != null) {
        String imagePath = selectedPhoto!.path;
        File file = File(imagePath);
        String fileName = file.path.split('/').last;
        request.files.add(await http.MultipartFile.fromPath('photo', imagePath, filename: fileName));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Enregistrement réussi');
      } else {
        print('Échec de la requête avec le code ${response.statusCode}');
      }
    }

    }





  void selectPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedPhoto = File(pickedFile.path);
      });
    }
  }
  Future<void> uploadPhoto(String imagePath) async {
    final String apiUrl = 'http://karlmichel.alwaysdata.net/uploading.php'; // Replace with your API endpoint
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('photo', imagePath));

    File file = File(imagePath);
    String fileName = file.path.split('/').last; // Obtient le nom du fichier sans le chemin complet

    request.fields['photo_prod'] = fileName; // Utilisez le nom du fichier dans les champs de la requête

    var response = await request.send();

    if (response.statusCode == 200) {
      // Photo uploaded successfully
      print(response.headers);
    } else {
      // Error uploading photo
      print('Error uploading photo. Status code: ${response.statusCode}');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrer un produit'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue, width: 2.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nom du produit',
                      hintText: 'Saisir le nom du produit',
                      icon: Icon(Icons.production_quantity_limits, color: Colors.blue, size: 25),
                      border: InputBorder.none,
                    ),
                    controller: nomProduitController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      icon: Icon(Icons.description, color: Colors.blue, size: 25),
                      border: InputBorder.none,
                    ),
                    controller: descriptionProduitController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Prix',
                      icon: Icon(Icons.price_change, color: Colors.blue, size: 25),
                      border: InputBorder.none,
                    ),
                    controller: prixProduitController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<String>(
                    value: choixCategorie,
                    onChanged: (newValue) {
                      setState(() {
                        choixCategorie = newValue!;
                      });
                    },
                    items: listItem.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: selectPhoto,
                    child: Text('Sélectionner une photo'),
                  ),
                  SizedBox(height: 10.0),
                  if (selectedPhoto != null)
                    Image.file(selectedPhoto!),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: enregistrerProduit,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
