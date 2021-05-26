import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NumberList extends StatefulWidget {
  @override
  _NumberListState createState() => _NumberListState();
}

class _NumberListState extends State<NumberList> {
  final Stream<QuerySnapshot> _numbersStream =
      FirebaseFirestore.instance.collection('numbers').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
      stream: _numbersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document.data()['number'].toString()),
              subtitle: new Text(document.data()['timeStamp'].toString()),
            );
          }).toList(),
        );
      },
    )));
  }
}
