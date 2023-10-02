import 'package:flutter/material.dart';

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