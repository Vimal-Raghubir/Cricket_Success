import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';


//Used to handle the tutorial page
class Tutorials extends StatefulWidget {
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 2),
      body: Column(
        children: <Widget> [
          Header().createHeader(context, 2),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Please see below!',
              softWrap: true,
            ),
          )
        ]
      ),
    );
  }
}