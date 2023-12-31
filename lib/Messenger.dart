import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:untitled/previsualisation.dart';

class Message {
  final int conversation_id;
  final int recieve_id;
  final int send_id;
  final String message;
  final String send_date;
  final String doc_id;

  Message(this.conversation_id, this.recieve_id, this.send_id, this.message, this.send_date, this.doc_id);
}

class Messagerie extends StatefulWidget {
  var receive_id, nom_amie, send_id;
  Messagerie({this.receive_id, this.nom_amie, this.send_id});

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  Map<String, String?> imageUrls = {};
  TextEditingController message = TextEditingController();
  String selectedFileName = '';
  String? pdfPath;
  String receiver = "";

  Future<List<Message>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'read_message',
      'send_id': widget.send_id.toString(),
      'receive_id': widget.receive_id.toString(),
    });

    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['conversation_id']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Message(item['conversation_id'], item['send_id'], item['receive_id'], item['libelle'], item['date_envoye'], item['doc_id'])).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void Send_message() async{
    var url = 'http://karlmichel.alwaysdata.net/api.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'send_message',
      'send_id': widget.send_id.toString(),
      'receive_id': widget.receive_id.toString(),
      'message': message.text
    });
    print(response.body);
    if(response.statusCode == 200){
      if(response.body == "oui"){
        print('message envoye');
        message.clear();
        setState(() {
          fetchProducts();
        });
      }else{
        print('message non envoye');
      }
    }else{
      print("Erreur lors de l'execution de la requete");
    }
  }

  Future<void> read_document(doc_id) async{
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'documents',
      'doc_id': doc_id
    });

    if (response.statusCode == 200) {
      setState(() {
        imageUrls[doc_id] = "http://karlmichel.alwaysdata.net/"+json.decode(response.body)[0]['file_path'];
      });
    } else {
      throw Exception('Failed to load documet');
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    print('object');
    if (result != null) {
      String? fileType = result.files.single.extension;

      if (fileType == 'pdf') {
        // Rediriger vers la page Previsualiser pour les fichiers PDF
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Previsualiser(
              nom_doc: result.files.single.name,
              chemin_doc: result.files.single.path,
              isImage: false,
              nom_amie: widget.nom_amie,
              receive_id: widget.receive_id,
              send_id: widget.send_id,
            ),
          ),
        );
      } else if (fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png') {
        // Rediriger vers la page Previsualiser pour les images
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Previsualiser(
              nom_doc: result.files.single.name,
              chemin_doc: result.files.single.path,
              isImage: true,
              nom_amie: widget.nom_amie,
              receive_id: widget.receive_id,
            ),
          ),
        );
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    fetchProducts();
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white,),
              ),
            ),
            SizedBox(width: 10,),
            Text('Gerant'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SizedBox(width: 10,),
            Container(
              width: MediaQuery.of(context).size.width/1.3,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width/1.75,
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
                              hintText: 'Ecrire votre message...'
                          ),
                        ),
                      )
                  ),
                  SizedBox(width: 5,),
                  Container(
                    child: Container(
                      width: 70,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: pickFile,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Définit la couleur de fond à noir
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Supprime les bordures
                            ),
                          ),
                        ),
                        child: Center(child: Icon(Icons.attach_file_outlined, color: Colors.white,)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              child: Container(
                width: 65,
                height: 56,
                child: ElevatedButton(
                  onPressed: (){
                    Send_message();
                  },
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
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
          child: FutureBuilder<List<Message>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data![index];
                    String? imageUrl = imageUrls[message.doc_id];
                    if (imageUrl == null) {
                      // Si l'URL n'est pas encore disponible, appelez read_document pour la récupérer
                      read_document(message.doc_id);
                    }
                    if(message.send_id == widget.send_id){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: message.doc_id != "0" ?200:100,
                              width: MediaQuery.of(context).size.width/1.2,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  message.doc_id != "0"
                                      ?GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Voir_plus(message: message.message, date: message.send_date, document: imageUrl,)));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/1.25,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(imageUrl!),
                                              fit: BoxFit.cover
                                          )),
                                    ),
                                  )
                                      :Container(),
                                  Text(message.message,style: TextStyle(
                                      color: Colors.white
                                  ),),
                                  Text(message.send_date,style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }else{
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height:message.doc_id != "0"
                                  ?200:100,
                              width: MediaQuery.of(context).size.width/1.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5,),
                                  message.doc_id != "0"
                                      ?GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Voir_plus(message: message.message, date: message.send_date, document: imageUrl,)));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/1.25,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(imageUrl!),
                                              fit: BoxFit.cover
                                          )),
                                    ),
                                  )
                                      :Container(),
                                  Text(message.message,style: TextStyle(
                                      color: Colors.black54
                                  ),),
                                  Text(message.send_date,style: TextStyle(
                                      color: Colors.black54
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
          ),),
      ),
    );
  }
}

class Voir_plus extends StatefulWidget {
var message, date, document;
Voir_plus({this.date, this.message, this.document});

@override
State<Voir_plus> createState() => _Voir_plusState();
}

class _Voir_plusState extends State<Voir_plus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('vous'),
            Text(widget.date),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        child: Center(child: Text(widget.message,style: TextStyle(color: Colors.white),)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(widget.document))
        ),
      ),
    );
  }
}
