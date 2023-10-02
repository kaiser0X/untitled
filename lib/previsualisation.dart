import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Messenger.dart';

class Previsualiser extends StatefulWidget {
  var nom_doc, chemin_doc, nom_amie, receive_id;
  final bool isImage;
  Previsualiser({this.nom_doc, this.chemin_doc, required this.isImage, this.nom_amie,  this.receive_id});

  @override
  State<Previsualiser> createState() => _PrevisualiserState();
}

class _PrevisualiserState extends State<Previsualiser> {
  TextEditingController message = TextEditingController();
  String selectedFileName = '';
  String? filePath;
  int? uploadedFileId;
  int? userId = 0;
  String? Pseudo = '';
  String? Email = '';
  String? Telephone = '';

  Future<void> uploadFile() async {
    if (widget.chemin_doc != null) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://karlmichel.alwaysdata.net/upload_document.php'),
        );

        request.files.add(await http.MultipartFile.fromPath(
          'file',
          widget.chemin_doc!,
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          // Récupérer l'ID du fichier enregistré depuis la réponse
          var responseData = await response.stream.bytesToString();
          uploadedFileId = int.tryParse(responseData);
          if (uploadedFileId != null) {
            print('Fichier enregistré avec ID: $uploadedFileId');
            Send_message(uploadedFileId);
          } else {
            print('Erreur lors de la récupération de l\'ID du fichier.');
          }
        } else {
          print('Erreur lors de l\'envoi du fichier : ${response.statusCode}');
        }
      } catch (e) {
        print('Erreur lors de l\'envoi du fichier : $e');
      }
    }
  }

  void session() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      Pseudo = prefs.getString('userPseudo');
      Email = prefs.getString('userEmail');
      Telephone = prefs.getString('userTelephone');
    });
  }

  void Send_message(doc_id) async{
    var url = 'http://karlmichel.alwaysdata.net/api.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'send_message',
      'send_id': userId,
      'receive_id': widget.receive_id.toString(),
      'message': message.text,
      'doc_id': doc_id.toString()
    });
    print(response.body);
    if(response.statusCode == 200){
      if(response.body == "oui"){
        print('message envoye');
        message.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Messagerie(receive_id :widget.receive_id, nom_amie: widget.nom_amie,)));
      }else{
        print('message non envoye');
      }
    }else{
      print("Erreur lors de l'execution de la requete");
    }
  }
  @override
  Widget build(BuildContext context) {
    session();
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text(widget.nom_doc),
      ),
      body: Center(
        child: widget.isImage
            ? Image.file(
          File(widget.chemin_doc!),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.contain,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 100, color: Colors.white,),
            SizedBox(height: 20),
            Text(
              'Nom du document: ${widget.nom_doc}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Poids du document: ...', // Ajoutez la logique pour obtenir le poids du document
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        color: Colors.black54,
        child: Column(
          children: [
            SizedBox(height: 15,),
            Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: message,
                    decoration: InputDecoration(
                        hintText: 'Ajouter une legende...'
                    ),
                  ),
                )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1.9,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(widget.nom_amie, style: TextStyle(
                          color: Colors.white
                      ),),
                    ),
                  ),
                  Container(
                    child: Container(
                      width: 70,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: uploadFile,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Définit la couleur de fond à noir
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Supprime les bordures
                            ),
                          ),
                        ),
                        child: Center(child: Icon(Icons.send_rounded, color: Colors.white,)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}