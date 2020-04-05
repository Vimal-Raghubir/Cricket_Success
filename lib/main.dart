import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/pages/journal.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket App',
      routes: {
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/goal': (context) => Goals(),
      '/journal': (context) => Journal(),
      },
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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 0),
      body: new Column(
        children: <Widget>[
          Header().createHeader(context, 0),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Please click one of the tabs below to begin!',
              softWrap: true,
            ),
          )
        ],
      )
    );
  }
}

