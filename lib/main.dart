import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/classes/quotes.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket App',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(title: 'Cricket Success'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//This represents the content of the main page
class _MyHomePageState extends State<MyHomePage> {
  var index = 0;

  initState() {
    index = 0 + Random().nextInt(quotes.length - 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 0),
      body: new Column(
        children: <Widget>[
          Header().createHeader(context, 0),
          SizedBox(height: 15),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(text: quotes[index], style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14)),
          ),
        ],
      )
    );
  }
}

