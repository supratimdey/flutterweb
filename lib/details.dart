import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget{
  //final int index;
  final QueryDocumentSnapshot documentSnapshot;

  DetailPage(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poem Page"),
      ),
      body: Center(
        child: Expanded(
                child: Text(documentSnapshot['item'],maxLines: 5,
                    overflow: TextOverflow.ellipsis) ,)
      ),
    );
  }
}

