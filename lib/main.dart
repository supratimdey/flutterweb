import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterweb/details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              //check for errors
              if (snapshot.hasError) {
                print("Error:1");
                return Center(child: Text(snapshot.error.toString()));
              }
              // once complte
              if (snapshot.connectionState == ConnectionState.done) {
                return MyHomePage(title: 'Flutter Demo Home Page');
              }
              // show loading
              return Center(child: CircularProgressIndicator());
            }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('kobita').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.hasError) {
            print("Error: in StreamBuilder");
            return Center(child: Text(snapshots.error.toString()));
          }

          if (snapshots.connectionState == ConnectionState.waiting) {
            print("Progress in streambuilder...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshots.hasData == null) {
            return Center(child: Text("No Data Available..."));
          }
          return ListView.separated(
            itemBuilder: (context, index)
             {
              return makePoemListContainer(snapshots, index);
              },
            itemCount: snapshots.data.docs.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          );
        },),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget makePoemListContainer(AsyncSnapshot<QuerySnapshot> snapshots,index){
    return Container(
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.black12),
        margin: const EdgeInsets.fromLTRB(8.0,4.0,8.0,0.0),
        height: 80,
        child: makePoemListTitles(context,snapshots, index)
    );
  }

    Widget makePoemListTitles (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots,index) {
    return ListTile(
      title: Text(snapshots.data.docs[index]['title']),
      subtitle: Text(snapshots.data.docs[index]['kobi']),
      leading: Icon(Icons.thumb_up) ,
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context)
            => DetailPage(snapshots.data.docs[index]))
        );
      },
    );
  }

}
